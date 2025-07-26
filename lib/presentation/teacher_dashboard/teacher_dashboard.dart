import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:guru_ai/presentation/textbook_scanner/textbook_scanner.dart';
import 'package:guru_ai/presentation/visual_aids_screen/visual_aids_screen.dart';
import 'package:guru_ai/services/auth_service.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/class_card_widget.dart';
import './widgets/empty_state_widget.dart';

class TeacherDashboard extends StatefulWidget {
  const TeacherDashboard({super.key});

  @override
  State<TeacherDashboard> createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard>
    with TickerProviderStateMixin {
  final AuthService _authService = AuthService();

  // Mock data for teacher and classes`
  final Map<String, dynamic> teacherData = {
    "name": "Teacher",
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
    final user = _authService.currentUser;
    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      backgroundColor: AppTheme.backgroundOffWhite,
      appBar: GreetingHeaderWidget(
        teacherName: user!.displayName!,
        profileUrl: user?.photoURL ?? '',
        onLanguageSwitch: _handleLanguageSwitch,
      ),
      body: _buildBody(),
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

  void _handleLanguageSwitch() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Language Selection'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('English'),
              leading: Radio(
                value: 'en',
                groupValue: 'en',
                onChanged: (value) {},
              ),
            ),
            ListTile(
              title: Text('Spanish'),
              leading: Radio(
                value: 'es',
                groupValue: 'en',
                onChanged: (value) {},
              ),
            ),
            ListTile(
              title: Text('French'),
              leading: Radio(
                value: 'fr',
                groupValue: 'en',
                onChanged: (value) {},
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Apply'),
          ),
        ],
      ),
    );
  }

  void _handleQuickAction(String action) {
    switch (action) {
      case 'scan':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const TextbookScannerScreen(),
          ),
        );
        break;
      case 'worksheet':
        _navigateToAITools();
        break;
      case 'visual':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const VisualAidsCreatorScreen(),
          ),
        );
        break;

      case 'chat':
        Navigator.pushNamed(context, '/ai-chat-assistant-screen');
        break;
    }
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
            SizedBox(height: 2.h),
            QuickActionsWidget(onActionTap: _handleQuickAction),
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
                        .map(
                          (classData) => ClassCardWidget(
                            classData: classData,
                            onTap: () => _navigateToClassDetail(classData),
                            onPostAnnouncement: () =>
                                _postAnnouncement(classData),
                            onViewStudents: () => _viewStudents(classData),
                            onClassSettings: () =>
                                _openClassSettings(classData),
                          ),
                        )
                        .toList(),
                  ),

            SizedBox(height: 10.h), // Space for FAB
          ],
        ),
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

  Future<void> _handleRefresh() async {}

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
        child: CustomIconWidget(iconName: icon, color: color, size: 6.w),
      ),
      title: Text(
        title,
        style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(subtitle, style: AppTheme.lightTheme.textTheme.bodySmall),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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

class GreetingHeaderWidget extends StatelessWidget
    implements PreferredSizeWidget {
  final String teacherName;
  final String profileUrl;
  final VoidCallback onLanguageSwitch;

  const GreetingHeaderWidget({
    Key? key,
    required this.teacherName,
    required this.profileUrl,
    required this.onLanguageSwitch,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 45);

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final timeOfDay = now.hour < 12
        ? 'Good Morning'
        : now.hour < 17
        ? 'Good Afternoon'
        : 'Good Evening';
    final formattedDate = '${_getMonthName(now.month)} ${now.day}, ${now.year}';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(left: 4.w, right: 4.w, top: 4.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            offset: Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$timeOfDay,',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  teacherName,
                  style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 0.5.h),
                Text(
                  formattedDate,
                  style: AppTheme.lightTheme.textTheme.bodySmall,
                ),
              ],
            ),
          ),

          // Text(profileUrl),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.settings);
            },
            child: ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(100),
              child: SizedBox(
                width: 50,
                height: 50,
                child: CachedNetworkImage(imageUrl: profileUrl),
              ),
            ),
          ),
          // CircleAvatar(
          //   radius: 40,

          //   backgroundImage: NetworkImage(profileUrl),
          //   onBackgroundImageError: (_, __) {
          //     // Handle error when image fails to load
          //   },
          // ),

          // GestureDetector(
          //   onTap: onLanguageSwitch,
          //   child: Container(
          //     padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
          //     decoration: BoxDecoration(
          //       color: AppTheme.lightTheme.colorScheme.primaryContainer
          //           .withValues(alpha: 0.1),
          //       borderRadius: BorderRadius.circular(20),
          //       border: Border.all(
          //         color: AppTheme.lightTheme.colorScheme.outline.withValues(
          //           alpha: 0.3,
          //         ),
          //       ),
          //     ),
          //     child: Row(
          //       mainAxisSize: MainAxisSize.min,
          //       children: [
          //         CustomIconWidget(
          //           iconName: 'language',
          //           color: AppTheme.lightTheme.colorScheme.primary,
          //           size: 18,
          //         ),
          //         SizedBox(width: 1.w),
          //         Text(
          //           'EN',
          //           style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
          //             color: AppTheme.lightTheme.colorScheme.primary,
          //             fontWeight: FontWeight.w500,
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }
}

class QuickActionsWidget extends StatelessWidget {
  final Function(String) onActionTap;

  const QuickActionsWidget({Key? key, required this.onActionTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> quickActions = [
      {
        "title": "Scan Textbook",
        "subtitle": "Camera capture",
        "icon": "camera_alt",
        "color": Color(0xFF4CAF50),
        "usageCount": 12,
        "timeSaved": "2.5 hrs",
        "action": "scan",
      },
      {
        "title": "Create Worksheet",
        "subtitle": "AI generation",
        "icon": "description",
        "color": Color(0xFF1976D2),
        "usageCount": 8,
        "timeSaved": "3.2 hrs",
        "action": "worksheet",
      },
      {
        "title": "Visual Aids",
        "subtitle": "Charts & diagrams",
        "icon": "image",
        "color": Color(0xFFF57C00),
        "usageCount": 15,
        "timeSaved": "4.1 hrs",
        "action": "visual",
      },
      {
        "title": "Ask AI",
        "subtitle": "Instant help",
        "icon": "chat",
        "color": Color(0xFF9C27B0),
        "usageCount": 23,
        "timeSaved": "1.8 hrs",
        "action": "chat",
      },
    ];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 3.w,
              mainAxisSpacing: 2.h,
              childAspectRatio: 1.1,
            ),
            itemCount: quickActions.length,
            itemBuilder: (context, index) {
              final action = quickActions[index];
              return GestureDetector(
                onTap: () => onActionTap(action["action"] as String),
                child: Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.lightTheme.colorScheme.outline.withValues(
                        alpha: 0.2,
                      ),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.lightTheme.colorScheme.shadow,
                        offset: Offset(0, 2),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(2.w),
                            decoration: BoxDecoration(
                              color: (action["color"] as Color).withValues(
                                alpha: 0.1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: CustomIconWidget(
                              iconName: action["icon"] as String,
                              color: action["color"] as Color,
                              size: 24,
                            ),
                          ),
                          Spacer(),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 2.w,
                              vertical: 0.5.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme
                                  .lightTheme
                                  .colorScheme
                                  .primaryContainer
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${action["usageCount"]}',
                              style: AppTheme.lightTheme.textTheme.labelSmall
                                  ?.copyWith(
                                    color:
                                        AppTheme.lightTheme.colorScheme.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        action["title"] as String,
                        style: AppTheme.lightTheme.textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        action["subtitle"] as String,
                        style: AppTheme.lightTheme.textTheme.bodySmall
                            ?.copyWith(
                              color: AppTheme
                                  .lightTheme
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Spacer(),
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'schedule',
                            color: AppTheme
                                .lightTheme
                                .colorScheme
                                .onSurfaceVariant,
                            size: 14,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            'Saved ${action["timeSaved"]}',
                            style: AppTheme.lightTheme.textTheme.labelSmall
                                ?.copyWith(
                                  color: AppTheme
                                      .lightTheme
                                      .colorScheme
                                      .onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
