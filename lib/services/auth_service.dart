import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late final GoogleSignIn _googleSignIn = GoogleSignIn(
    signInOption: SignInOption.standard,
    scopes: ['email', 'profile'],
  );

  // Stream to listen to auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Current user
  User? get currentUser => _auth.currentUser;

  // Track sign in state
  bool _isSigningIn = false;

  // Sign in with Google
  Future<UserCredential?> signInWithGoogle() async {
    // Prevent multiple simultaneous sign-in attempts
    if (_isSigningIn) {
      throw StateError('Sign-in already in progress');
    }

    try {
      _isSigningIn = true;

      // First, try to sign out any existing session
      try {
        if (_googleSignIn.currentUser != null) {
          await _googleSignIn.disconnect();
          await _googleSignIn.signOut();
        }
      } catch (e) {
        print('Pre-signout error (can be ignored): $e');
      }

      // Trigger the authentication flow with retry mechanism
      GoogleSignInAccount? googleUser;
      int retryCount = 0;
      while (googleUser == null && retryCount < 2) {
        try {
          googleUser = await _googleSignIn.signIn().timeout(
            const Duration(seconds: 30),
            onTimeout: () {
              throw TimeoutException('Sign in timeout');
            },
          );
        } catch (e) {
          retryCount++;
          if (retryCount >= 2) rethrow;
          await Future.delayed(Duration(seconds: 1));
        }
      }

      if (googleUser == null) return null;

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser
          .authentication
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () {
              throw TimeoutException('Authentication timeout');
            },
          );

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      print('Error signing in with Google: $e');
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await Future.wait([_auth.signOut(), _googleSignIn.signOut()]);
    } catch (e) {
      print('Error signing out: $e');
    }
  }
}
