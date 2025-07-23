import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EmptyStateWidget extends StatelessWidget {
  final VoidCallback onCreateClass;

  const EmptyStateWidget({
    super.key,
    required this.onCreateClass,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90.w,
      padding: EdgeInsets.all(6.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // GuruAI Mascot Illustration
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.primaryBlue.withValues(alpha: 0.1),
                  AppTheme.successGreen.withValues(alpha: 0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20.w),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Mascot face
                Container(
                  width: 30.w,
                  height: 30.w,
                  decoration: BoxDecoration(
                    color: AppTheme.warningYellow.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(15.w),
                  ),
                ),
                // Glasses
                Positioned(
                  top: 12.w,
                  child: Container(
                    width: 20.w,
                    height: 6.w,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryBlue.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(3.w),
                    ),
                  ),
                ),
                // Beard
                Positioned(
                  bottom: 8.w,
                  child: Container(
                    width: 15.w,
                    height: 8.w,
                    decoration: BoxDecoration(
                      color: AppTheme.onSurfaceSecondary.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(4.w),
                    ),
                  ),
                ),
                // Eyes
                Positioned(
                  top: 10.w,
                  left: 10.w,
                  child: Container(
                    width: 2.w,
                    height: 2.w,
                    decoration: BoxDecoration(
                      color: AppTheme.onSurfacePrimary,
                      borderRadius: BorderRadius.circular(1.w),
                    ),
                  ),
                ),
                Positioned(
                  top: 10.w,
                  right: 10.w,
                  child: Container(
                    width: 2.w,
                    height: 2.w,
                    decoration: BoxDecoration(
                      color: AppTheme.onSurfacePrimary,
                      borderRadius: BorderRadius.circular(1.w),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Welcome to GuruAI!',
            style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppTheme.onSurfacePrimary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 2.h),
          Text(
            'Start your teaching journey by creating your first class. Connect with students and unlock the power of AI-assisted learning.',
            style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
              color: AppTheme.onSurfaceSecondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4.h),
          ElevatedButton.icon(
            onPressed: onCreateClass,
            icon: CustomIconWidget(
              iconName: 'add',
              color: AppTheme.surfaceWhite,
              size: 5.w,
            ),
            label: Text(
              'Create Your First Class',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.surfaceWhite,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryBlue,
              foregroundColor: AppTheme.surfaceWhite,
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
            ),
          ),
          SizedBox(height: 3.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildFeatureChip('AI-Powered', AppTheme.primaryBlue),
              SizedBox(width: 2.w),
              _buildFeatureChip('Multi-Grade', AppTheme.successGreen),
              SizedBox(width: 2.w),
              _buildFeatureChip('Offline Ready', AppTheme.warningYellow),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureChip(String label, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
