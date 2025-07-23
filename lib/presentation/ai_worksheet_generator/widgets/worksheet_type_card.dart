import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class WorksheetTypeCard extends StatelessWidget {
  final String type;
  final String description;
  final String example;
  final String iconName;
  final bool isSelected;
  final VoidCallback onTap;

  const WorksheetTypeCard({
    super.key,
    required this.type,
    required this.description,
    required this.example,
    required this.iconName,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(vertical: 1.h),
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryBlue.withValues(alpha: 0.1)
              : AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? AppTheme.primaryBlue
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
        child: Row(
          children: [
            Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.primaryBlue.withValues(alpha: 0.2)
                    : AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: iconName,
                  color: isSelected
                      ? AppTheme.primaryBlue
                      : AppTheme.onSurfaceSecondary,
                  size: 6.w,
                ),
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    type,
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? AppTheme.primaryBlue
                          : AppTheme.onSurfacePrimary,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    description,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.onSurfaceSecondary,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color: AppTheme
                          .lightTheme.colorScheme.surfaceContainerHighest
                          .withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      example,
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: AppTheme.onSurfaceSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              CustomIconWidget(
                iconName: 'check_circle',
                color: AppTheme.primaryBlue,
                size: 6.w,
              ),
          ],
        ),
      ),
    );
  }
}
