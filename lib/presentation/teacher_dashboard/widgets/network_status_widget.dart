import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class NetworkStatusWidget extends StatelessWidget {
  final bool isOnline;
  final bool isSyncing;

  const NetworkStatusWidget({
    super.key,
    required this.isOnline,
    this.isSyncing = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: isOnline
            ? AppTheme.successGreen.withValues(alpha: 0.1)
            : AppTheme.alertRed.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isOnline
              ? AppTheme.successGreen.withValues(alpha: 0.3)
              : AppTheme.alertRed.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isSyncing)
            SizedBox(
              width: 3.w,
              height: 3.w,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  isOnline ? AppTheme.successGreen : AppTheme.alertRed,
                ),
              ),
            )
          else
            CustomIconWidget(
              iconName: isOnline ? 'wifi' : 'wifi_off',
              color: isOnline ? AppTheme.successGreen : AppTheme.alertRed,
              size: 3.w,
            ),
          SizedBox(width: 1.w),
          Text(
            isSyncing
                ? 'Syncing...'
                : isOnline
                    ? 'Online'
                    : 'Offline',
            style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
              color: isOnline ? AppTheme.successGreen : AppTheme.alertRed,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
