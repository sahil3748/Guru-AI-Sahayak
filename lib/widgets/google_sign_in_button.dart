import 'dart:async';
import 'package:flutter/material.dart';
import 'package:guru_ai/api_service/api_service.dart';
import 'package:guru_ai/services/auth_service.dart';

class GoogleSignInButton extends StatefulWidget {
  final Function(bool)? onSignInComplete;

  const GoogleSignInButton({Key? key, this.onSignInComplete}) : super(key: key);

  @override
  _GoogleSignInButtonState createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  final AuthService _authService = AuthService();
  bool _isSigningIn = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: _isSigningIn
          ? const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            )
          : OutlinedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
              ),
              onPressed: _isSigningIn
                  ? null
                  : () async {
                      if (_isSigningIn) return;

                      setState(() {
                        _isSigningIn = true;
                      });

                      try {
                        final userCredential = await _authService
                            .signInWithGoogle()
                            .timeout(
                              const Duration(minutes: 5),
                              onTimeout: () => throw TimeoutException(
                                'Sign in process timed out. Please try again.',
                              ),
                            );

                        if (!mounted) {
                          // Clean up if widget is unmounted
                          await _authService.signOut().catchError((_) {});
                          return;
                        }

                        if (userCredential != null) {
                          try {
                            ApiService apiService = ApiService();
                            Map<String, dynamic> data = {
                              "uid": userCredential.user!.uid,
                              "full_name": userCredential.user!.displayName,
                              "email": userCredential.user!.email,
                              "profile_image": userCredential.user!.photoURL,
                            };

                            apiService.post(ApiEndPoint.auth, data: data);
                            widget.onSignInComplete?.call(true);
                          } catch (e) {
                            widget.onSignInComplete?.call(false);
                          }
                        } else if (mounted) {
                          widget.onSignInComplete?.call(false);
                        }
                      } catch (e) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error signing in with Google: $e'),
                            ),
                          );
                          widget.onSignInComplete?.call(false);
                        }
                      }

                      if (mounted) {
                        setState(() {
                          _isSigningIn = false;
                        });
                      }
                    },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(width: 10),
                    const Text(
                      'Sign in with Google',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
