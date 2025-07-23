import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EmptyStateWidget extends StatelessWidget {
  final VoidCallback onEnterClassCode;

  const EmptyStateWidget({
    super.key,
    required this.onEnterClassCode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(6.w),
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 24.w,
            height: 24.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  AppTheme.primaryBlue.withValues(alpha: 0.2),
                  AppTheme.successGreen.withValues(alpha: 0.2),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(
                color: AppTheme.primaryBlue.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                '🧙‍♂️',
                style: TextStyle(fontSize: 16.sp),
              ),
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            'Welcome to GuruAI!',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              color: AppTheme.primaryBlue,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 2.h),
          Text(
            'Ready to start your learning journey? Join your first class to unlock amazing features!',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.onSurfaceSecondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.primaryBlue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppTheme.primaryBlue.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'school',
                      color: AppTheme.primaryBlue,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'What you\'ll get:',
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        color: AppTheme.primaryBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                _buildFeatureItem(
                  icon: 'assignment',
                  title: 'Interactive Assignments',
                  description: 'Complete fun and engaging tasks',
                ),
                SizedBox(height: 1.h),
                _buildFeatureItem(
                  icon: 'chat',
                  title: 'AI Tutor Support',
                  description: 'Get help whenever you need it',
                ),
                SizedBox(height: 1.h),
                _buildFeatureItem(
                  icon: 'quiz',
                  title: 'Practice Quizzes',
                  description: 'Test your knowledge and improve',
                ),
              ],
            ),
          ),
          SizedBox(height: 4.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onEnterClassCode,
              icon: CustomIconWidget(
                iconName: 'add_circle',
                color: AppTheme.surfaceWhite,
                size: 20,
              ),
              label: Text(
                'Enter Class Code',
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  color: AppTheme.surfaceWhite,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryBlue,
                foregroundColor: AppTheme.surfaceWhite,
                padding: EdgeInsets.symmetric(vertical: 2.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
              ),
            ),
          ),
          SizedBox(height: 2.h),
          TextButton.icon(
            onPressed: () {
              // Navigate to teacher dashboard or show info
            },
            icon: CustomIconWidget(
              iconName: 'info_outline',
              color: AppTheme.onSurfaceSecondary,
              size: 16,
            ),
            label: Text(
              'Are you a teacher? Switch to Teacher Mode',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.onSurfaceSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem({
    required String icon,
    required String title,
    required String description,
  }) {
    return Row(
      children: [
        Container(
          width: 8.w,
          height: 8.w,
          decoration: BoxDecoration(
            color: AppTheme.primaryBlue.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: CustomIconWidget(
              iconName: icon,
              color: AppTheme.primaryBlue,
              size: 16,
            ),
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                  color: AppTheme.onSurfacePrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                description,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.onSurfaceSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
