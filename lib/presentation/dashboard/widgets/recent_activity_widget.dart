import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RecentActivityWidget extends StatelessWidget {
  final List<Map<String, dynamic>> activities;

  const RecentActivityWidget({
    super.key,
    required this.activities,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Activity',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.onSurfacePrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          activities.isNotEmpty
              ? ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: activities.length > 5 ? 5 : activities.length,
                  separatorBuilder: (context, index) => SizedBox(height: 1.h),
                  itemBuilder: (context, index) {
                    final activity = activities[index];
                    return _buildActivityItem(activity, context);
                  },
                )
              : _buildEmptyState(),
        ],
      ),
    );
  }

  Widget _buildActivityItem(
      Map<String, dynamic> activity, BuildContext context) {
    final String type = (activity['type'] as String?) ?? 'unknown';
    final String title = (activity['title'] as String?) ?? 'Unknown Activity';
    final String description = (activity['description'] as String?) ?? '';
    final DateTime timestamp =
        activity['timestamp'] as DateTime? ?? DateTime.now();
    final String? score = activity['score'] as String?;
    final String? feedback = activity['feedback'] as String?;

    return GestureDetector(
      onLongPress: () => _showActivityOptions(context, activity),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: AppTheme.surfaceWhite,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.outlineLight,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 10.w,
              height: 10.w,
              decoration: BoxDecoration(
                color: _getActivityColor(type).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: _getActivityIcon(type),
                  color: _getActivityColor(type),
                  size: 20,
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
                          title,
                          style: AppTheme.lightTheme.textTheme.titleSmall
                              ?.copyWith(
                            color: AppTheme.onSurfacePrimary,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (score != null)
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 2.w, vertical: 0.5.h),
                          decoration: BoxDecoration(
                            color: _getScoreColor(score).withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            score,
                            style: AppTheme.lightTheme.textTheme.labelSmall
                                ?.copyWith(
                              color: _getScoreColor(score),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                  if (description.isNotEmpty) ...[
                    SizedBox(height: 0.5.h),
                    Text(
                      description,
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.onSurfaceSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  if (feedback != null && feedback.isNotEmpty) ...[
                    SizedBox(height: 0.5.h),
                    Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: AppTheme.successGreen.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'feedback',
                            color: AppTheme.successGreen,
                            size: 14,
                          ),
                          SizedBox(width: 1.w),
                          Expanded(
                            child: Text(
                              feedback,
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme.successGreen,
                                fontStyle: FontStyle.italic,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  SizedBox(height: 0.5.h),
                  Text(
                    _formatTimestamp(timestamp),
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      color: AppTheme.onSurfaceDisabled,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: AppTheme.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Container(
            width: 16.w,
            height: 16.w,
            decoration: BoxDecoration(
              color: AppTheme.primaryBlue.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: 'timeline',
                color: AppTheme.primaryBlue,
                size: 32,
              ),
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            'No Recent Activity',
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              color: AppTheme.onSurfacePrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Complete assignments and quizzes to see your activity here!',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.onSurfaceSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showActivityOptions(
      BuildContext context, Map<String, dynamic> activity) {
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
              activity['title'] as String? ?? 'Activity Options',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.onSurfacePrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 3.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'visibility',
                color: AppTheme.primaryBlue,
                size: 24,
              ),
              title: Text(
                'View Details',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.onSurfacePrimary,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                // Handle view details
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'help_outline',
                color: AppTheme.successGreen,
                size: 24,
              ),
              title: Text(
                'Ask for Help',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.onSurfacePrimary,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                // Handle ask for help
              },
            ),
            if (activity['type'] == 'assignment')
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'check_circle',
                  color: AppTheme.alertRed,
                  size: 24,
                ),
                title: Text(
                  'Mark Complete',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.onSurfacePrimary,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  // Handle mark complete
                },
              ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Color _getActivityColor(String type) {
    switch (type.toLowerCase()) {
      case 'assignment':
        return AppTheme.primaryBlue;
      case 'quiz':
        return AppTheme.successGreen;
      case 'feedback':
        return AppTheme.warningYellow;
      default:
        return AppTheme.onSurfaceSecondary;
    }
  }

  String _getActivityIcon(String type) {
    switch (type.toLowerCase()) {
      case 'assignment':
        return 'assignment';
      case 'quiz':
        return 'quiz';
      case 'feedback':
        return 'feedback';
      default:
        return 'event';
    }
  }

  Color _getScoreColor(String score) {
    if (score.contains('%')) {
      final percentage = int.tryParse(score.replaceAll('%', '')) ?? 0;
      if (percentage >= 80) return AppTheme.successGreen;
      if (percentage >= 60) return AppTheme.warningYellow;
      return AppTheme.alertRed;
    }
    return AppTheme.primaryBlue;
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }
}
