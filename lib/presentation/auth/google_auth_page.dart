import 'package:flutter/material.dart';
import 'package:guru_ai/api_service/api_service.dart';
import 'package:guru_ai/services/auth_service.dart';
import 'package:guru_ai/widgets/google_sign_in_button.dart';
import 'package:guru_ai/routes/app_routes.dart';

class GoogleAuthPage extends StatefulWidget {
  const GoogleAuthPage({Key? key}) : super(key: key);

  @override
  _GoogleAuthPageState createState() => _GoogleAuthPageState();
}

class _GoogleAuthPageState extends State<GoogleAuthPage> {
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkCurrentUser();
  }

  Future<void> _checkCurrentUser() async {
    final currentUser = _authService.currentUser;
    if (currentUser != null) {
      // User is already signed in, navigate to dashboard
      Navigator.of(context).pushReplacementNamed(AppRoutes.teacherDashboard);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              Image.asset(
                'assets/images/guruai_icon.png',
                height: 150,
                width: 150,
              ),
              const SizedBox(height: 30),
              const Text(
                'Welcome to Guru-AI',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const Text(
                'Please sign in to continue',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 50),
              if (_isLoading)
                const CircularProgressIndicator()
              else
                GoogleSignInButton(
                  onSignInComplete: (success) {
                    if (success) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        AppRoutes.teacherDashboard,
                        (Route<dynamic> route) => false,
                      );
                    }
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
