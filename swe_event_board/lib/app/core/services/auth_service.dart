import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/student_model.dart';
import 'storage_service.dart';

class AuthService {
  final SupabaseClient _supabase = Get.find();
  final StorageService _storageService = Get.find();

  // Get current session
  Session? get currentSession => _supabase.auth.currentSession;

  // Get current user
  User? get currentUser => _supabase.auth.currentUser;

  // Check if user is authenticated
  bool get isAuthenticated => currentUser != null;

  // Sign up with email and password
  Future<User> signUpWithEmail({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          'first_name': firstName,
          'last_name': lastName,
          'user_type': 'student', // For role-based access
        },
      );

      if (response.user == null) {
        throw Exception('Signup failed: User not created');
      }

      // Create student profile
      await _createStudentProfile(response.user!, firstName, lastName);

      // Save session
      await _storageService.saveSession(response.user!.id);

      return response.user!;
    } on AuthException catch (e) {
      throw _parseAuthError(e);
    } catch (e) {
      throw Exception('Signup failed: ${e.toString()}');
    }
  }

  // Sign in with email and password
  Future<User> signInWithEmail(String email, String password) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw Exception('Login failed: Invalid credentials');
      }

      // Save session
      await _storageService.saveSession(response.user!.id);

      return response.user!;
    } on AuthException catch (e) {
      throw _parseAuthError(e);
    } catch (e) {
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  // Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email);
    } on AuthException catch (e) {
      throw _parseAuthError(e);
    } catch (e) {
      throw Exception('Password reset failed: ${e.toString()}');
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
      await _storageService.clearSession();
    } catch (e) {
      throw Exception('Logout failed: ${e.toString()}');
    }
  }

  // Create student profile in database
  Future<void> _createStudentProfile(
    User user,
    String firstName,
    String lastName,
  ) async {
    try {
      final student = Student(
        id: user.id,
        email: user.email!,
        firstName: firstName,
        lastName: lastName,
        studentId: null,
        department: null,
        profilePicUrl: null,
      );

      final response = await _supabase.from('students').insert(student.toMap());

      if (response.error != null) {
        // Rollback user creation if profile fails?
        throw Exception('Profile creation failed: ${response.error!.message}');
      }
    } catch (e) {
      throw Exception('Profile creation failed: ${e.toString()}');
    }
  }

  // Parse auth errors to user-friendly messages
  String _parseAuthError(AuthException e) {
    switch (e.message) {
      case 'Email rate limit exceeded':
        return 'Too many attempts. Please try again later.';
      case 'Invalid login credentials':
        return 'Invalid email or password. Please try again.';
      case 'User already registered':
        return 'An account with this email already exists.';
      case 'Email not confirmed':
        return 'Please verify your email before logging in.';
      case 'Password should be at least 6 characters':
        return 'Password must be at least 6 characters long.';
      default:
        return 'Authentication error: ${e.message}';
    }
  }
}
