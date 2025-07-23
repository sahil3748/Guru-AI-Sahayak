import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AssignmentFormWidget extends StatefulWidget {
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final TextEditingController instructionsController;
  final DateTime? selectedDueDate;
  final String selectedPriority;
  final int pointValue;
  final VoidCallback onDueDateTap;
  final Function(String) onPriorityChanged;
  final Function(int) onPointValueChanged;

  const AssignmentFormWidget({
    super.key,
    required this.titleController,
    required this.descriptionController,
    required this.instructionsController,
    required this.selectedDueDate,
    required this.selectedPriority,
    required this.pointValue,
    required this.onDueDateTap,
    required this.onPriorityChanged,
    required this.onPointValueChanged,
  });

  @override
  State<AssignmentFormWidget> createState() => _AssignmentFormWidgetState();
}

class _AssignmentFormWidgetState extends State<AssignmentFormWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title Field
        Text(
          'Assignment Title',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: widget.titleController,
          decoration: InputDecoration(
            hintText: 'Enter assignment title',
            counterText: '${widget.titleController.text.length}/100',
          ),
          maxLength: 100,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Assignment title is required';
            }
            return null;
          },
        ),
        SizedBox(height: 3.h),

        // Description Field
        Text(
          'Description',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: widget.descriptionController,
          decoration: const InputDecoration(
            hintText: 'Describe the assignment objectives and requirements',
          ),
          maxLines: 4,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Assignment description is required';
            }
            return null;
          },
        ),
        SizedBox(height: 3.h),

        // Due Date Field
        Text(
          'Due Date',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        InkWell(
          onTap: widget.onDueDateTap,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            decoration: BoxDecoration(
              border: Border.all(color: AppTheme.outlineLight),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'calendar_today',
                  color: AppTheme.primaryBlue,
                  size: 20,
                ),
                SizedBox(width: 3.w),
                Text(
                  widget.selectedDueDate != null
                      ? '${widget.selectedDueDate!.day}/${widget.selectedDueDate!.month}/${widget.selectedDueDate!.year}'
                      : 'Select due date',
                  style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                    color: widget.selectedDueDate != null
                        ? AppTheme.onSurfacePrimary
                        : AppTheme.onSurfaceDisabled,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 3.h),

        // Priority Level
        Text(
          'Priority Level',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Row(
          children: [
            Expanded(
              child: _buildPriorityButton('High', AppTheme.alertRed),
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: _buildPriorityButton('Medium', AppTheme.warningYellow),
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: _buildPriorityButton('Low', AppTheme.successGreen),
            ),
          ],
        ),
        SizedBox(height: 3.h),

        // Point Value
        Text(
          'Point Value',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                initialValue: widget.pointValue.toString(),
                decoration: const InputDecoration(
                  hintText: 'Enter points',
                  suffixText: 'pts',
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  final points = int.tryParse(value) ?? 0;
                  widget.onPointValueChanged(points);
                },
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Point value is required';
                  }
                  final points = int.tryParse(value);
                  if (points == null || points <= 0) {
                    return 'Enter a valid point value';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 3.h),

        // Instructions Field
        Text(
          'Instructions for Students',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: widget.instructionsController,
          decoration: const InputDecoration(
            hintText: 'Provide detailed instructions and submission guidelines',
          ),
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildPriorityButton(String priority, Color color) {
    final isSelected = widget.selectedPriority == priority;
    return InkWell(
      onTap: () => widget.onPriorityChanged(priority),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 1.5.h),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.1) : Colors.transparent,
          border: Border.all(
            color: isSelected ? color : AppTheme.outlineLight,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 2.w),
            Text(
              priority,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? color : AppTheme.onSurfacePrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
