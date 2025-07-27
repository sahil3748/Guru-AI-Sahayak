import 'package:flutter/material.dart';
import 'package:guru_ai/api_service/api_service.dart';
import 'package:guru_ai/services/auth_service.dart';
import 'package:guru_ai/widgets/google_sign_in_button.dart';
import 'package:guru_ai/routes/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GoogleAuthPage extends StatefulWidget {
  const GoogleAuthPage({Key? key}) : super(key: key);

  @override
  _GoogleAuthPageState createState() => _GoogleAuthPageState();
}

class _GoogleAuthPageState extends State<GoogleAuthPage> {
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  bool _isSkipLoading = false;

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
      appBar: AppBar(
        elevation: 0,
        actions: [
          GestureDetector(
            child: GestureDetector(
              onTap: () async {
                setState(() {
                  _isSkipLoading = true;
                });
                try {
                  ApiService apiService = ApiService();
                  Map<String, dynamic> data = {
                    "uid": "guest",
                    "full_name": "Guest User",
                    "email": "guest@email.com",
                    "profile_image": "",
                  };

                  final response = await apiService.post(
                    ApiEndPoint.auth,
                    data: data,
                  );
                  String apiEssencialId = response.data['user_id'] ?? '';
                  if (apiEssencialId.isNotEmpty) {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.setString('api_essential_id', apiEssencialId);
                    Navigator.of(
                      context,
                    ).pushReplacementNamed(AppRoutes.teacherDashboardBackUp);
                  }
                } catch (e) {
                  // Handle error here
                } finally {
                  setState(() {
                    _isSkipLoading = false;
                  });
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: _isSkipLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.blue,
                          ),
                        ),
                      )
                    : const Text("Skip", style: TextStyle(color: Colors.blue)),
              ),
            ),
          ),
        ],
      ),
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
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[const SizedBox(width: 10)],
                ),
              ),

              SizedBox(height: 20),

              const Text(
                'Please sign in to continue',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 50),

              _isLoading
                  ? CircularProgressIndicator()
                  : GoogleSignInButton(
                      onSignInComplete: (success) {
                        if (success) {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            AppRoutes.teacherDashboard,
                            (Route<dynamic> route) => false,
                          );
                        }
                      },
                    ),

              // GestureDetector(
              //   onTap: () async {

              //   },
              //   child: const Text(
              //     'Skip Sign In',
              //     style: TextStyle(
              //       fontSize: 16,
              //       color: Colors.black87,
              //       fontWeight: FontWeight.w600,
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
