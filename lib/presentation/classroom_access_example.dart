import 'package:flutter/material.dart';
import 'package:guru_ai/services/auth_service.dart';

/// Example widget demonstrating the new permission-based classroom access
///
/// This example shows how to:
/// 1. Sign in with basic Google permissions first
/// 2. Request classroom permissions only when user needs to access classroom features
/// 3. Handle permission states properly
class ClassroomAccessExample extends StatefulWidget {
  const ClassroomAccessExample({Key? key}) : super(key: key);

  @override
  State<ClassroomAccessExample> createState() => _ClassroomAccessExampleState();
}

class _ClassroomAccessExampleState extends State<ClassroomAccessExample> {
  final AuthService _authService = AuthService();

  bool _isSigningIn = false;
  bool _isRequestingPermissions = false;
  String? _statusMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Classroom Access Example'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'New Permission Flow Example',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Status display
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Current Status:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'User signed in: ${_authService.currentUser != null ? "Yes" : "No"}',
                  ),
                  Text(
                    'Has classroom permissions: ${_authService.hasClassroomPermissions ? "Yes" : "No"}',
                  ),
                  if (_statusMessage != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Status: $_statusMessage',
                      style: const TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Step 1: Basic Sign In
            const Text(
              'Step 1: Basic Google Sign In',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            const Text(
              'Sign in with just email and profile permissions. No classroom permissions requested yet.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _authService.currentUser != null
                  ? null
                  : _signInWithGoogle,
              child: _isSigningIn
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Sign In with Google'),
            ),

            const SizedBox(height: 30),

            // Step 2: Classroom Permission Request
            const Text(
              'Step 2: Request Classroom Access',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            const Text(
              'Only request classroom permissions when user wants to access classroom features.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed:
                  _authService.currentUser == null ||
                      _authService.hasClassroomPermissions
                  ? null
                  : _requestClassroomPermissions,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: _isRequestingPermissions
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'Access My Classroom',
                      style: TextStyle(color: Colors.white),
                    ),
            ),

            const SizedBox(height: 30),

            // Step 3: Use Classroom Features
            const Text(
              'Step 3: Use Classroom Features',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            const Text(
              'Now you can access classroom data and features.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _authService.hasClassroomPermissions
                  ? _showClassroomFeatures
                  : null,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
              child: const Text(
                'Show Classroom Features',
                style: TextStyle(color: Colors.white),
              ),
            ),

            const Spacer(),

            // Sign Out
            if (_authService.currentUser != null)
              ElevatedButton(
                onPressed: _signOut,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text(
                  'Sign Out',
                  style: TextStyle(color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      _isSigningIn = true;
      _statusMessage = 'Signing in...';
    });

    try {
      final result = await _authService.signInWithGoogle();

      setState(() {
        _isSigningIn = false;
        _statusMessage = result != null
            ? 'Successfully signed in with basic permissions!'
            : 'Sign in was cancelled or failed';
      });
    } catch (e) {
      setState(() {
        _isSigningIn = false;
        _statusMessage = 'Error during sign in: $e';
      });
    }
  }

  Future<void> _requestClassroomPermissions() async {
    setState(() {
      _isRequestingPermissions = true;
      _statusMessage = 'Requesting classroom permissions...';
    });

    try {
      final granted = await _authService.requestClassroomPermissions();

      setState(() {
        _isRequestingPermissions = false;
        _statusMessage = granted
            ? 'Classroom permissions granted! You can now access classroom features.'
            : 'Classroom permissions were denied or cancelled.';
      });
    } catch (e) {
      setState(() {
        _isRequestingPermissions = false;
        _statusMessage = 'Error requesting classroom permissions: $e';
      });
    }
  }

  void _showClassroomFeatures() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Classroom Features Available'),
        content: const Text(
          'Great! You now have access to:\n\n'
          '• View your courses\n'
          '• Manage assignments\n'
          '• Access student rosters\n'
          '• Create announcements\n'
          '• And much more!',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _signOut() async {
    try {
      await _authService.signOut();
      setState(() {
        _statusMessage = 'Signed out successfully';
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Error during sign out: $e';
      });
    }
  }
}
