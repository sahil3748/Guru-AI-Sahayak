import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';

class TemporaryRedirectScreen extends StatefulWidget {
  const TemporaryRedirectScreen({Key? key}) : super(key: key);

  @override
  State<TemporaryRedirectScreen> createState() => _TemporaryRedirectScreenState();
}

class _TemporaryRedirectScreenState extends State<TemporaryRedirectScreen> {
  void _redirectToTeacher() {
    Navigator.of(context).pushReplacementNamed(AppRoutes.teacherDashboard);
  }

  void _redirectToStudent() {
    Navigator.of(context).pushReplacementNamed(AppRoutes.studentDashboard);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Dashboard'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _redirectToTeacher,
              child: const Text('Go to Teacher Dashboard'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _redirectToStudent,
              child: const Text('Go to Student Dashboard'),
            ),
          ],
        ),
      ),
    );
  }
}
