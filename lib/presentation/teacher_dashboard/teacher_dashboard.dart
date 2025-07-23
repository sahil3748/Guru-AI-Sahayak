import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/class_card_widget.dart';
import './widgets/empty_state_widget.dart';
import './widgets/greeting_card_widget.dart';
import './widgets/network_status_widget.dart';
import './widgets/quick_access_toolbar_widget.dart';

class TeacherDashboard extends StatefulWidget {
  const TeacherDashboard({super.key});

  @override
  State<TeacherDashboard> createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  bool _isOnline = true;
  bool _isSyncing = false;
  bool _isRefreshing = false;

  // Mock data for teacher and classes
  final Map<String, dynamic> teacherData = {
    "name": "Priya Sharma",
    "school": "Delhi Public School, Sector 45",
    "avatar":
        "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
    "todayClasses": 3,
    "pendingTasks": 5,
  };

  final List<Map<String, dynamic>> classesData = [
    {
      "id": 1,
      "name": "Mathematics Grade 8A",
      "subject": "Mathematics",
      "grade": "8",
      "studentCount": 32,
      "recentActivity": "Assignment submitted by 28 students",
      "unreadAnnouncements": 2,
      "lastActive": "2 hours ago",
    },
    {
      "id": 2,
      "name": "Science Grade 7B",
      "subject": "Science",
      "grade": "7",
      "studentCount": 28,
      "recentActivity": "New worksheet generated for Chapter 5",
      "unreadAnnouncements": 0,
      "lastActive": "4 hours ago",
    },
    {
      "id": 3,
      "name": "English Grade 6C",
      "subject": "English",
      "grade": "6",
      "studentCount": 25,
      "recentActivity": "Reading assessment completed by 20 students",
      "unreadAnnouncements": 1,
      "lastActive": "1 day ago",
    },
    {
      "id": 4,
      "name": "Hindi Grade 5A",
      "subject": "Hindi",
      "grade": "5",
      "studentCount": 30,
      "recentActivity": "Lesson plan created for next week",
      "unreadAnnouncements": 0,
      "lastActive": "2 days ago",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundOffWhite,
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.surfaceWhite,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          CircleAvatar(
            radius: 5.w,
            backgroundColor: AppTheme.primaryBlue.withValues(alpha: 0.1),
            child: CustomImageWidget(
              imageUrl: teacherData["avatar"] as String,
              width: 10.w,
              height: 10.w,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  teacherData["name"] as String,
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.onSurfacePrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  teacherData["school"] as String,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.onSurfaceSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        NetworkStatusWidget(
          isOnline: _isOnline,
          isSyncing: _isSyncing,
        ),
        SizedBox(width: 2.w),
        IconButton(
          onPressed: () => _showNotifications(),
          icon: Stack(
            children: [
              CustomIconWidget(
                iconName: 'notifications_outlined',
                color: AppTheme.onSurfacePrimary,
                size: 6.w,
              ),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 2.w,
                  height: 2.w,
                  decoration: BoxDecoration(
                    color: AppTheme.alertRed,
                    borderRadius: BorderRadius.circular(1.w),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 2.w),
      ],
    );
  }

  Widget _buildBody() {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      color: AppTheme.primaryBlue,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting Card
            GreetingCardWidget(
              teacherName: teacherData["name"] as String,
              schoolName: teacherData["school"] as String,
              todayClassesCount: teacherData["todayClasses"] as int,
              pendingTasksCount: teacherData["pendingTasks"] as int,
            ),

            // Quick Access Toolbar
            QuickAccessToolbarWidget(
              onAITools: () => _navigateToAITools(),
              onReadingAssessment: () => _navigateToReadingAssessment(),
              onLessonPlanner: () => _navigateToLessonPlanner(),
            ),

            SizedBox(height: 2.h),

            // Classes Section Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Row(
                children: [
                  Text(
                    'My Classes',
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppTheme.onSurfacePrimary,
                    ),
                  ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: () => _showAllClasses(),
                    icon: CustomIconWidget(
                      iconName: 'arrow_forward',
                      color: AppTheme.primaryBlue,
                      size: 4.w,
                    ),
                    label: Text(
                      'View All',
                      style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                        color: AppTheme.primaryBlue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 1.h),

            // Classes List or Empty State
            classesData.isEmpty
                ? EmptyStateWidget(
                    onCreateClass: () => _showCreateClassBottomSheet(),
                  )
                : Column(
                    children: (classesData)
                        .map((classData) => ClassCardWidget(
                              classData: classData,
                              onTap: () => _navigateToClassDetail(classData),
                              onPostAnnouncement: () =>
                                  _postAnnouncement(classData),
                              onViewStudents: () => _viewStudents(classData),
                              onClassSettings: () =>
                                  _openClassSettings(classData),
                            ))
                        .toList(),
                  ),

            SizedBox(height: 10.h), // Space for FAB
          ],
        ),
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
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppTheme.surfaceWhite,
        selectedItemColor: AppTheme.primaryBlue,
        unselectedItemColor: AppTheme.onSurfaceSecondary,
        elevation: 0,
        items: [
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'dashboard',
              color: _currentIndex == 0
                  ? AppTheme.primaryBlue
                  : AppTheme.onSurfaceSecondary,
              size: 6.w,
            ),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'school',
              color: _currentIndex == 1
                  ? AppTheme.primaryBlue
                  : AppTheme.onSurfaceSecondary,
              size: 6.w,
            ),
            label: 'Classes',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'auto_awesome',
              color: _currentIndex == 2
                  ? AppTheme.primaryBlue
                  : AppTheme.onSurfaceSecondary,
              size: 6.w,
            ),
            label: 'Tools',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'person',
              color: _currentIndex == 3
                  ? AppTheme.primaryBlue
                  : AppTheme.onSurfaceSecondary,
              size: 6.w,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () => _showCreateActionBottomSheet(),
      backgroundColor: AppTheme.primaryBlue,
      foregroundColor: AppTheme.surfaceWhite,
      elevation: 4,
      child: CustomIconWidget(
        iconName: 'add',
        color: AppTheme.surfaceWhite,
        size: 7.w,
      ),
    );
  }

  Future<void> _handleRefresh() async {
    setState(() => _isSyncing = true);

    // Simulate network sync
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isSyncing = false;
      _isOnline = true;
    });
  }

  void _showCreateActionBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppTheme.surfaceWhite,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10.w,
              height: 0.5.h,
              margin: EdgeInsets.only(top: 2.h),
              decoration: BoxDecoration(
                color: AppTheme.outlineLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                children: [
                  Text(
                    'Create New',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  _buildCreateActionTile(
                    icon: 'school',
                    title: 'Create Class',
                    subtitle: 'Start a new class with students',
                    color: AppTheme.primaryBlue,
                    onTap: () {
                      Navigator.pop(context);
                      _showCreateClassBottomSheet();
                    },
                  ),
                  _buildCreateActionTile(
                    icon: 'description',
                    title: 'Generate Worksheet',
                    subtitle: 'AI-powered worksheet creation',
                    color: AppTheme.successGreen,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/ai-worksheet-generator');
                    },
                  ),
                  _buildCreateActionTile(
                    icon: 'camera_alt',
                    title: 'Scan Textbook',
                    subtitle: 'Extract content from textbooks',
                    color: AppTheme.warningYellow,
                    onTap: () {
                      Navigator.pop(context);
                      _scanTextbook();
                    },
                  ),
                  SizedBox(height: 2.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreateActionTile({
    required String icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        width: 12.w,
        height: 12.w,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: CustomIconWidget(
          iconName: icon,
          color: color,
          size: 6.w,
        ),
      ),
      title: Text(
        title,
        style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTheme.lightTheme.textTheme.bodySmall,
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  void _showCreateClassBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 70.h,
        decoration: BoxDecoration(
          color: AppTheme.surfaceWhite,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            children: [
              Container(
                width: 10.w,
                height: 0.5.h,
                margin: EdgeInsets.only(bottom: 2.h),
                decoration: BoxDecoration(
                  color: AppTheme.outlineLight,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Text(
                'Create New Class',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 3.h),
              // Class creation form would go here
              Expanded(
                child: Center(
                  child: Text(
                    'Class creation form coming soon...',
                    style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                      color: AppTheme.onSurfaceSecondary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToClassDetail(Map<String, dynamic> classData) {
    Navigator.pushNamed(context, '/class-detail');
  }

  void _navigateToAITools() {
    Navigator.pushNamed(context, '/ai-worksheet-generator');
  }

  void _navigateToReadingAssessment() {
    // Navigate to reading assessment screen
  }

  void _navigateToLessonPlanner() {
    // Navigate to lesson planner screen
  }

  void _postAnnouncement(Map<String, dynamic> classData) {
    Navigator.pushNamed(context, '/assignment-creation');
  }

  void _viewStudents(Map<String, dynamic> classData) {
    // Navigate to students list
  }

  void _openClassSettings(Map<String, dynamic> classData) {
    // Navigate to class settings
  }

  void _showNotifications() {
    // Show notifications panel
  }

  void _showAllClasses() {
    // Navigate to all classes view
  }

  void _scanTextbook() {
    // Navigate to textbook scanner
  }
}
