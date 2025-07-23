import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ClassCardWidget extends StatelessWidget {
  final Map<String, dynamic> classData;
  final VoidCallback onTap;
  final VoidCallback onPostAnnouncement;
  final VoidCallback onViewStudents;
  final VoidCallback onClassSettings;

  const ClassCardWidget({
    super.key,
    required this.classData,
    required this.onTap,
    required this.onPostAnnouncement,
    required this.onViewStudents,
    required this.onClassSettings,
  });

  @override
  Widget build(BuildContext context) {
    final className = (classData['name'] as String?) ?? 'Unknown Class';
    final studentCount = (classData['studentCount'] as int?) ?? 0;
    final recentActivity =
        (classData['recentActivity'] as String?) ?? 'No recent activity';
    final unreadCount = (classData['unreadAnnouncements'] as int?) ?? 0;
    final subject = (classData['subject'] as String?) ?? 'General';
    final grade = (classData['grade'] as String?) ?? '';

    return Dismissible(
      key: Key('class_${classData['id']}'),
      direction: DismissDirection.startToEnd,
      background: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: AppTheme.primaryBlue.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 6.w),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomIconWidget(
                  iconName: 'campaign',
                  color: AppTheme.primaryBlue,
                  size: 6.w,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Quick Actions',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.primaryBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      confirmDismiss: (direction) async {
        _showQuickActionsBottomSheet(context);
        return false;
      },
      child: GestureDetector(
        onTap: onTap,
        onLongPress: () => _showContextMenu(context),
        child: Container(
          width: 90.w,
          margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          padding: EdgeInsets.all(4.w),
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
              color: AppTheme.outlineLight.withValues(alpha: 0.5),
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
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.primaryBlue,
                          AppTheme.successGreen,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        className.isNotEmpty ? className[0].toUpperCase() : 'C',
                        style:
                            AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                          color: AppTheme.surfaceWhite,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                className,
                                style: AppTheme.lightTheme.textTheme.titleMedium
                                    ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.onSurfacePrimary,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (unreadCount > 0)
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 2.w, vertical: 0.5.h),
                                decoration: BoxDecoration(
                                  color: AppTheme.alertRed,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  unreadCount.toString(),
                                  style: AppTheme
                                      .lightTheme.textTheme.labelSmall
                                      ?.copyWith(
                                    color: AppTheme.surfaceWhite,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        if (grade.isNotEmpty)
                          Text(
                            '$subject • Grade $grade',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.onSurfaceSecondary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'people',
                    color: AppTheme.onSurfaceSecondary,
                    size: 4.w,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    '$studentCount students',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.onSurfaceSecondary,
                    ),
                  ),
                  const Spacer(),
                  CustomIconWidget(
                    iconName: 'access_time',
                    color: AppTheme.onSurfaceSecondary,
                    size: 4.w,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    '2 hours ago',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.onSurfaceSecondary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceVariant.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'info_outline',
                      color: AppTheme.onSurfaceSecondary,
                      size: 4.w,
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        recentActivity,
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.onSurfaceSecondary,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showQuickActionsBottomSheet(BuildContext context) {
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
                    'Quick Actions',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  _buildActionTile(
                    context,
                    icon: 'campaign',
                    title: 'Post Announcement',
                    subtitle: 'Share updates with students',
                    onTap: () {
                      Navigator.pop(context);
                      onPostAnnouncement();
                    },
                  ),
                  _buildActionTile(
                    context,
                    icon: 'people',
                    title: 'View Students',
                    subtitle: 'Manage class members',
                    onTap: () {
                      Navigator.pop(context);
                      onViewStudents();
                    },
                  ),
                  _buildActionTile(
                    context,
                    icon: 'settings',
                    title: 'Class Settings',
                    subtitle: 'Configure class preferences',
                    onTap: () {
                      Navigator.pop(context);
                      onClassSettings();
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

  Widget _buildActionTile(
    BuildContext context, {
    required String icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        width: 10.w,
        height: 10.w,
        decoration: BoxDecoration(
          color: AppTheme.primaryBlue.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: CustomIconWidget(
          iconName: icon,
          color: AppTheme.primaryBlue,
          size: 5.w,
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

  void _showContextMenu(BuildContext context) {
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
                    'Class Options',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  _buildActionTile(
                    context,
                    icon: 'archive',
                    title: 'Archive Class',
                    subtitle: 'Move to archived classes',
                    onTap: () => Navigator.pop(context),
                  ),
                  _buildActionTile(
                    context,
                    icon: 'content_copy',
                    title: 'Duplicate Class',
                    subtitle: 'Create a copy of this class',
                    onTap: () => Navigator.pop(context),
                  ),
                  _buildActionTile(
                    context,
                    icon: 'share',
                    title: 'Share Class Code',
                    subtitle: 'Share joining code with students',
                    onTap: () => Navigator.pop(context),
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
}
