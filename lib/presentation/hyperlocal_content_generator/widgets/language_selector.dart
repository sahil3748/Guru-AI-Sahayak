import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LanguageSelector extends StatelessWidget {
  final String selectedLanguage;
  final Function(String) onLanguageSelected;

  const LanguageSelector({
    super.key,
    required this.selectedLanguage,
    required this.onLanguageSelected,
  });

  @override
  Widget build(BuildContext context) {
    final languages = [
      {'name': 'Hindi', 'code': 'hi', 'icon': '🇮🇳'},
      {'name': 'English', 'code': 'en', 'icon': '🇬🇧'},
      {'name': 'Bengali', 'code': 'bn', 'icon': '🇧🇩'},
      {'name': 'Tamil', 'code': 'ta', 'icon': '🏴'},
      {'name': 'Telugu', 'code': 'te', 'icon': '🏴'},
      {'name': 'Marathi', 'code': 'mr', 'icon': '🏴'},
      {'name': 'Gujarati', 'code': 'gu', 'icon': '🏴'},
      {'name': 'Punjabi', 'code': 'pa', 'icon': '🏴'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Select Language",
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.onSurfacePrimary,
          ),
        ),
        SizedBox(height: 2.h),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 3.w,
            mainAxisSpacing: 2.h,
            childAspectRatio: 2.5,
          ),
          itemCount: languages.length,
          itemBuilder: (context, index) {
            final language = languages[index];
            final isSelected = selectedLanguage == language['name'];

            return GestureDetector(
              onTap: () => onLanguageSelected(language['name'] as String),
              child: Container(
                padding: EdgeInsets.all(3.w),
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
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.shadowLight,
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Text(
                      language['icon'] as String,
                      style: TextStyle(fontSize: 6.w),
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        language['name'] as String,
                        style: AppTheme.lightTheme.textTheme.bodyMedium
                            ?.copyWith(
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                              color: isSelected
                                  ? AppTheme.primaryBlue
                                  : AppTheme.onSurfacePrimary,
                            ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isSelected)
                      CustomIconWidget(
                        iconName: 'check_circle',
                        color: AppTheme.primaryBlue,
                        size: 4.w,
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
