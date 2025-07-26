import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ErrorStateWidget extends StatelessWidget {
  final String title;
  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final bool showIcon;

  const ErrorStateWidget({
    super.key,
    required this.title,
    this.message,
    this.actionLabel,
    this.onAction,
    this.showIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (showIcon) ...[
              Icon(
                Icons.error_outline_rounded,
                size: 15.w,
                color: AppTheme.alertRed,
              ),
              SizedBox(height: 3.h),
            ],
            Text(
              title,
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.alertRed,
              ),
              textAlign: TextAlign.center,
            ),
            if (message != null) ...[
              SizedBox(height: 2.h),
              Text(
                message!,
                style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                  color: AppTheme.onSurfaceSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (onAction != null && actionLabel != null) ...[
              SizedBox(height: 4.h),
              ElevatedButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.refresh_rounded),
                label: Text(actionLabel!),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: 5.w,
                    vertical: 1.5.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  static String getErrorMessage(dynamic error) {
    if (error is Map<String, dynamic>) {
      // API error response
      if (error.containsKey('message')) {
        return error['message'].toString();
      } else if (error.containsKey('error')) {
        return error['error'].toString();
      }
    }

    // Default error message
    return 'Something went wrong. Please try again.';
  }

  static String getErrorTitle(dynamic error, {String defaultTitle = 'Error'}) {
    if (error is Map<String, dynamic>) {
      // Handle different API error codes
      if (error.containsKey('error_code')) {
        final code = error['error_code'];
        if (code == 400) {
          return 'Bad Request';
        } else if (code == 401) {
          return 'Authentication Error';
        } else if (code == 403) {
          return 'Access Denied';
        } else if (code == 404) {
          return 'Not Found';
        } else if (code == 429) {
          return 'Too Many Requests';
        } else if (code >= 500) {
          return 'Server Error';
        }
      }
    }

    return defaultTitle;
  }
}
