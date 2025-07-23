import 'package:flutter/material.dart';
import '../presentation/teacher_dashboard/teacher_dashboard.dart';
import '../presentation/assignment_creation/assignment_creation.dart';
import '../presentation/class_detail/class_detail.dart';
import '../presentation/ai_tutor_chat/ai_tutor_chat.dart';
import '../presentation/student_dashboard/student_dashboard.dart';
import '../presentation/ai_worksheet_generator/ai_worksheet_generator.dart';
import '../presentation/temporary_redirect/temporary_redirect_screen.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String temporaryRedirect = '/temporary-redirect';
  static const String teacherDashboard = '/teacher-dashboard';
  static const String assignmentCreation = '/assignment-creation';
  static const String classDetail = '/class-detail';
  static const String aiTutorChat = '/ai-tutor-chat';
  static const String studentDashboard = '/student-dashboard';
  static const String aiWorksheetGenerator = '/ai-worksheet-generator';

  static Map<String, WidgetBuilder> routes = {
    temporaryRedirect: (context) => const TemporaryRedirectScreen(),
    initial: (context) => const StudentDashboard(),
    teacherDashboard: (context) => const TeacherDashboard(),
    assignmentCreation: (context) => const AssignmentCreation(),
    classDetail: (context) => const ClassDetail(),
    aiTutorChat: (context) => const AiTutorChat(),
    studentDashboard: (context) => const StudentDashboard(),
    aiWorksheetGenerator: (context) => const AiWorksheetGenerator(),
    // TODO: Add your other routes here
  };
}
