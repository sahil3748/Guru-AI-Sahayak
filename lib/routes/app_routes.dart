import 'package:flutter/material.dart';
import 'package:guru_ai/main.dart';
import 'package:guru_ai/presentation/settings/settings_screen.dart';
import 'package:guru_ai/presentation/teacher_dashboard/teacher_dashboard.dart';
import 'package:guru_ai/presentation/teacher_dashboard/teacher_dashboard_backup.dart';
import '../presentation/auth/google_auth_page.dart';
import '../presentation/assignment_creation/assignment_creation.dart';
import '../presentation/class_detail/class_detail.dart';
import '../presentation/ai_tutor_chat/ai_tutor_chat.dart';
import '../presentation/ai_worksheet_generator/ai_worksheet_generator.dart';
import '../presentation/textbook_scanner/textbook_scanner.dart';

class AppRoutes {
  static const String initial = '/';
  static const String splashScreen = '/splashScreen';
  static const String auth = '/auth';
  static const String settings = '/settings';
  static const String teacherDashboard = '/teacher-dashboard';
  static const String teacherDashboardBackUp = '/student-dashboard-back-up';
  static const String assignmentCreation = '/assignment-creation';
  static const String classDetail = '/class-detail';
  static const String aiTutorChat = '/ai-tutor-chat';
  static const String studentDashboard = '/student-dashboard';
  static const String aiWorksheetGenerator = '/ai-worksheet-generator';
  static const String textbookScanner = '/textbook-scanner';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    splashScreen: (context) => SplashScreen(),
    settings: (context) => const SettingsScreen(),
    auth: (context) => const GoogleAuthPage(),
    teacherDashboard: (context) => const TeacherDashboard(),
    teacherDashboardBackUp: (context) => TeacherDashboardBackUp(),
    assignmentCreation: (context) => const AssignmentCreation(),
    classDetail: (context) => const ClassDetail(),
    aiTutorChat: (context) => const AiTutorChat(),
    // studentDashboard: (context) => const StudentDashboard(),
    aiWorksheetGenerator: (context) => const AiWorksheetGenerator(),
    textbookScanner: (context) => const TextbookScannerScreen(),
    // TODO: Add your other routes here
  };
}
