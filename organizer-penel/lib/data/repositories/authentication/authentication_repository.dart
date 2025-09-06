import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:yt_ecommerce_admin_panel/routes/routes.dart';
import 'package:yt_ecommerce_admin_panel/utils/exceptions/firebase_auth_exceptions.dart';
import 'package:yt_ecommerce_admin_panel/utils/exceptions/firebase_exceptions.dart';
import 'package:yt_ecommerce_admin_panel/utils/exceptions/format_exceptions.dart';
import 'package:yt_ecommerce_admin_panel/utils/exceptions/platform_exceptions.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  //firebase auth instance
  final _auth = FirebaseAuth.instance;

  //get authenticated user
  User? get authUser => _auth.currentUser;

  //is user authenticated
  bool get isAuthenticated => _auth.currentUser != null;

  @override
  void onReady() {
    _auth.setPersistence(Persistence.LOCAL);
  }

  void screenRedirect() async {
    final user = _auth.currentUser;

    if (user != null) {
      Get.offAllNamed(TRoutes.dashboard);
    } else {
      Get.offAllNamed(TRoutes.login);
    }
  }

  //login
  Future<UserCredential> loginWithEmailAndPassword(
      String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again later.';
    }
  }

  //register
  Future<UserCredential> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'something went wrong. please try again later.';
    }
  }

  //logout
  ///
  /// This method clears local storage flags related to the user session,
  /// signs the user out from Firebase Authentication,
  /// and then navigates the user to the login screen.
  Future<void> logout() async {
    // --- 1. Clear Local Storage First ---
    // Clearing local storage early ensures the app state reflects logout
    // even if the Firebase sign-out fails.
    try {
      debugPrint("Logout: Clearing local storage flags.");
      // Clear the flag indicating the user is logged in
      await GetStorage().remove('user_logged_in');
      // Clear any stored credentials if 'Remember Me' was used
      await GetStorage().remove('REMEMBER_ME_EMAIL');
      await GetStorage().remove('REMEMBER_ME_PASSWORD');
      // Add any other user-specific local storage keys you need to clear here
      // e.g., await GetStorage().remove('USER_PROFILE_DATA');
      debugPrint("Logout: Local storage flags cleared successfully.");
    } catch (storageError) {
      // Log the error but don't necessarily stop the logout process
      // because the main goal is to sign out of Firebase.
      debugPrint("Logout Warning: Error clearing local storage: $storageError");
      // Optionally, show a non-blocking warning to the user if critical data couldn't be cleared
      // TLoaders.warningSnackBar(title: 'Warning', message: 'Some local data might not have been cleared.');
    }

    // --- 2. Sign Out from Firebase Authentication ---
    try {
      debugPrint("Logout: Initiating Firebase sign-out.");
      final User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        await FirebaseAuth.instance.signOut();
        debugPrint(
            "Logout: User '${currentUser.uid}' signed out successfully from Firebase.");
      } else {
        debugPrint("Logout: No user was signed in to Firebase.");
      }
    } on FirebaseAuthException catch (e) {
      // Handle specific Firebase Authentication errors during sign-out
      debugPrint(
          "Logout Error: FirebaseAuthException during signOut: ${e.code} - ${e.message}");
      // While signOut usually doesn't fail, it's good practice to handle it.
      // You might choose to show an error snackbar or log it differently.
      // Rethrowing might not be necessary as we still want to redirect.
      // Example: TLoaders.errorSnackBar(title: 'Logout Error', message: 'Could not complete sign out: ${TFirebaseAuthException(e.code).message}');
    } on FirebaseException catch (e) {
      // Handle other Firebase related errors
      debugPrint(
          "Logout Error: FirebaseException during signOut: ${e.code} - ${e.message}");
      // Example: TLoaders.errorSnackBar(title: 'Logout Error', message: 'Firebase error during logout: ${TFirebaseException(e.code).message}');
    } on PlatformException catch (e) {
      // Handle platform-specific errors
      debugPrint(
          "Logout Error: PlatformException during signOut: ${e.code} - ${e.message}");
      // Example: TLoaders.errorSnackBar(title: 'Logout Error', message: 'Platform error during logout: ${TPlatformException(e.code).message}');
    } catch (e) {
      // Catch any other unexpected errors during Firebase sign-out
      debugPrint("Logout Error: Unexpected error during Firebase signOut: $e");
      // Example: TLoaders.errorSnackBar(title: 'Unexpected Error', message: 'An unexpected error occurred during logout.');
    }

    // --- 3. Redirect to Login Screen ---
    // Regardless of whether the Firebase sign-out succeeded or failed,
    // clear the navigation stack and go to the login screen.
    // This ensures the UI reflects the logged-out state.
    try {
      debugPrint("Logout: Redirecting to login screen.");
      // Use Get.offAllNamed to replace the entire navigation stack with the login route.
      Get.offAllNamed(TRoutes.login);
      debugPrint("Logout: Navigation to login screen initiated.");
    } catch (navError) {
      // Handle potential errors during navigation (rare, but good to log)
      debugPrint("Logout Error: Failed to navigate to login screen: $navError");
      // If navigation fails, the app might be in an inconsistent state.
      // Depending on your app's structure, you might try Get.offAll(() => LoginScreen())
      // or show a critical error message.
    }
  }
}
