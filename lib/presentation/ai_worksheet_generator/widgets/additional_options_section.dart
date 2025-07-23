import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AdditionalOptionsSection extends StatelessWidget {
  final bool includeAnswerKey;
  final bool includeHints;
  final bool culturalContext;
  final Function(bool) onAnswerKeyChanged;
  final Function(bool) onHintsChanged;
  final Function(bool) onCulturalContextChanged;

  const AdditionalOptionsSection({
    super.key,
    required this.includeAnswerKey,
    required this.includeHints,
    required this.culturalContext,
    required this.onAnswerKeyChanged,
    required this.onHintsChanged,
    required this.onCulturalContextChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Additional Options",
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
              _buildOptionTile(
                title: "Include Answer Key",
                subtitle: "Generate solutions with explanations",
                iconName: 'key',
                value: includeAnswerKey,
                onChanged: onAnswerKeyChanged,
              ),
              Divider(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
                height: 3.h,
              ),
              _buildOptionTile(
                title: "Include Hints",
                subtitle: "Add helpful hints for difficult questions",
                iconName: 'lightbulb_outline',
                value: includeHints,
                onChanged: onHintsChanged,
              ),
              Divider(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
                height: 3.h,
              ),
              _buildOptionTile(
                title: "Indian Cultural Context",
                subtitle: "Use Indian names, currency, and examples",
                iconName: 'public',
                value: culturalContext,
                onChanged: onCulturalContextChanged,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOptionTile({
    required String title,
    required String subtitle,
    required String iconName,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Row(
      children: [
        Container(
          width: 12.w,
          height: 12.w,
          decoration: BoxDecoration(
            color: value
                ? AppTheme.primaryBlue.withValues(alpha: 0.1)
                : AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: CustomIconWidget(
              iconName: iconName,
              color: value ? AppTheme.primaryBlue : AppTheme.onSurfaceSecondary,
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
                title,
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.onSurfacePrimary,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                subtitle,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.onSurfaceSecondary,
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
