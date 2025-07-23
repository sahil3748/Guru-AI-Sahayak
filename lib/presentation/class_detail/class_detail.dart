import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/announcement_card_widget.dart';
import './widgets/assignment_card_widget.dart';
import './widgets/class_header_widget.dart';
import './widgets/empty_state_widget.dart';
import './widgets/people_card_widget.dart';
import './widgets/tab_selector_widget.dart';

class ClassDetail extends StatefulWidget {
  const ClassDetail({Key? key}) : super(key: key);

  @override
  State<ClassDetail> createState() => _ClassDetailState();
}

class _ClassDetailState extends State<ClassDetail> {
  int _selectedTabIndex = 0;
  bool _isRefreshing = false;
  final List<String> _tabs = ['Announcements', 'Assignments', 'People'];

  // Mock data for class details
  final Map<String, dynamic> _classData = {
    "id": "class_001",
    "name": "Mathematics Grade 8",
    "code": "MATH8A",
    "subject": "Mathematics",
    "memberCount": 28,
    "teacherId": "teacher_001",
    "createdAt": DateTime.now().subtract(Duration(days: 30)),
  };

  // Mock current user data
  final Map<String, dynamic> _currentUser = {
    "id": "user_001",
    "name": "Priya Sharma",
    "role": "teacher", // Change to "student" to test student view
    "email": "priya.sharma@school.edu.in",
  };

  // Mock announcements data
  final List<Map<String, dynamic>> _announcements = [
    {
      "id": "ann_001",
      "title": "Welcome to Mathematics Grade 8!",
      "content":
          "Hello students! Welcome to our new academic year. We'll be covering algebra, geometry, and statistics this semester. Please make sure you have your textbooks ready.",
      "author": "Mrs. Priya Sharma",
      "timestamp": DateTime.now().subtract(Duration(hours: 2)),
      "type": "general",
      "hasAttachment": false,
    },
    {
      "id": "ann_002",
      "title": "Assignment Reminder",
      "content":
          "Don't forget to submit your algebra worksheet by tomorrow. The problems are from Chapter 3, exercises 1-15.",
      "author": "Mrs. Priya Sharma",
      "timestamp": DateTime.now().subtract(Duration(hours: 6)),
      "type": "assignment_reminder",
      "hasAttachment": true,
      "dueDate": "Tomorrow, 5:00 PM",
    },
    {
      "id": "ann_003",
      "title": "Parent-Teacher Meeting",
      "content":
          "We will be conducting parent-teacher meetings next week. Please check your email for the scheduled time slots.",
      "author": "Mrs. Priya Sharma",
      "timestamp": DateTime.now().subtract(Duration(days: 1)),
      "type": "general",
      "hasAttachment": false,
    },
  ];

  // Mock assignments data
  final List<Map<String, dynamic>> _assignments = [
    {
      "id": "assign_001",
      "title": "Algebra Worksheet - Chapter 3",
      "description":
          "Complete exercises 1-15 from Chapter 3. Show all working steps clearly. Focus on solving linear equations and inequalities.",
      "dueDate": DateTime.now().add(Duration(days: 1)),
      "status": "pending",
      "hasAttachment": true,
      "grade": null,
      "maxMarks": 50,
    },
    {
      "id": "assign_002",
      "title": "Geometry Project - Triangles",
      "description":
          "Create a presentation on different types of triangles and their properties. Include real-world examples and applications.",
      "dueDate": DateTime.now().add(Duration(days: 7)),
      "status": "pending",
      "hasAttachment": false,
      "grade": null,
      "maxMarks": 100,
    },
    {
      "id": "assign_003",
      "title": "Statistics Quiz - Data Analysis",
      "description":
          "Online quiz covering mean, median, mode, and range calculations. 20 questions, 30 minutes time limit.",
      "dueDate": DateTime.now().subtract(Duration(days: 2)),
      "status": "submitted",
      "hasAttachment": false,
      "grade": "42/50",
      "maxMarks": 50,
    },
  ];

  // Mock people data
  final List<Map<String, dynamic>> _people = [
    {
      "id": "teacher_001",
      "name": "Mrs. Priya Sharma",
      "role": "Teacher",
      "email": "priya.sharma@school.edu.in",
      "profileImage":
          "https://images.pexels.com/photos/3769021/pexels-photo-3769021.jpeg?auto=compress&cs=tinysrgb&w=400",
      "isOnline": true,
    },
    {
      "id": "student_001",
      "name": "Arjun Patel",
      "role": "Student",
      "email": "arjun.patel@student.edu.in",
      "profileImage":
          "https://images.pexels.com/photos/1239291/pexels-photo-1239291.jpeg?auto=compress&cs=tinysrgb&w=400",
      "isOnline": true,
    },
    {
      "id": "student_002",
      "name": "Sneha Reddy",
      "role": "Student",
      "email": "sneha.reddy@student.edu.in",
      "profileImage":
          "https://images.pexels.com/photos/1181686/pexels-photo-1181686.jpeg?auto=compress&cs=tinysrgb&w=400",
      "isOnline": false,
    },
    {
      "id": "student_003",
      "name": "Rahul Kumar",
      "role": "Student",
      "email": "rahul.kumar@student.edu.in",
      "profileImage": null,
      "isOnline": true,
    },
    {
      "id": "student_004",
      "name": "Ananya Singh",
      "role": "Student",
      "email": "ananya.singh@student.edu.in",
      "profileImage":
          "https://images.pexels.com/photos/1181424/pexels-photo-1181424.jpeg?auto=compress&cs=tinysrgb&w=400",
      "isOnline": false,
    },
  ];

  bool get _isTeacher => _currentUser['role'] == 'teacher';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundOffWhite,
      body: Column(
        children: [
          ClassHeaderWidget(
            classData: _classData,
            onBack: () => _handleBackNavigation(),
            onShareCode: () => _handleShareCode(),
          ),
          TabSelectorWidget(
            selectedIndex: _selectedTabIndex,
            onTabSelected: (index) => setState(() => _selectedTabIndex = index),
            tabs: _tabs,
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _handleRefresh,
              child: _buildTabContent(),
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTabIndex) {
      case 0:
        return _buildAnnouncementsTab();
      case 1:
        return _buildAssignmentsTab();
      case 2:
        return _buildPeopleTab();
      default:
        return Container();
    }
  }

  Widget _buildAnnouncementsTab() {
    if (_announcements.isEmpty) {
      return EmptyStateWidget(
        title: 'No Announcements',
        message: 'There are no announcements in this class yet.',
        iconName: 'campaign',
        actionText: _isTeacher ? 'Create Announcement' : null,
        onAction: _isTeacher ? () => _handleCreateAnnouncement() : null,
      );
    }

    return ListView.builder(
      padding: EdgeInsets.only(bottom: 10.h),
      itemCount: _announcements.length,
      itemBuilder: (context, index) {
        final announcement = _announcements[index];
        return AnnouncementCardWidget(
          announcement: announcement,
          isTeacher: _isTeacher,
          onTap: () => _handleAnnouncementTap(announcement),
        );
      },
    );
  }

  Widget _buildAssignmentsTab() {
    if (_assignments.isEmpty) {
      return EmptyStateWidget(
        title: 'No Assignments',
        message: 'There are no assignments in this class yet.',
        iconName: 'assignment',
        actionText: _isTeacher ? 'Create Assignment' : null,
        onAction: _isTeacher ? () => _handleCreateAssignment() : null,
      );
    }

    return ListView.builder(
      padding: EdgeInsets.only(bottom: 10.h),
      itemCount: _assignments.length,
      itemBuilder: (context, index) {
        final assignment = _assignments[index];
        return AssignmentCardWidget(
          assignment: assignment,
          isTeacher: _isTeacher,
          onTap: () => _handleAssignmentTap(assignment),
          onEdit: _isTeacher ? () => _handleEditAssignment(assignment) : null,
          onDelete:
              _isTeacher ? () => _handleDeleteAssignment(assignment) : null,
          onSubmit:
              !_isTeacher ? () => _handleSubmitAssignment(assignment) : null,
          onViewFeedback:
              !_isTeacher ? () => _handleViewFeedback(assignment) : null,
        );
      },
    );
  }

  Widget _buildPeopleTab() {
    if (_people.isEmpty) {
      return EmptyStateWidget(
        title: 'No Members',
        message: 'There are no members in this class yet.',
        iconName: 'group',
      );
    }

    return ListView.builder(
      padding: EdgeInsets.only(bottom: 10.h),
      itemCount: _people.length,
      itemBuilder: (context, index) {
        final person = _people[index];
        final isCurrentUser = person['id'] == _currentUser['id'];

        return PeopleCardWidget(
          person: person,
          isTeacher: _isTeacher,
          isCurrentUser: isCurrentUser,
          onLongPress: _isTeacher && !isCurrentUser
              ? () => _handlePersonLongPress(person)
              : null,
        );
      },
    );
  }

  Widget? _buildFloatingActionButton() {
    if (!_isTeacher) return null;

    String iconName;
    VoidCallback onPressed;

    switch (_selectedTabIndex) {
      case 0:
        iconName = 'add';
        onPressed = _handleCreateAnnouncement;
        break;
      case 1:
        iconName = 'assignment_add';
        onPressed = _handleCreateAssignment;
        break;
      default:
        return null;
    }

    return FloatingActionButton(
      onPressed: onPressed,
      child: CustomIconWidget(
        iconName: iconName,
        color: Colors.white,
        size: 24,
      ),
    );
  }

  Future<void> _handleRefresh() async {
    setState(() => _isRefreshing = true);

    // Simulate network refresh
    await Future.delayed(Duration(seconds: 2));

    setState(() => _isRefreshing = false);

    Fluttertoast.showToast(
      msg: "Content refreshed successfully",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _handleBackNavigation() {
    if (_isTeacher) {
      Navigator.pushReplacementNamed(context, '/teacher-dashboard');
    } else {
      Navigator.pushReplacementNamed(context, '/student-dashboard');
    }
  }

  void _handleShareCode() {
    Fluttertoast.showToast(
      msg: "Class code ${_classData['code']} copied to clipboard",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _handleAnnouncementTap(Map<String, dynamic> announcement) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(announcement['title'] as String),
        content: SingleChildScrollView(
          child: Text(announcement['content'] as String),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _handleCreateAnnouncement() {
    Fluttertoast.showToast(
      msg: "Create announcement feature coming soon",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _handleAssignmentTap(Map<String, dynamic> assignment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(assignment['title'] as String),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(assignment['description'] as String),
              SizedBox(height: 2.h),
              Text(
                'Due: ${_formatDate(assignment['dueDate'] as DateTime)}',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (assignment['grade'] != null) ...[
                SizedBox(height: 1.h),
                Text(
                  'Grade: ${assignment['grade']}',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.successGreen,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _handleCreateAssignment() {
    Navigator.pushNamed(context, '/assignment-creation');
  }

  void _handleEditAssignment(Map<String, dynamic> assignment) {
    Fluttertoast.showToast(
      msg: "Edit assignment: ${assignment['title']}",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _handleDeleteAssignment(Map<String, dynamic> assignment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Assignment'),
        content:
            Text('Are you sure you want to delete "${assignment['title']}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _assignments.removeWhere((a) => a['id'] == assignment['id']);
              });
              Fluttertoast.showToast(
                msg: "Assignment deleted successfully",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
              );
            },
            child: Text(
              'Delete',
              style: TextStyle(color: AppTheme.alertRed),
            ),
          ),
        ],
      ),
    );
  }

  void _handleSubmitAssignment(Map<String, dynamic> assignment) {
    Fluttertoast.showToast(
      msg: "Submit assignment: ${assignment['title']}",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _handleViewFeedback(Map<String, dynamic> assignment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Assignment Feedback'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              assignment['title'] as String,
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Grade: ${assignment['grade']}',
              style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                color: AppTheme.successGreen,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Feedback: Good work! Your solutions are correct and well-presented. Keep up the excellent effort.',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _handlePersonLongPress(Map<String, dynamic> person) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.onSurfaceSecondary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              person['name'] as String,
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 3.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'message',
                color: AppTheme.primaryBlue,
                size: 24,
              ),
              title: Text('Send Message'),
              onTap: () {
                Navigator.pop(context);
                Fluttertoast.showToast(
                  msg: "Message feature coming soon",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                );
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'remove_circle',
                color: AppTheme.alertRed,
                size: 24,
              ),
              title: Text(
                'Remove from Class',
                style: TextStyle(color: AppTheme.alertRed),
              ),
              onTap: () {
                Navigator.pop(context);
                _showRemoveStudentDialog(person);
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _showRemoveStudentDialog(Map<String, dynamic> person) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Remove Student'),
        content: Text(
            'Are you sure you want to remove ${person['name']} from this class?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _people.removeWhere((p) => p['id'] == person['id']);
                _classData['memberCount'] =
                    (_classData['memberCount'] as int) - 1;
              });
              Fluttertoast.showToast(
                msg: "${person['name']} removed from class",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
              );
            },
            child: Text(
              'Remove',
              style: TextStyle(color: AppTheme.alertRed),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Tomorrow';
    } else if (difference.inDays == -1) {
      return 'Yesterday';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
