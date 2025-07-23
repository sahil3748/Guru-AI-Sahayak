import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SubjectSelectionCard extends StatelessWidget {
  final String subject;
  final String iconName;
  final Color backgroundColor;
  final bool isSelected;
  final VoidCallback onTap;

  const SubjectSelectionCard({
    super.key,
    required this.subject,
    required this.iconName,
    required this.backgroundColor,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42.w,
        height: 20.h,
        margin: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          color: isSelected
              ? backgroundColor.withValues(alpha: 0.2)
              : AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? backgroundColor
                : AppTheme.lightTheme.colorScheme.outline,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.shadowLight,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 15.w,
              height: 15.w,
              decoration: BoxDecoration(
                color: backgroundColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: iconName,
                  color: backgroundColor,
                  size: 8.w,
                ),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              subject,
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: isSelected ? backgroundColor : AppTheme.onSurfacePrimary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
