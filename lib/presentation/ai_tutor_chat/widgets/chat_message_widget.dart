import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ChatMessageWidget extends StatelessWidget {
  final Map<String, dynamic> message;
  final bool isUser;

  const ChatMessageWidget({
    Key? key,
    required this.message,
    required this.isUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              width: 8.w,
              height: 8.w,
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue,
                borderRadius: BorderRadius.circular(4.w),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'psychology',
                  color: AppTheme.surfaceWhite,
                  size: 5.w,
                ),
              ),
            ),
            SizedBox(width: 2.w),
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(maxWidth: 75.w),
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: isUser ? AppTheme.primaryBlue : AppTheme.surfaceWhite,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4.w),
                  topRight: Radius.circular(4.w),
                  bottomLeft: Radius.circular(isUser ? 4.w : 1.w),
                  bottomRight: Radius.circular(isUser ? 1.w : 4.w),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.shadowLight,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (message['type'] == 'image' &&
                      message['imageUrl'] != null) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(2.w),
                      child: CustomImageWidget(
                        imageUrl: message['imageUrl'] as String,
                        width: double.infinity,
                        height: 20.h,
                        fit: BoxFit.cover,
                      ),
                    ),
                    if (message['content'] != null &&
                        (message['content'] as String).isNotEmpty)
                      SizedBox(height: 1.h),
                  ],
                  if (message['content'] != null &&
                      (message['content'] as String).isNotEmpty)
                    Text(
                      message['content'] as String,
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: isUser
                            ? AppTheme.surfaceWhite
                            : AppTheme.onSurfacePrimary,
                        height: 1.4,
                      ),
                    ),
                  SizedBox(height: 0.5.h),
                  Text(
                    _formatTime(message['timestamp'] as DateTime),
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: isUser
                          ? AppTheme.surfaceWhite.withValues(alpha: 0.7)
                          : AppTheme.onSurfaceSecondary,
                      fontSize: 10.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isUser) ...[
            SizedBox(width: 2.w),
            Container(
              width: 8.w,
              height: 8.w,
              decoration: BoxDecoration(
                color: AppTheme.successGreen,
                borderRadius: BorderRadius.circular(4.w),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'person',
                  color: AppTheme.surfaceWhite,
                  size: 5.w,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
}
