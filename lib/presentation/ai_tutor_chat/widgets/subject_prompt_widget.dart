import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SubjectPromptWidget extends StatelessWidget {
  final List<Map<String, dynamic>> subjects;
  final Function(String) onSubjectSelected;

  const SubjectPromptWidget({
    Key? key,
    required this.subjects,
    required this.onSubjectSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Choose a subject to get started:',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.onSurfacePrimary,
              fontWeight: FontWeight.w600,
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
            itemCount: subjects.length,
            itemBuilder: (context, index) {
              final subject = subjects[index];
              return GestureDetector(
                onTap: () => onSubjectSelected(subject['prompt'] as String),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(subject['color'] as int),
                    borderRadius: BorderRadius.circular(3.w),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.shadowLight,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: subject['icon'] as String,
                        color: AppTheme.surfaceWhite,
                        size: 6.w,
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        subject['name'] as String,
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.surfaceWhite,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
