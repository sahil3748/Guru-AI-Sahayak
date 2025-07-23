import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class GreetingCardWidget extends StatelessWidget {
  final String teacherName;
  final String schoolName;
  final int todayClassesCount;
  final int pendingTasksCount;

  const GreetingCardWidget({
    super.key,
    required this.teacherName,
    required this.schoolName,
    required this.todayClassesCount,
    required this.pendingTasksCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90.w,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryBlue.withValues(alpha: 0.1),
            AppTheme.successGreen.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.outlineLight.withValues(alpha: 0.3),
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
                  color: AppTheme.primaryBlue.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: 'school',
                  color: AppTheme.primaryBlue,
                  size: 6.w,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Good Morning, $teacherName!',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.onSurfacePrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      schoolName,
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
          SizedBox(height: 3.h),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  icon: 'today',
                  title: 'Today\'s Classes',
                  count: todayClassesCount.toString(),
                  color: AppTheme.primaryBlue,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildStatCard(
                  icon: 'assignment',
                  title: 'Pending Tasks',
                  count: pendingTasksCount.toString(),
                  color: AppTheme.warningYellow,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String icon,
    required String title,
    required String count,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.surfaceWhite.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: icon,
                color: color,
                size: 4.w,
              ),
              SizedBox(width: 2.w),
              Text(
                count,
                style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            title,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.onSurfaceSecondary,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
