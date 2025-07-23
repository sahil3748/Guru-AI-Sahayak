import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ClassHeaderWidget extends StatelessWidget {
  final Map<String, dynamic> classData;
  final VoidCallback? onShareCode;
  final VoidCallback? onBack;

  const ClassHeaderWidget({
    Key? key,
    required this.classData,
    this.onShareCode,
    this.onBack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String className = classData['name'] as String;
    final String classCode = classData['code'] as String;
    final int memberCount = classData['memberCount'] as int;
    final String? subject = classData['subject'] as String?;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryBlue,
            AppTheme.primaryBlue.withValues(alpha: 0.8),
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: onBack,
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: EdgeInsets.all(2.w),
                      child: CustomIconWidget(
                        iconName: 'arrow_back',
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      className,
                      style:
                          AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  InkWell(
                    onTap: onShareCode,
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: CustomIconWidget(
                        iconName: 'share',
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              if (subject != null)
                Container(
                  margin: EdgeInsets.only(bottom: 1.h),
                  child: Text(
                    subject,
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              Row(
                children: [
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomIconWidget(
                          iconName: 'key',
                          color: Colors.white,
                          size: 16,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Code: $classCode',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomIconWidget(
                          iconName: 'group',
                          color: Colors.white,
                          size: 16,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          '$memberCount members',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
