import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AnnouncementCardWidget extends StatelessWidget {
  final Map<String, dynamic> announcement;
  final bool isTeacher;
  final VoidCallback? onTap;

  const AnnouncementCardWidget({
    Key? key,
    required this.announcement,
    required this.isTeacher,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateTime timestamp = announcement['timestamp'] as DateTime;
    final String timeAgo = _getTimeAgo(timestamp);
    final bool hasAttachment = announcement['hasAttachment'] as bool? ?? false;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 2.5.h,
                      backgroundColor:
                          AppTheme.primaryBlue.withValues(alpha: 0.1),
                      child: CustomIconWidget(
                        iconName: isTeacher ? 'school' : 'person',
                        color: AppTheme.primaryBlue,
                        size: 20,
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            announcement['author'] as String,
                            style: AppTheme.lightTheme.textTheme.titleMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            timeAgo,
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.onSurfaceSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (hasAttachment)
                      Container(
                        padding: EdgeInsets.all(1.w),
                        decoration: BoxDecoration(
                          color: AppTheme.warningYellow.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: CustomIconWidget(
                          iconName: 'attach_file',
                          color: AppTheme.warningYellow,
                          size: 16,
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 2.h),
                Text(
                  announcement['title'] as String,
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 1.h),
                Text(
                  announcement['content'] as String,
                  style: AppTheme.lightTheme.textTheme.bodyMedium,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                if (announcement['type'] == 'assignment_reminder')
                  Container(
                    margin: EdgeInsets.only(top: 2.h),
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color: AppTheme.alertRed.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppTheme.alertRed.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'schedule',
                          color: AppTheme.alertRed,
                          size: 16,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Assignment Due: ${announcement['dueDate']}',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.alertRed,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
}
