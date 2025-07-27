import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../core/app_export.dart';

class TitleInputField extends StatelessWidget {
  final TextEditingController controller;
  final String topic;
  final String subject;
  final Function(String) onTitleChanged;

  const TitleInputField({
    Key? key,
    required this.controller,
    required this.topic,
    required this.subject,
    required this.onTitleChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Worksheet Title",
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.onSurfacePrimary,
          ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: "Enter worksheet title",
            hintStyle: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.onSurfaceSecondary.withOpacity(0.5),
            ),
            prefixIcon: const CustomIconWidget(
              iconName: 'title',
              color: AppTheme.primaryBlue,
            ),
            suffixIcon: IconButton(
              icon: const CustomIconWidget(
                iconName: 'refresh',
                color: AppTheme.onSurfaceSecondary,
              ),
              onPressed: () {
                // Generate a default title
                final defaultTitle = "$subject $topic Practice Worksheet";
                controller.text = defaultTitle;
                onTitleChanged(defaultTitle);
              },
            ),
            filled: true,
            fillColor: AppTheme.surfaceWhite,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: AppTheme.onSurfaceSecondary.withOpacity(0.3),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: AppTheme.onSurfaceSecondary.withOpacity(0.3),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: AppTheme.primaryBlue,
                width: 2,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
              vertical: 2.h,
              horizontal: 4.w,
            ),
          ),
          style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
            color: AppTheme.onSurfacePrimary,
          ),
          onChanged: onTitleChanged,
        ),
        SizedBox(height: 1.5.h),
        Text(
          "Provide a meaningful title for your worksheet",
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.onSurfaceSecondary,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}
