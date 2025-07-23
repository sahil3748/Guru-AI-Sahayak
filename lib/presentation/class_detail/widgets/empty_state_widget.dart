import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String message;
  final String iconName;
  final String? actionText;
  final VoidCallback? onAction;

  const EmptyStateWidget({
    Key? key,
    required this.title,
    required this.message,
    required this.iconName,
    this.actionText,
    this.onAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: iconName,
                  color: AppTheme.primaryBlue,
                  size: 10.w,
                ),
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              title,
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.onSurfacePrimary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            Text(
              message,
              style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                color: AppTheme.onSurfaceSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (actionText != null && onAction != null) ...[
              SizedBox(height: 4.h),
              ElevatedButton(
                onPressed: onAction,
                child: Text(actionText!),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
