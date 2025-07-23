import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class GradeLevelPicker extends StatelessWidget {
  final int selectedGrade;
  final Function(int) onGradeSelected;

  const GradeLevelPicker({
    super.key,
    required this.selectedGrade,
    required this.onGradeSelected,
  });

  String _getDifficultyDescription(int grade) {
    switch (grade) {
      case 3:
      case 4:
        return "Basic concepts and simple problems";
      case 5:
      case 6:
        return "Intermediate level with detailed explanations";
      case 7:
      case 8:
        return "Advanced concepts and complex problems";
      default:
        return "Age-appropriate content";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Select Grade Level",
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.onSurfacePrimary,
          ),
        ),
        SizedBox(height: 2.h),
        Container(
          height: 12.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 6,
            itemBuilder: (context, index) {
              final grade = index + 3;
              final isSelected = grade == selectedGrade;

              return GestureDetector(
                onTap: () => onGradeSelected(grade),
                child: Container(
                  width: 20.w,
                  margin: EdgeInsets.only(right: 3.w),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.primaryBlue.withValues(alpha: 0.1)
                        : AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.primaryBlue
                          : AppTheme.lightTheme.colorScheme.outline,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Grade",
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: isSelected
                              ? AppTheme.primaryBlue
                              : AppTheme.onSurfaceSecondary,
                        ),
                      ),
                      Text(
                        grade.toString(),
                        style: AppTheme.lightTheme.textTheme.headlineSmall
                            ?.copyWith(
                          color: isSelected
                              ? AppTheme.primaryBlue
                              : AppTheme.onSurfacePrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          _getDifficultyDescription(selectedGrade),
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.onSurfaceSecondary,
          ),
        ),
      ],
    );
  }
}
