import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../widgets/error_snackbar.dart';
import '../../widgets/help_snackbar.dart';
import '../form_validation/form_validator.dart';

class FirebaseHelper {
  final _auth = FirebaseAuth.instance;
  // To get the current user
  User? get user => _auth.currentUser;

  // Register User
  Future<String?> register({
    required String regEmail,
    required String regPass,
    required String regUsername,
  }) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: regEmail, password: regPass);
      User? user = result.user;

      if (user != null) {
        await user.updateDisplayName(
            regUsername); // Awaiting this to ensure errors are caught
      }
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return "An unknown error occurred.";
    }
  }

  // Login User
  Future<String?> login({
    required String loginEmail,
    required String loginPass,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: loginEmail, password: loginPass);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return "An unknown error occurred.";
    }
  }

  // Logout User
  Future<void> logout() async {
    await _auth.signOut();
  }

  // Reset Password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? "An unknown error occurred.");
    }
  }

  Future<void> forgotPassword(BuildContext context, String email) async {
    // Use the custom form validator
    String? validationMessage = FormValidator.simpleEmailValidator(email);

    if (validationMessage != null) {
      showError(context, 'Invalid Email', validationMessage);
      return;
    }

    try {
      await FirebaseHelper().resetPassword(email);
      if (context.mounted) {
        showHelp(
          context,
          'Password Reset',
          'A password reset link has been sent to your email.',
        );
      }
    } on FirebaseAuthException catch (e) {
      // Handle Firebase-specific errors
      if (context.mounted) {
        showError(context, 'Error', e.message ?? 'An unknown error occurred.');
      }
    } catch (error) {
      // Handle other errors
      if (context.mounted) {
        showError(context, 'Error', error.toString());
      }
    }
  }

  bool isSignedIn() {
    return user != null;
  }

  String? getUserName() {
    return user?.displayName;
  }
}
