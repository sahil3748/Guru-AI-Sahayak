import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuestionCountSelector extends StatelessWidget {
  final int questionCount;
  final int selectedGrade;
  final Function(int) onCountChanged;

  const QuestionCountSelector({
    super.key,
    required this.questionCount,
    required this.selectedGrade,
    required this.onCountChanged,
  });

  Map<String, int> _getRecommendedRange(int grade) {
    switch (grade) {
      case 3:
      case 4:
        return {'min': 5, 'max': 10, 'recommended': 8};
      case 5:
      case 6:
        return {'min': 8, 'max': 15, 'recommended': 12};
      case 7:
      case 8:
        return {'min': 10, 'max': 20, 'recommended': 15};
      default:
        return {'min': 5, 'max': 15, 'recommended': 10};
    }
  }

  @override
  Widget build(BuildContext context) {
    final range = _getRecommendedRange(selectedGrade);
    final minCount = range['min']!;
    final maxCount = range['max']!;
    final recommendedCount = range['recommended']!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Number of Questions",
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.onSurfacePrimary,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          "Recommended: $recommendedCount questions for Grade $selectedGrade",
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.onSurfaceSecondary,
          ),
        ),
        SizedBox(height: 2.h),
        Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStepperButton(
                iconName: 'remove',
                onTap: () {
                  if (questionCount > minCount) {
                    onCountChanged(questionCount - 1);
                  }
                },
                isEnabled: questionCount > minCount,
              ),
              Column(
                children: [
                  Text(
                    questionCount.toString(),
                    style:
                        AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
                      color: AppTheme.primaryBlue,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    "Questions",
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.onSurfaceSecondary,
                    ),
                  ),
                ],
              ),
              _buildStepperButton(
                iconName: 'add',
                onTap: () {
                  if (questionCount < maxCount) {
                    onCountChanged(questionCount + 1);
                  }
                },
                isEnabled: questionCount < maxCount,
              ),
            ],
          ),
        ),
        SizedBox(height: 2.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildQuickSelectButton(minCount, "Min"),
            _buildQuickSelectButton(recommendedCount, "Recommended"),
            _buildQuickSelectButton(maxCount, "Max"),
          ],
        ),
      ],
    );
  }

  Widget _buildStepperButton({
    required String iconName,
    required VoidCallback onTap,
    required bool isEnabled,
  }) {
    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: Container(
        width: 12.w,
        height: 12.w,
        decoration: BoxDecoration(
          color: isEnabled
              ? AppTheme.primaryBlue.withValues(alpha: 0.1)
              : AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isEnabled
                ? AppTheme.primaryBlue
                : AppTheme.lightTheme.colorScheme.outline,
          ),
        ),
        child: Center(
          child: CustomIconWidget(
            iconName: iconName,
            color:
                isEnabled ? AppTheme.primaryBlue : AppTheme.onSurfaceDisabled,
            size: 6.w,
          ),
        ),
      ),
    );
  }

  Widget _buildQuickSelectButton(int count, String label) {
    final isSelected = questionCount == count;

    return GestureDetector(
      onTap: () => onCountChanged(count),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryBlue.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppTheme.primaryBlue
                : AppTheme.lightTheme.colorScheme.outline,
          ),
        ),
        child: Column(
          children: [
            Text(
              count.toString(),
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                color: isSelected
                    ? AppTheme.primaryBlue
                    : AppTheme.onSurfacePrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: isSelected
                    ? AppTheme.primaryBlue
                    : AppTheme.onSurfaceSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
