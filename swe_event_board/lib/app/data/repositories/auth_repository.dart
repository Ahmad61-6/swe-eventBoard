import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository extends GetxService {
  final _supabase = Get.find<SupabaseClient>();

  Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    final response = await _supabase.auth.signUp(
      email: email,
      password: password,
    );

    if (response.user != null) {
      await _createStudentProfile(response.user!, firstName, lastName);
    }

    return response;
  }

  Future<void> _createStudentProfile(
    User user,
    String firstName,
    String lastName,
  ) async {
    await _supabase.from('students').insert({
      'id': user.id,
      'email': user.email,
      'first_name': firstName,
      'last_name': lastName,
    });
  }

  Future<AuthResponse> login(String email, String password) =>
      _supabase.auth.signInWithPassword(email: email, password: password);

  Future<void> resetPassword(String email) =>
      _supabase.auth.resetPasswordForEmail(email);

  Future<void> signOut() => _supabase.auth.signOut();

  User? get currentUser => _supabase.auth.currentUser;
}
