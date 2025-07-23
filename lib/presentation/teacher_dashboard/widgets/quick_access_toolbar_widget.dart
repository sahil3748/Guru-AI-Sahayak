import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuickAccessToolbarWidget extends StatelessWidget {
  final VoidCallback onAITools;
  final VoidCallback onReadingAssessment;
  final VoidCallback onLessonPlanner;

  const QuickAccessToolbarWidget({
    super.key,
    required this.onAITools,
    required this.onReadingAssessment,
    required this.onLessonPlanner,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90.w,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
        border: Border.all(
          color: AppTheme.outlineLight.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildToolButton(
            icon: 'auto_awesome',
            label: 'AI Tools',
            color: AppTheme.primaryBlue,
            onTap: onAITools,
          ),
          Container(
            width: 1,
            height: 8.h,
            color: AppTheme.outlineLight.withValues(alpha: 0.5),
          ),
          _buildToolButton(
            icon: 'record_voice_over',
            label: 'Reading\nAssessment',
            color: AppTheme.successGreen,
            onTap: onReadingAssessment,
          ),
          Container(
            width: 1,
            height: 8.h,
            color: AppTheme.outlineLight.withValues(alpha: 0.5),
          ),
          _buildToolButton(
            icon: 'assignment',
            label: 'Lesson\nPlanner',
            color: AppTheme.warningYellow,
            onTap: onLessonPlanner,
          ),
        ],
      ),
    );
  }

  Widget _buildToolButton({
    required String icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 2.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
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
              SizedBox(height: 1.h),
              Text(
                label,
                textAlign: TextAlign.center,
                style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                  color: AppTheme.onSurfacePrimary,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
