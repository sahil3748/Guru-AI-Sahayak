import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuickActionsWidget extends StatelessWidget {
  final VoidCallback onChatWithGuruAI;
  final VoidCallback onPracticeQuiz;
  final VoidCallback onSubmitAssignment;

  const QuickActionsWidget({
    super.key,
    required this.onChatWithGuruAI,
    required this.onPracticeQuiz,
    required this.onSubmitAssignment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.onSurfacePrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  title: 'Chat with GuruAI',
                  subtitle: 'Get help instantly',
                  icon: 'chat',
                  color: AppTheme.primaryBlue,
                  onTap: onChatWithGuruAI,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildActionButton(
                  title: 'Practice Quiz',
                  subtitle: 'Test your knowledge',
                  icon: 'quiz',
                  color: AppTheme.successGreen,
                  onTap: onPracticeQuiz,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          SizedBox(
            width: double.infinity,
            child: _buildActionButton(
              title: 'Submit Assignment',
              subtitle: 'Upload your completed work',
              icon: 'upload_file',
              color: AppTheme.alertRed,
              onTap: onSubmitAssignment,
              isWide: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String title,
    required String subtitle,
    required String icon,
    required Color color,
    required VoidCallback onTap,
    bool isWide = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: isWide ? double.infinity : null,
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: isWide
            ? Row(
                children: [
                  Container(
                    width: 12.w,
                    height: 12.w,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: CustomIconWidget(
                        iconName: icon,
                        color: color,
                        size: 24,
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
                          style: AppTheme.lightTheme.textTheme.titleSmall
                              ?.copyWith(
                            color: color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          subtitle,
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.onSurfaceSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  CustomIconWidget(
                    iconName: 'arrow_forward_ios',
                    color: color,
                    size: 16,
                  ),
                ],
              )
            : Column(
                children: [
                  Container(
                    width: 12.w,
                    height: 12.w,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: CustomIconWidget(
                        iconName: icon,
                        color: color,
                        size: 24,
                      ),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    title,
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    subtitle,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.onSurfaceSecondary,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
      ),
    );
  }
}
