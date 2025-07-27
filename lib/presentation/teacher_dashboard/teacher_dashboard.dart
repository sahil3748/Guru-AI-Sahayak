import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:guru_ai/presentation/hyperlocal_content_generator/hyperlocal_content_generator.dart';
import 'package:guru_ai/presentation/textbook_scanner/textbook_scanner.dart';
import 'package:guru_ai/presentation/visual_aids_screen/visual_aids_screen.dart';
import 'package:guru_ai/services/auth_service.dart';
import 'package:guru_ai/services/google_classroom_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  final GoogleClassroomService _classroomService = GoogleClassroomService();

  // Loading and data states
  bool _isLoadingClasses = true;
  bool _hasClassroomPermissions = false;
  List<Map<String, dynamic>> _classesData = [];
  String? _errorMessage;

  // Preferences keys
  static const String _classroomPermissionGrantedKey =
      'classroom_permission_granted';
  static const String _googleAuthCompletedKey = 'google_auth_completed';

  // Mock data for teacher and classes`
  final Map<String, dynamic> teacherData = {
    "name": "Teacher",
    "school": "Delhi Public School, Sector 45",
    "avatar":
        "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
    "todayClasses": 3,
    "pendingTasks": 5,
  };

  @override
  void initState() {
    super.initState();
    _initializeClassroomData();
  }

  /// Initialize classroom data on widget load
  Future<void> _initializeClassroomData() async {
    setState(() {
      _isLoadingClasses = true;
      _errorMessage = null;
    });

    try {
      // Check if we have stored preferences about authentication state
      final prefs = await SharedPreferences.getInstance();
      final bool hasCompletedAuth =
          prefs.getBool(_googleAuthCompletedKey) ?? false;

      // Check if user is signed in with Google
      bool isSignedIn = _authService.isSignedInWithGoogle();

      // If not signed in but previously completed auth, try silent sign-in
      if (!isSignedIn && hasCompletedAuth) {
        final userCredential = await _authService.silentSignIn();
        isSignedIn = userCredential != null;
      }

      // If still not signed in and haven't completed auth before, show dialog
      if (!isSignedIn && !hasCompletedAuth) {
        bool didAuthenticate = await _showAuthenticationDialog();
        if (!didAuthenticate) {
          setState(() {
            _isLoadingClasses = false;
            _errorMessage = "Google authentication required";
          });
          return;
        }
        // Store that user has completed authentication
        await prefs.setBool(_googleAuthCompletedKey, true);
      }

      // Check for stored classroom permissions
      final bool storedHasPermissions =
          prefs.getBool(_classroomPermissionGrantedKey) ?? false;
      _hasClassroomPermissions =
          _classroomService.hasClassroomPermissions || storedHasPermissions;

      if (_hasClassroomPermissions) {
        await _fetchClassroomData();
      } else {
        setState(() {
          _isLoadingClasses = false;
          _errorMessage = "Classroom permissions required";
        });
      }
    } catch (e) {
      setState(() {
        _isLoadingClasses = false;
        _errorMessage = "Error initializing classroom data: $e";
      });
    }
  }

  /// Show authentication dialog to the user
  Future<bool> _showAuthenticationDialog() async {
    bool shouldSignIn =
        await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: Text('Google Authentication Required'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'You need to sign in with Google before accessing Classroom data.',
                ),
                SizedBox(height: 10),
                Text('Would you like to sign in now?'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text('Sign In'),
              ),
            ],
          ),
        ) ??
        false;

    if (shouldSignIn) {
      // Perform the actual sign-in after dialog closes
      try {
        final userCredential = await _authService.signInWithGoogle();
        return userCredential != null;
      } catch (e) {
        print('Error during Google sign-in: $e');
        return false;
      }
    }

    return false;
  }

  /// Fetch classroom data from Google Classroom
  Future<void> _fetchClassroomData() async {
    try {
      // First check if user is authenticated
      if (!_authService.isSignedInWithGoogle()) {
        bool didAuthenticate = await _showAuthenticationDialog();
        if (!didAuthenticate) {
          setState(() {
            _isLoadingClasses = false;
            _errorMessage = "Google authentication required";
          });
          return;
        }
      }

      // Use the new googleapis-based approach for better reliability
      final courses = await _classroomService.getAllCourses();

      // If we get here, we have courses data
      setState(() {
        // Convert to the expected format for the existing UI
        _classesData = courses
            .map(
              (course) => {
                'id': course.id,
                'name': course.name,
                'description': course.description,
                'room': course.room,
                'enrollmentCode': course.enrollmentCode,
                'courseState': course.courseState,
                'alternateLink': course.alternateLink,
                'ownerId': course.ownerId,
                'teacherGroupEmail': course.teacherGroupEmail,
                'courseGroupEmail': course.courseGroupEmail,
                'calendarId': course.calendarId ?? '',
                'guardiansEnabled': course.guardiansEnabled ?? false,
              },
            )
            .toList();
        _isLoadingClasses = false;
        _errorMessage = null;
        _hasClassroomPermissions = true; // Update permission state
      });

      // Store successful authentication and permissions
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_googleAuthCompletedKey, true);
      await prefs.setBool(_classroomPermissionGrantedKey, true);

      print('✅ Successfully loaded ${_classesData.length} courses for UI');
    } catch (e) {
      // Handle specific authentication errors
      if (e.toString().contains('No authenticated Google account found')) {
        setState(() {
          _isLoadingClasses = false;
          _hasClassroomPermissions = false;
          _errorMessage = "Authentication required for Google Classroom";
        });
      } else {
        setState(() {
          _isLoadingClasses = false;
          _errorMessage = "Error fetching classroom data: $e";
        });
      }
      print('❌ Error in _fetchClassroomData: $e');
    }
  }

  /// Request classroom permissions
  Future<void> _requestClassroomPermissions() async {
    setState(() {
      _isLoadingClasses = true;
    });

    try {
      final hasPermissions = await _classroomService
          .requestClassroomPermissions();

      if (hasPermissions) {
        _hasClassroomPermissions = true;

        // Store that permissions were granted
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool(_classroomPermissionGrantedKey, true);

        await _fetchClassroomData();
      } else {
        setState(() {
          _isLoadingClasses = false;
          _errorMessage = "Failed to get classroom permissions";
        });
      }
    } catch (e) {
      setState(() {
        _isLoadingClasses = false;
        _errorMessage = "Error requesting permissions: $e";
      });
    }
  }

  // Getter for backward compatibility with existing code
  List<Map<String, dynamic>> get classesData => _classesData;

  @override
  Widget build(BuildContext context) {
    final user = _authService.currentUser;
    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      backgroundColor: AppTheme.backgroundOffWhite,
      appBar: GreetingHeaderWidget(
        teacherName: user.displayName!,
        profileUrl: user.photoURL ?? '',
        onLanguageSwitch: _handleLanguageSwitch,
      ),
      body: _buildBody(),
      floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
      case 'hyperlocal':
        _navigateToHyperLocalGenerator();
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

            // Classes List, Loading, or Permission Request
            _buildClassesSection(),

            SizedBox(height: 10.h), // Space for FAB
          ],
        ),
      ),
    );
  }

  Widget _buildClassesSection() {
    if (_isLoadingClasses) {
      return Container(
        padding: EdgeInsets.all(4.w),
        child: Center(
          child: Column(
            children: [
              CircularProgressIndicator(color: AppTheme.primaryBlue),
              SizedBox(height: 2.h),
              Text(
                'Loading your classes...',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.onSurfaceSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (!_hasClassroomPermissions) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w),
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.surfaceWhite,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.warningYellow),
        ),
        child: Column(
          children: [
            CustomIconWidget(
              iconName: 'lock',
              color: AppTheme.warningYellow,
              size: 12.w,
            ),
            SizedBox(height: 2.h),
            Text(
              'Classroom Access Required',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Grant access to Google Classroom to view and manage your classes.',
              textAlign: TextAlign.center,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.onSurfaceSecondary,
              ),
            ),
            SizedBox(height: 3.h),
            ElevatedButton.icon(
              onPressed: _requestClassroomPermissions,
              icon: CustomIconWidget(
                iconName: 'school',
                color: AppTheme.surfaceWhite,
                size: 5.w,
              ),
              label: Text(
                'Grant Access',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.surfaceWhite,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryBlue,
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.5.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w),
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.surfaceWhite,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.red),
        ),
        child: Column(
          children: [
            CustomIconWidget(iconName: 'error', color: Colors.red, size: 12.w),
            SizedBox(height: 2.h),
            Text(
              'Error Loading Classes',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.onSurfaceSecondary,
              ),
            ),
            SizedBox(height: 3.h),
            ElevatedButton.icon(
              onPressed: _initializeClassroomData,
              icon: CustomIconWidget(
                iconName: 'refresh',
                color: AppTheme.surfaceWhite,
                size: 5.w,
              ),
              label: Text(
                'Retry',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.surfaceWhite,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryBlue,
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.5.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (classesData.isEmpty) {
      return EmptyStateWidget(
        onCreateClass: () => _showCreateClassBottomSheet(),
      );
    }

    return Column(
      children: (classesData)
          .map(
            (classData) => ClassCardWidget(
              classData: classData,
              onTap: () => _navigateToClassDetail(classData),
              onPostAnnouncement: () => _postAnnouncement(classData),
              onViewStudents: () => _viewStudents(classData),
              onClassSettings: () => _openClassSettings(classData),
            ),
          )
          .toList(),
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
    await _fetchClassroomData();
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

  void _navigateToHyperLocalGenerator() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const HyperLocalContentGenerator(),
      ),
    );
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
        "title": "Hyper-Local Content",
        "subtitle": "Create in your language",
        "icon": "translate",
        "color": Color(0xFF009688),
        "usageCount": 17,
        "timeSaved": "2.0 hrs",
        "action": "hyperlocal",
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
