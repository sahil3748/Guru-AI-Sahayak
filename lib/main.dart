import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:guru_ai/firebase_options.dart';
import 'package:guru_ai/routes/app_routes.dart';
import 'package:guru_ai/theme/app_theme.dart';
import 'package:guru_ai/widgets/custom_error_widget.dart';
import 'package:sizer/sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 🚨 CRITICAL: Custom error handling - DO NOT REMOVE
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return CustomErrorWidget(errorDetails: details);
  };

  // 🚨 CRITICAL: Device orientation lock - DO NOT REMOVE
  Future.wait([
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]),
  ]).then((value) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, screenType) {
        return MaterialApp(
          title: 'Guru-Ai',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.light,
          // 🚨 CRITICAL: NEVER REMOVE OR MODIFY
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: TextScaler.linear(1.0)),
              child: child!,
            );
          },
          // 🚨 END CRITICAL SECTION
          debugShowCheckedModeBanner: false,
          routes: AppRoutes.routes,
          initialRoute: AppRoutes.splashScreen,
        );
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    fetchUserDetails();
    super.initState();
  }

  fetchUserDetails() {
    Future.delayed(Duration(seconds: 3)).then((ValueKey) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        FirebaseAuth.instance.currentUser != null
            ? AppRoutes.teacherDashboard
            : AppRoutes.auth,
        (Route<dynamic> route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.white, Colors.blue.shade50],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo
            Container(
              width: 120.sp,
              height: 120.sp,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.sp),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.sp),
                child: Image.asset(
                  'assets/images/guruai_icon.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),

            SizedBox(height: 3.h),

            // App Name
            Text(
              'Guru AI Sahayak',
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade800,
                letterSpacing: 1.2,
              ),
            ),

            SizedBox(height: 1.h),

            // Tagline
            Text(
              'Your AI Teaching Assistant',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w400,
              ),
            ),

            SizedBox(height: 5.h),

            // Loading Indicator
            Container(
              width: 60.sp,
              child: LinearProgressIndicator(
                backgroundColor: Colors.blue.shade100,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade600),
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            SizedBox(height: 2.h),

            // Loading Text
            Text(
              'Loading...',
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
