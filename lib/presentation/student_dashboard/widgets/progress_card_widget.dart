import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProgressCardWidget extends StatelessWidget {
  final int completedGoals;
  final int totalGoals;
  final List<String> achievements;

  const ProgressCardWidget({
    super.key,
    required this.completedGoals,
    required this.totalGoals,
    required this.achievements,
  });

  @override
  Widget build(BuildContext context) {
    final double progressPercentage =
        totalGoals > 0 ? completedGoals / totalGoals : 0.0;

    return Container(
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
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Weekly Learning Goals',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.onSurfacePrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$completedGoals/$totalGoals',
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    color: AppTheme.primaryBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Container(
            width: double.infinity,
            height: 1.h,
            decoration: BoxDecoration(
              color: AppTheme.outlineLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progressPercentage,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppTheme.primaryBlue, AppTheme.successGreen],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            'Achievement Badges',
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              color: AppTheme.onSurfacePrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 1.h),
          achievements.isNotEmpty
              ? Wrap(
                  spacing: 2.w,
                  runSpacing: 1.h,
                  children: achievements.take(4).map((achievement) {
                    return Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                      decoration: BoxDecoration(
                        color: AppTheme.warningYellow.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppTheme.warningYellow.withValues(alpha: 0.5),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '🏆',
                            style: TextStyle(fontSize: 10.sp),
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            achievement,
                            style: AppTheme.lightTheme.textTheme.labelSmall
                                ?.copyWith(
                              color: AppTheme.onSurfacePrimary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                )
              : Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'emoji_events',
                        color: AppTheme.onSurfaceSecondary,
                        size: 20,
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: Text(
                          'Complete your first goal to earn badges!',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.onSurfaceSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}
