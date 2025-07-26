import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LoadingStateWidget extends StatelessWidget {
  final String message;
  final bool isError;
  final String? errorMessage;
  final VoidCallback? onRetry;

  const LoadingStateWidget({
    super.key,
    required this.message,
    this.isError = false,
    this.errorMessage,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (!isError)
            SizedBox(
              width: 20.w,
              height: 20.w,
              child: CircularProgressIndicator(
                strokeWidth: 4,
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
            )
          else
            Icon(
              Icons.error_outline_rounded,
              size: 20.w,
              color: AppTheme.alertRed,
            ),
          SizedBox(height: 3.h),
          Text(
            message,
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: isError ? AppTheme.alertRed : AppTheme.onSurfacePrimary,
            ),
            textAlign: TextAlign.center,
          ),
          if (isError && errorMessage != null)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
              child: Text(
                errorMessage!,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.onSurfaceSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          if (isError && onRetry != null)
            Padding(
              padding: EdgeInsets.only(top: 3.h),
              child: ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: 5.w,
                    vertical: 1.5.h,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
