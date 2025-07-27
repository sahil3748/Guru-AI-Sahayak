import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Basic Google Sign-In with minimal permissions
  late final GoogleSignIn _basicGoogleSignIn = GoogleSignIn(
    signInOption: SignInOption.standard,
    scopes: ['email', 'profile'],
  );

  // Google Sign-In with classroom permissions for when user accesses classroom features
  late final GoogleSignIn _classroomGoogleSignIn = GoogleSignIn(
    signInOption: SignInOption.standard,
    scopes: [
      'email',
      'profile',
      'https://www.googleapis.com/auth/classroom.courses.readonly',
      'https://www.googleapis.com/auth/classroom.rosters.readonly',
      'https://www.googleapis.com/auth/classroom.profile.emails',
      'https://www.googleapis.com/auth/classroom.profile.photos',

      // Course management
      'https://www.googleapis.com/auth/classroom.courses',
      'https://www.googleapis.com/auth/classroom.courses.readonly',

      // Roster management
      'https://www.googleapis.com/auth/classroom.rosters',
      'https://www.googleapis.com/auth/classroom.rosters.readonly',
      'https://www.googleapis.com/auth/classroom.profile.emails',
      'https://www.googleapis.com/auth/classroom.profile.photos',

      // Announcements
      'https://www.googleapis.com/auth/classroom.announcements',
      'https://www.googleapis.com/auth/classroom.announcements.readonly',

      // Coursework (including quizzes)
      'https://www.googleapis.com/auth/classroom.coursework.students',
      'https://www.googleapis.com/auth/classroom.coursework.students.readonly',
      'https://www.googleapis.com/auth/classroom.coursework.me',
      'https://www.googleapis.com/auth/classroom.coursework.me.readonly',

      // Topics
      'https://www.googleapis.com/auth/classroom.topics',
      'https://www.googleapis.com/auth/classroom.topics.readonly',

      // Student submissions
      'https://www.googleapis.com/auth/classroom.student-submissions.students.readonly',
      'https://www.googleapis.com/auth/classroom.student-submissions.me.readonly',

      // Guardian access
      'https://www.googleapis.com/auth/classroom.guardianlinks.students',
      'https://www.googleapis.com/auth/classroom.guardianlinks.me.readonly',

      // Push notifications
      'https://www.googleapis.com/auth/classroom.push-notifications',

      // Drive access for classroom materials
      'https://www.googleapis.com/auth/drive.readonly',
      'https://www.googleapis.com/auth/drive.file',
    ],
  );

  // Stream to listen to auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Current user
  User? get currentUser => _auth.currentUser;

  // Track sign in state
  bool _isSigningIn = false;
  bool _hasClassroomPermissions = false;

  // Basic sign in with Google (only email and profile)
  Future<UserCredential?> signInWithGoogle() async {
    // Prevent multiple simultaneous sign-in attempts
    if (_isSigningIn) {
      throw StateError('Sign-in already in progress');
    }

    try {
      _isSigningIn = true;

      // First, try to sign out any existing session
      try {
        if (_basicGoogleSignIn.currentUser != null) {
          await _basicGoogleSignIn.disconnect();
          await _basicGoogleSignIn.signOut();
        }
      } catch (e) {
        print('Pre-signout error (can be ignored): $e');
      }

      // Trigger the authentication flow with retry mechanism
      GoogleSignInAccount? googleUser;
      int retryCount = 0;
      while (googleUser == null && retryCount < 2) {
        try {
          googleUser = await _basicGoogleSignIn.signIn().timeout(
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
    } finally {
      _isSigningIn = false;
    }
  }

  // Request classroom permissions when user tries to access classroom features
  Future<bool> requestClassroomPermissions() async {
    if (_hasClassroomPermissions) {
      return true; // Already have permissions
    }

    try {
      // First sign out from basic Google Sign-In
      await _basicGoogleSignIn.signOut();

      // Sign in with classroom permissions
      final GoogleSignInAccount? googleUser = await _classroomGoogleSignIn
          .signIn();

      if (googleUser == null) {
        return false; // User cancelled the permission request
      }

      // Get the authentication details
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create new credential with classroom permissions
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Re-authenticate with Firebase using the new credential
      await _auth.signInWithCredential(credential);

      _hasClassroomPermissions = true;
      return true;
    } catch (e) {
      print('Error requesting classroom permissions: $e');
      return false;
    }
  }

  // Check if user has classroom permissions
  bool get hasClassroomPermissions => _hasClassroomPermissions;

  // Get access token for API calls (will have classroom permissions if granted)
  Future<String?> getAccessToken() async {
    try {
      final GoogleSignInAccount? account = _hasClassroomPermissions
          ? _classroomGoogleSignIn.currentUser
          : _basicGoogleSignIn.currentUser;

      if (account == null) return null;

      final GoogleSignInAuthentication auth = await account.authentication;
      return auth.accessToken;
    } catch (e) {
      print('Error getting access token: $e');
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      // Sign out from both Google Sign-In instances and Firebase
      await Future.wait([
        _auth.signOut(),
        _basicGoogleSignIn.signOut(),
        _classroomGoogleSignIn.signOut(),
      ]);
      _hasClassroomPermissions = false;
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  // Check if the user is signed in with Google
  bool isSignedInWithGoogle() {
    // Check if user is signed in with Firebase and the provider is Google
    final currentUser = _auth.currentUser;
    if (currentUser == null) return false;

    // Check if the user has signed in with Google provider
    return currentUser.providerData.any(
      (userInfo) => userInfo.providerId == 'google.com',
    );
  }

  // Attempt to silently sign in the user (token refresh without UI)
  Future<UserCredential?> silentSignIn() async {
    try {
      // Try to silently sign in with basic Google Sign-In
      final GoogleSignInAccount? googleUser = await _basicGoogleSignIn
          .signInSilently();
      if (googleUser == null) return null;

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      print('Error in silent sign-in: $e');
      return null;
    }
  }
}
