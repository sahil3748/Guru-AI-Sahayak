import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class DifficultySlider extends StatelessWidget {
  final double difficulty;
  final Function(double) onDifficultyChanged;

  const DifficultySlider({
    super.key,
    required this.difficulty,
    required this.onDifficultyChanged,
  });

  String _getDifficultyLabel(double value) {
    if (value <= 0.33) return "Easy";
    if (value <= 0.66) return "Medium";
    return "Hard";
  }

  String _getEstimatedTime(double value) {
    if (value <= 0.33) return "15-20 mins";
    if (value <= 0.66) return "25-30 mins";
    return "35-45 mins";
  }

  Color _getDifficultyColor(double value) {
    if (value <= 0.33) return AppTheme.successGreen;
    if (value <= 0.66) return AppTheme.warningYellow;
    return AppTheme.alertRed;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Difficulty Level",
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.onSurfacePrimary,
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
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _getDifficultyLabel(difficulty),
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: _getDifficultyColor(difficulty),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color: _getDifficultyColor(difficulty)
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _getEstimatedTime(difficulty),
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: _getDifficultyColor(difficulty),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: _getDifficultyColor(difficulty),
                  thumbColor: _getDifficultyColor(difficulty),
                  overlayColor:
                      _getDifficultyColor(difficulty).withValues(alpha: 0.2),
                  inactiveTrackColor: AppTheme.lightTheme.colorScheme.outline,
                  trackHeight: 6,
                  thumbShape:
                      const RoundSliderThumbShape(enabledThumbRadius: 12),
                ),
                child: Slider(
                  value: difficulty,
                  onChanged: onDifficultyChanged,
                  min: 0.0,
                  max: 1.0,
                  divisions: 2,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildDifficultyIndicator(
                      "Easy", AppTheme.successGreen, difficulty <= 0.33),
                  _buildDifficultyIndicator("Medium", AppTheme.warningYellow,
                      difficulty > 0.33 && difficulty <= 0.66),
                  _buildDifficultyIndicator(
                      "Hard", AppTheme.alertRed, difficulty > 0.66),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDifficultyIndicator(String label, Color color, bool isActive) {
    return Column(
      children: [
        Container(
          width: 3.w,
          height: 3.w,
          decoration: BoxDecoration(
            color: isActive ? color : color.withValues(alpha: 0.3),
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: isActive ? color : AppTheme.onSurfaceSecondary,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
