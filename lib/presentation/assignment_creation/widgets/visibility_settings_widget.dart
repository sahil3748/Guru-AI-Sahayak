import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class VisibilitySettingsWidget extends StatefulWidget {
  final bool isVisible;
  final bool allowLateSubmission;
  final DateTime? publishDate;
  final Function(bool) onVisibilityChanged;
  final Function(bool) onLateSubmissionChanged;
  final VoidCallback onPublishDateTap;

  const VisibilitySettingsWidget({
    super.key,
    required this.isVisible,
    required this.allowLateSubmission,
    required this.publishDate,
    required this.onVisibilityChanged,
    required this.onLateSubmissionChanged,
    required this.onPublishDateTap,
  });

  @override
  State<VisibilitySettingsWidget> createState() =>
      _VisibilitySettingsWidgetState();
}

class _VisibilitySettingsWidgetState extends State<VisibilitySettingsWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Visibility Settings',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),

        // Immediate visibility toggle
        Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: AppTheme.surfaceWhite,
            border: Border.all(color: AppTheme.outlineLight),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Make Visible to Students',
                      style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      'Students can see and access this assignment immediately',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.onSurfaceSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: widget.isVisible,
                onChanged: widget.onVisibilityChanged,
              ),
            ],
          ),
        ),
        SizedBox(height: 2.h),

        // Publish date setting (only show if not immediately visible)
        !widget.isVisible
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Publish Date',
                    style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  InkWell(
                    onTap: widget.onPublishDateTap,
                    child: Container(
                      width: double.infinity,
                      padding:
                          EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppTheme.outlineLight),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'schedule',
                            color: AppTheme.primaryBlue,
                            size: 20,
                          ),
                          SizedBox(width: 3.w),
                          Text(
                            widget.publishDate != null
                                ? '${widget.publishDate!.day}/${widget.publishDate!.month}/${widget.publishDate!.year} at ${widget.publishDate!.hour}:${widget.publishDate!.minute.toString().padLeft(2, '0')}'
                                : 'Select publish date and time',
                            style: AppTheme.lightTheme.textTheme.bodyLarge
                                ?.copyWith(
                              color: widget.publishDate != null
                                  ? AppTheme.onSurfacePrimary
                                  : AppTheme.onSurfaceDisabled,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 2.h),
                ],
              )
            : const SizedBox.shrink(),

        // Late submission toggle
        Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: AppTheme.surfaceWhite,
            border: Border.all(color: AppTheme.outlineLight),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Allow Late Submissions',
                      style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      'Students can submit after the due date with penalty',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.onSurfaceSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: widget.allowLateSubmission,
                onChanged: widget.onLateSubmissionChanged,
              ),
            ],
          ),
        ),
        SizedBox(height: 2.h),

        // Assignment preview card
        Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: AppTheme.primaryBlue.withValues(alpha: 0.05),
            border:
                Border.all(color: AppTheme.primaryBlue.withValues(alpha: 0.2)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              CustomIconWidget(
                iconName: 'info',
                color: AppTheme.primaryBlue,
                size: 20,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Assignment Status',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppTheme.primaryBlue,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      widget.isVisible
                          ? 'This assignment will be visible to students immediately after creation'
                          : 'This assignment will be saved as draft and published later',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.primaryBlue,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
