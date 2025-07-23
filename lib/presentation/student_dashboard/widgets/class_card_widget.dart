import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ClassCardWidget extends StatelessWidget {
  final Map<String, dynamic> classData;
  final VoidCallback onTap;
  final VoidCallback onViewAssignments;
  final VoidCallback onAskQuestion;
  final VoidCallback onViewFeed;

  const ClassCardWidget({
    super.key,
    required this.classData,
    required this.onTap,
    required this.onViewAssignments,
    required this.onAskQuestion,
    required this.onViewFeed,
  });

  @override
  Widget build(BuildContext context) {
    final String className =
        (classData['className'] as String?) ?? 'Unknown Class';
    final String teacherName =
        (classData['teacherName'] as String?) ?? 'Unknown Teacher';
    final int pendingAssignments =
        (classData['pendingAssignments'] as int?) ?? 0;
    final String recentAnnouncement =
        (classData['recentAnnouncement'] as String?) ??
            'No recent announcements';
    final String subject = (classData['subject'] as String?) ?? 'General';

    return Dismissible(
      key: Key('class_${classData['id']}'),
      direction: DismissDirection.horizontal,
      background: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: AppTheme.primaryBlue.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.all(4.w),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'assignment',
                      color: AppTheme.primaryBlue,
                      size: 24,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'View Assignments',
                      style:
                          AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                        color: AppTheme.primaryBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(4.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Ask Question',
                      style:
                          AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                        color: AppTheme.successGreen,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    CustomIconWidget(
                      iconName: 'help_outline',
                      color: AppTheme.successGreen,
                      size: 24,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
          onViewAssignments();
        } else {
          onAskQuestion();
        }
      },
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(4.w),
          margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: AppTheme.surfaceWhite,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppTheme.shadowLight,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(
              color: AppTheme.outlineLight,
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 12.w,
                    height: 12.w,
                    decoration: BoxDecoration(
                      color: _getSubjectColor(subject).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: CustomIconWidget(
                        iconName: _getSubjectIcon(subject),
                        color: _getSubjectColor(subject),
                        size: 24,
                      ),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          className,
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            color: AppTheme.onSurfacePrimary,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          'Teacher: $teacherName',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.onSurfaceSecondary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  pendingAssignments > 0
                      ? Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 2.w, vertical: 0.5.h),
                          decoration: BoxDecoration(
                            color: AppTheme.alertRed,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '$pendingAssignments',
                            style: AppTheme.lightTheme.textTheme.labelSmall
                                ?.copyWith(
                              color: AppTheme.surfaceWhite,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
              SizedBox(height: 2.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recent Announcement',
                      style:
                          AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                        color: AppTheme.onSurfaceSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      recentAnnouncement,
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.onSurfacePrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 2.h),
              Row(
                children: [
                  Expanded(
                    child: TextButton.icon(
                      onPressed: onViewFeed,
                      icon: CustomIconWidget(
                        iconName: 'feed',
                        color: AppTheme.primaryBlue,
                        size: 16,
                      ),
                      label: Text(
                        'Class Feed',
                        style:
                            AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color: AppTheme.primaryBlue,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 4.h,
                    color: AppTheme.outlineLight,
                  ),
                  Expanded(
                    child: TextButton.icon(
                      onPressed: onViewAssignments,
                      icon: CustomIconWidget(
                        iconName: 'assignment',
                        color: AppTheme.successGreen,
                        size: 16,
                      ),
                      label: Text(
                        'Assignments',
                        style:
                            AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color: AppTheme.successGreen,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getSubjectColor(String subject) {
    switch (subject.toLowerCase()) {
      case 'math':
      case 'mathematics':
        return AppTheme.primaryBlue;
      case 'science':
        return AppTheme.successGreen;
      case 'english':
      case 'language':
        return AppTheme.alertRed;
      case 'social studies':
      case 'history':
        return const Color(0xFF9C27B0);
      default:
        return AppTheme.onSurfaceSecondary;
    }
  }

  String _getSubjectIcon(String subject) {
    switch (subject.toLowerCase()) {
      case 'math':
      case 'mathematics':
        return 'calculate';
      case 'science':
        return 'science';
      case 'english':
      case 'language':
        return 'menu_book';
      case 'social studies':
      case 'history':
        return 'public';
      default:
        return 'school';
    }
  }
}
