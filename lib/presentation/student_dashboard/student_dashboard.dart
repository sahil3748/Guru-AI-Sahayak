import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/class_card_widget.dart';
import './widgets/empty_state_widget.dart';
import './widgets/mascot_greeting_widget.dart';
import './widgets/progress_card_widget.dart';
import './widgets/quick_actions_widget.dart';
import './widgets/recent_activity_widget.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  bool _isLoading = false;
  bool _isOffline = false;

  // Mock data for student dashboard
  final Map<String, dynamic> studentData = {
    "name": "Priya Sharma",
    "grade": 7,
    "learningStreak": 12,
    "completedGoals": 3,
    "totalGoals": 5,
    "achievements": ["Math Star", "Reading Champion", "Science Explorer"],
  };

  final List<Map<String, dynamic>> joinedClasses = [
    {
      "id": 1,
      "className": "Mathematics Grade 7",
      "teacherName": "Mrs. Anita Gupta",
      "subject": "Math",
      "pendingAssignments": 2,
      "recentAnnouncement":
          "Tomorrow we'll learn about algebraic expressions. Please bring your notebooks!",
    },
    {
      "id": 2,
      "className": "Science Explorers",
      "teacherName": "Mr. Rajesh Kumar",
      "subject": "Science",
      "pendingAssignments": 1,
      "recentAnnouncement":
          "Great job on the plant experiment! Results are due by Friday.",
    },
    {
      "id": 3,
      "className": "English Literature",
      "teacherName": "Ms. Kavita Singh",
      "subject": "English",
      "pendingAssignments": 0,
      "recentAnnouncement":
          "We'll start reading 'The Secret Garden' next week. Very exciting!",
    },
  ];

  final List<Map<String, dynamic>> recentActivities = [
    {
      "id": 1,
      "type": "assignment",
      "title": "Fraction Problems Worksheet",
      "description":
          "Completed 15 fraction problems with step-by-step solutions",
      "score": "85%",
      "feedback": "Great work! Focus on simplifying fractions next time.",
      "timestamp": DateTime.now().subtract(const Duration(hours: 2)),
    },
    {
      "id": 2,
      "type": "quiz",
      "title": "Plant Life Cycle Quiz",
      "description": "Interactive quiz about photosynthesis and plant growth",
      "score": "92%",
      "feedback": "Excellent understanding of the concepts!",
      "timestamp": DateTime.now().subtract(const Duration(days: 1)),
    },
    {
      "id": 3,
      "type": "assignment",
      "title": "Creative Writing: My Hero",
      "description": "Wrote a 200-word essay about a personal hero",
      "score": "A+",
      "feedback": "Beautiful storytelling and great vocabulary usage!",
      "timestamp": DateTime.now().subtract(const Duration(days: 2)),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundOffWhite,
      body: SafeArea(
        child: _isLoading
            ? _buildLoadingState()
            : joinedClasses.isEmpty
                ? _buildEmptyState()
                : _buildMainContent(),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 20.w,
            height: 20.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.primaryBlue.withValues(alpha: 0.1),
            ),
            child: Center(
              child: Text(
                '🧙‍♂️',
                style: TextStyle(fontSize: 14.sp),
              ),
            ),
          ),
          SizedBox(height: 3.h),
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryBlue),
          ),
          SizedBox(height: 2.h),
          Text(
            'GuruAI is preparing your dashboard...',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.onSurfaceSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 4.h),
          MascotGreetingWidget(
            studentName: studentData['name'] as String,
            learningStreak: studentData['learningStreak'] as int,
          ),
          EmptyStateWidget(
            onEnterClassCode: _showEnterClassCodeDialog,
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return RefreshIndicator(
      onRefresh: _refreshDashboard,
      color: AppTheme.primaryBlue,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            SizedBox(height: 2.h),
            MascotGreetingWidget(
              studentName: studentData['name'] as String,
              learningStreak: studentData['learningStreak'] as int,
            ),
            ProgressCardWidget(
              completedGoals: studentData['completedGoals'] as int,
              totalGoals: studentData['totalGoals'] as int,
              achievements:
                  (studentData['achievements'] as List).cast<String>(),
            ),
            QuickActionsWidget(
              onChatWithGuruAI: () =>
                  Navigator.pushNamed(context, '/ai-tutor-chat'),
              onPracticeQuiz: _showPracticeQuizOptions,
              onSubmitAssignment: _showSubmitAssignmentOptions,
            ),
            _buildClassesSection(),
            RecentActivityWidget(activities: recentActivities),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }

  Widget _buildClassesSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'My Classes',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.onSurfacePrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton.icon(
                onPressed: _showEnterClassCodeDialog,
                icon: CustomIconWidget(
                  iconName: 'add',
                  color: AppTheme.primaryBlue,
                  size: 16,
                ),
                label: Text(
                  'Join Class',
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    color: AppTheme.primaryBlue,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: joinedClasses.length,
            itemBuilder: (context, index) {
              final classData = joinedClasses[index];
              return ClassCardWidget(
                classData: classData,
                onTap: () => _navigateToClassDetail(classData),
                onViewAssignments: () => _viewClassAssignments(classData),
                onAskQuestion: () => _askQuestionInClass(classData),
                onViewFeed: () => _viewClassFeed(classData),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceWhite,
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onBottomNavTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppTheme.surfaceWhite,
        selectedItemColor: AppTheme.primaryBlue,
        unselectedItemColor: AppTheme.onSurfaceSecondary,
        elevation: 0,
        items: [
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'home',
              color: _currentIndex == 0
                  ? AppTheme.primaryBlue
                  : AppTheme.onSurfaceSecondary,
              size: 24,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'school',
              color: _currentIndex == 1
                  ? AppTheme.primaryBlue
                  : AppTheme.onSurfaceSecondary,
              size: 24,
            ),
            label: 'Classes',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'chat',
              color: _currentIndex == 2
                  ? AppTheme.primaryBlue
                  : AppTheme.onSurfaceSecondary,
              size: 24,
            ),
            label: 'Tutor',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'person',
              color: _currentIndex == 3
                  ? AppTheme.primaryBlue
                  : AppTheme.onSurfaceSecondary,
              size: 24,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Future<void> _refreshDashboard() async {
    setState(() => _isLoading = true);

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isLoading = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Dashboard updated successfully!',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.surfaceWhite,
            ),
          ),
          backgroundColor: AppTheme.successGreen,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  void _onBottomNavTap(int index) {
    setState(() => _currentIndex = index);

    switch (index) {
      case 0:
        // Already on home
        break;
      case 1:
        // Navigate to classes view
        break;
      case 2:
        Navigator.pushNamed(context, '/ai-tutor-chat');
        break;
      case 3:
        // Navigate to profile
        break;
    }
  }

  void _showEnterClassCodeDialog() {
    final TextEditingController codeController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'add_circle',
              color: AppTheme.primaryBlue,
              size: 24,
            ),
            SizedBox(width: 2.w),
            Text(
              'Join Class',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.onSurfacePrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Enter the class code provided by your teacher',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.onSurfaceSecondary,
              ),
            ),
            SizedBox(height: 2.h),
            TextField(
              controller: codeController,
              decoration: InputDecoration(
                labelText: 'Class Code',
                hintText: 'e.g., ABC123',
                prefixIcon: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: CustomIconWidget(
                    iconName: 'vpn_key',
                    color: AppTheme.primaryBlue,
                    size: 20,
                  ),
                ),
              ),
              textCapitalization: TextCapitalization.characters,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                color: AppTheme.onSurfaceSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _joinClass(codeController.text);
            },
            child: Text(
              'Join Class',
              style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                color: AppTheme.surfaceWhite,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _joinClass(String classCode) {
    if (classCode.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please enter a valid class code',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.surfaceWhite,
            ),
          ),
          backgroundColor: AppTheme.alertRed,
        ),
      );
      return;
    }

    // Simulate joining class
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Successfully joined class with code: $classCode',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.surfaceWhite,
          ),
        ),
        backgroundColor: AppTheme.successGreen,
      ),
    );
  }

  void _navigateToClassDetail(Map<String, dynamic> classData) {
    Navigator.pushNamed(context, '/class-detail', arguments: classData);
  }

  void _viewClassAssignments(Map<String, dynamic> classData) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Viewing assignments for ${classData['className']}',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.surfaceWhite,
          ),
        ),
        backgroundColor: AppTheme.primaryBlue,
      ),
    );
  }

  void _askQuestionInClass(Map<String, dynamic> classData) {
    Navigator.pushNamed(context, '/ai-tutor-chat', arguments: {
      'classContext': classData,
      'mode': 'class_question',
    });
  }

  void _viewClassFeed(Map<String, dynamic> classData) {
    Navigator.pushNamed(context, '/class-detail', arguments: {
      ...classData,
      'initialTab': 'feed',
    });
  }

  void _showPracticeQuizOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surfaceWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.outlineLight,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Practice Quiz Options',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.onSurfacePrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 3.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'calculate',
                color: AppTheme.primaryBlue,
                size: 24,
              ),
              title: Text('Math Practice'),
              subtitle: Text('Algebra, Geometry, Fractions'),
              onTap: () {
                Navigator.pop(context);
                _startPracticeQuiz('math');
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'science',
                color: AppTheme.successGreen,
                size: 24,
              ),
              title: Text('Science Practice'),
              subtitle: Text('Biology, Chemistry, Physics'),
              onTap: () {
                Navigator.pop(context);
                _startPracticeQuiz('science');
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'menu_book',
                color: AppTheme.alertRed,
                size: 24,
              ),
              title: Text('English Practice'),
              subtitle: Text('Grammar, Vocabulary, Reading'),
              onTap: () {
                Navigator.pop(context);
                _startPracticeQuiz('english');
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _startPracticeQuiz(String subject) {
    Navigator.pushNamed(context, '/ai-worksheet-generator', arguments: {
      'mode': 'practice_quiz',
      'subject': subject,
      'grade': studentData['grade'],
    });
  }

  void _showSubmitAssignmentOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surfaceWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.outlineLight,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Submit Assignment',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.onSurfacePrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 3.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'camera_alt',
                color: AppTheme.primaryBlue,
                size: 24,
              ),
              title: Text('Take Photo'),
              subtitle: Text('Capture your completed work'),
              onTap: () {
                Navigator.pop(context);
                _submitAssignmentPhoto();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'upload_file',
                color: AppTheme.successGreen,
                size: 24,
              ),
              title: Text('Upload File'),
              subtitle: Text('Select from device storage'),
              onTap: () {
                Navigator.pop(context);
                _submitAssignmentFile();
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _submitAssignmentPhoto() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Camera feature will be available soon!',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.surfaceWhite,
          ),
        ),
        backgroundColor: AppTheme.primaryBlue,
      ),
    );
  }

  void _submitAssignmentFile() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'File upload feature will be available soon!',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.surfaceWhite,
          ),
        ),
        backgroundColor: AppTheme.successGreen,
      ),
    );
  }
}
