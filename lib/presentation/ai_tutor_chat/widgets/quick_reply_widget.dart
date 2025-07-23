import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class QuickReplyWidget extends StatelessWidget {
  final List<String> quickReplies;
  final Function(String) onQuickReply;

  const QuickReplyWidget({
    Key? key,
    required this.quickReplies,
    required this.onQuickReply,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 6.h,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: quickReplies.length,
        separatorBuilder: (context, index) => SizedBox(width: 2.w),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => onQuickReply(quickReplies[index]),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: AppTheme.surfaceWhite,
                borderRadius: BorderRadius.circular(6.w),
                border: Border.all(
                  color: AppTheme.primaryBlue.withValues(alpha: 0.3),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.shadowLight,
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  quickReplies[index],
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.primaryBlue,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
