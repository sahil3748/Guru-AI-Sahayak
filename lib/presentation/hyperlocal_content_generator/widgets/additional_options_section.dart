import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AdditionalOptionsSection extends StatelessWidget {
  final bool includeLocalExamples;
  final bool includeCulturalContext;
  final bool includeLocalDialect;
  final Function(bool) onLocalExamplesChanged;
  final Function(bool) onCulturalContextChanged;
  final Function(bool) onLocalDialectChanged;

  const AdditionalOptionsSection({
    super.key,
    required this.includeLocalExamples,
    required this.includeCulturalContext,
    required this.includeLocalDialect,
    required this.onLocalExamplesChanged,
    required this.onCulturalContextChanged,
    required this.onLocalDialectChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Localization Options",
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
            border: Border.all(color: AppTheme.lightTheme.colorScheme.outline),
          ),
          child: Column(
            children: [
              _buildOptionTile(
                title: "Include Local Examples",
                subtitle: "Use examples from your local area and culture",
                iconName: 'place',
                value: includeLocalExamples,
                onChanged: onLocalExamplesChanged,
              ),
              Divider(
                color: AppTheme.lightTheme.colorScheme.outline.withValues(
                  alpha: 0.3,
                ),
                height: 3.h,
              ),
              _buildOptionTile(
                title: "Cultural Context",
                subtitle: "Include local festivals, traditions, and customs",
                iconName: 'festival',
                value: includeCulturalContext,
                onChanged: onCulturalContextChanged,
              ),
              Divider(
                color: AppTheme.lightTheme.colorScheme.outline.withValues(
                  alpha: 0.3,
                ),
                height: 3.h,
              ),
              _buildOptionTile(
                title: "Local Dialect Terms",
                subtitle: "Include commonly used local words and phrases",
                iconName: 'translate',
                value: includeLocalDialect,
                onChanged: onLocalDialectChanged,
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
        Switch(value: value, onChanged: onChanged),
      ],
    );
  }
}
