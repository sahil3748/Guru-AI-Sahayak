import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class ProgressIndicatorWidget extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const ProgressIndicatorWidget({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        children: [
          Row(
            children: List.generate(totalSteps, (index) {
              final stepNumber = index + 1;
              final isCompleted = stepNumber < currentStep;
              final isCurrent = stepNumber == currentStep;

              return Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: isCompleted || isCurrent
                              ? AppTheme.primaryBlue
                              : AppTheme.lightTheme.colorScheme.outline,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    if (index < totalSteps - 1) SizedBox(width: 2.w),
                  ],
                ),
              );
            }),
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Step $currentStep of $totalSteps",
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.onSurfaceSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                "${((currentStep / totalSteps) * 100).round()}% Complete",
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.primaryBlue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
