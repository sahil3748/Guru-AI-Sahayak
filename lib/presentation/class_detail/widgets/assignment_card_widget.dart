import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AssignmentCardWidget extends StatelessWidget {
  final Map<String, dynamic> assignment;
  final bool isTeacher;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onSubmit;
  final VoidCallback? onViewFeedback;

  const AssignmentCardWidget({
    Key? key,
    required this.assignment,
    required this.isTeacher,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.onSubmit,
    this.onViewFeedback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateTime dueDate = assignment['dueDate'] as DateTime;
    final String status = assignment['status'] as String;
    final bool isOverdue =
        dueDate.isBefore(DateTime.now()) && status != 'submitted';
    final String? grade = assignment['grade'] as String?;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        assignment['title'] as String,
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    _buildStatusChip(status, isOverdue),
                  ],
                ),
                SizedBox(height: 1.h),
                Text(
                  assignment['description'] as String,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.onSurfaceSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'schedule',
                      color: isOverdue
                          ? AppTheme.alertRed
                          : AppTheme.onSurfaceSecondary,
                      size: 16,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Due: ${_formatDate(dueDate)}',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: isOverdue
                            ? AppTheme.alertRed
                            : AppTheme.onSurfaceSecondary,
                        fontWeight:
                            isOverdue ? FontWeight.w500 : FontWeight.w400,
                      ),
                    ),
                    Spacer(),
                    if (grade != null)
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: AppTheme.successGreen.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Grade: $grade',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.successGreen,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                ),
                if (assignment['hasAttachment'] == true)
                  Container(
                    margin: EdgeInsets.only(top: 1.h),
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'attach_file',
                          color: AppTheme.primaryBlue,
                          size: 16,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Has attachments',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.primaryBlue,
                          ),
                        ),
                      ],
                    ),
                  ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    if (isTeacher) ...[
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: onEdit,
                          icon: CustomIconWidget(
                            iconName: 'edit',
                            color: AppTheme.primaryBlue,
                            size: 16,
                          ),
                          label: Text('Edit'),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 1.h),
                          ),
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: onDelete,
                          icon: CustomIconWidget(
                            iconName: 'delete',
                            color: AppTheme.alertRed,
                            size: 16,
                          ),
                          label: Text('Delete'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppTheme.alertRed,
                            side: BorderSide(color: AppTheme.alertRed),
                            padding: EdgeInsets.symmetric(vertical: 1.h),
                          ),
                        ),
                      ),
                    ] else ...[
                      if (status == 'pending')
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: onSubmit,
                            icon: CustomIconWidget(
                              iconName: 'upload',
                              color: Colors.white,
                              size: 16,
                            ),
                            label: Text('Submit'),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 1.h),
                            ),
                          ),
                        ),
                      if (status == 'submitted' && grade != null)
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: onViewFeedback,
                            icon: CustomIconWidget(
                              iconName: 'feedback',
                              color: AppTheme.primaryBlue,
                              size: 16,
                            ),
                            label: Text('View Feedback'),
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 1.h),
                            ),
                          ),
                        ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status, bool isOverdue) {
    Color backgroundColor;
    Color textColor;
    String displayText;
    String iconName;

    switch (status) {
      case 'submitted':
        backgroundColor = AppTheme.successGreen.withValues(alpha: 0.1);
        textColor = AppTheme.successGreen;
        displayText = 'Submitted';
        iconName = 'check_circle';
        break;
      case 'graded':
        backgroundColor = AppTheme.primaryBlue.withValues(alpha: 0.1);
        textColor = AppTheme.primaryBlue;
        displayText = 'Graded';
        iconName = 'grade';
        break;
      default:
        if (isOverdue) {
          backgroundColor = AppTheme.alertRed.withValues(alpha: 0.1);
          textColor = AppTheme.alertRed;
          displayText = 'Overdue';
          iconName = 'warning';
        } else {
          backgroundColor = AppTheme.warningYellow.withValues(alpha: 0.2);
          textColor = AppTheme.warningYellow;
          displayText = 'Pending';
          iconName = 'pending';
        }
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: iconName,
            color: textColor,
            size: 14,
          ),
          SizedBox(width: 1.w),
          Text(
            displayText,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Tomorrow';
    } else if (difference.inDays == -1) {
      return 'Yesterday';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
