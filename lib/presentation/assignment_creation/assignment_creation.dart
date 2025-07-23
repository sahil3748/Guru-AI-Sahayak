import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/assignment_form_widget.dart';
import './widgets/attachment_section_widget.dart';
import './widgets/visibility_settings_widget.dart';

class AssignmentCreation extends StatefulWidget {
  const AssignmentCreation({super.key});

  @override
  State<AssignmentCreation> createState() => _AssignmentCreationState();
}

class _AssignmentCreationState extends State<AssignmentCreation> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _instructionsController = TextEditingController();

  DateTime? _selectedDueDate;
  DateTime? _selectedPublishDate;
  String _selectedPriority = 'Medium';
  int _pointValue = 100;
  bool _isVisible = true;
  bool _allowLateSubmission = false;
  bool _isLoading = false;
  bool _isDraft = false;

  List<Map<String, dynamic>> _attachments = [];

  // Mock class data
  final Map<String, dynamic> _classData = {
    "id": "class_001",
    "name": "Mathematics Grade 8",
    "teacher": "Mrs. Priya Sharma",
    "students": 28,
    "subject": "Mathematics",
  };

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  Future<void> _selectDueDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: const TimeOfDay(hour: 23, minute: 59),
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDueDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  Future<void> _selectPublishDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate:
          _selectedDueDate ?? DateTime.now().add(const Duration(days: 365)),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          _selectedPublishDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  void _onAttachmentAdded(Map<String, dynamic> attachment) {
    setState(() {
      _attachments.add(attachment);
    });
  }

  void _onAttachmentRemoved(int index) {
    setState(() {
      _attachments.removeAt(index);
    });
  }

  Future<void> _saveAssignment({bool isDraft = false}) async {
    if (!isDraft && !_formKey.currentState!.validate()) {
      return;
    }

    if (!isDraft && _selectedDueDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a due date'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _isDraft = isDraft;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    final assignmentData = {
      "id": "assignment_${DateTime.now().millisecondsSinceEpoch}",
      "title": _titleController.text.trim(),
      "description": _descriptionController.text.trim(),
      "instructions": _instructionsController.text.trim(),
      "dueDate": _selectedDueDate?.toIso8601String(),
      "publishDate": _selectedPublishDate?.toIso8601String(),
      "priority": _selectedPriority,
      "pointValue": _pointValue,
      "isVisible": _isVisible,
      "allowLateSubmission": _allowLateSubmission,
      "attachments": _attachments,
      "classId": _classData["id"],
      "teacherId": "teacher_001",
      "status": isDraft ? "draft" : "published",
      "createdAt": DateTime.now().toIso8601String(),
    };

    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      _showSuccessDialog(isDraft);
    }
  }

  void _showSuccessDialog(bool isDraft) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppTheme.successGreen.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: 'check_circle',
                color: AppTheme.successGreen,
                size: 40,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              isDraft ? 'Draft Saved!' : 'Assignment Created!',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.successGreen,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              isDraft
                  ? 'Your assignment has been saved as draft. You can publish it later.'
                  : 'Your assignment has been successfully created and ${_isVisible ? 'is now visible to students' : 'will be published on the scheduled date'}.',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _resetForm();
                    },
                    child: const Text('Create Another'),
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushReplacementNamed(
                          context, '/teacher-dashboard');
                    },
                    child: const Text('View Dashboard'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _titleController.clear();
    _descriptionController.clear();
    _instructionsController.clear();
    setState(() {
      _selectedDueDate = null;
      _selectedPublishDate = null;
      _selectedPriority = 'Medium';
      _pointValue = 100;
      _isVisible = true;
      _allowLateSubmission = false;
      _attachments.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundOffWhite,
      appBar: AppBar(
        title: const Text('Create Assignment'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.onSurfacePrimary,
            size: 24,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : () => _saveAssignment(isDraft: true),
            child: Text(
              'Save Draft',
              style: TextStyle(
                color: _isLoading
                    ? AppTheme.onSurfaceDisabled
                    : AppTheme.primaryBlue,
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Class info card
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceWhite,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.outlineLight),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 12.w,
                          height: 12.w,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: CustomIconWidget(
                            iconName: 'school',
                            color: AppTheme.primaryBlue,
                            size: 24,
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _classData["name"],
                                style: AppTheme.lightTheme.textTheme.titleMedium
                                    ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '${_classData["students"]} students • ${_classData["teacher"]}',
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: AppTheme.onSurfaceSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 3.h),

                  // Assignment form
                  AssignmentFormWidget(
                    titleController: _titleController,
                    descriptionController: _descriptionController,
                    instructionsController: _instructionsController,
                    selectedDueDate: _selectedDueDate,
                    selectedPriority: _selectedPriority,
                    pointValue: _pointValue,
                    onDueDateTap: _selectDueDate,
                    onPriorityChanged: (priority) {
                      setState(() {
                        _selectedPriority = priority;
                      });
                    },
                    onPointValueChanged: (value) {
                      setState(() {
                        _pointValue = value;
                      });
                    },
                  ),
                  SizedBox(height: 3.h),

                  // Attachments section
                  AttachmentSectionWidget(
                    attachments: _attachments,
                    onAttachmentAdded: _onAttachmentAdded,
                    onAttachmentRemoved: _onAttachmentRemoved,
                  ),
                  SizedBox(height: 3.h),

                  // Visibility settings
                  VisibilitySettingsWidget(
                    isVisible: _isVisible,
                    allowLateSubmission: _allowLateSubmission,
                    publishDate: _selectedPublishDate,
                    onVisibilityChanged: (value) {
                      setState(() {
                        _isVisible = value;
                        if (value) {
                          _selectedPublishDate = null;
                        }
                      });
                    },
                    onLateSubmissionChanged: (value) {
                      setState(() {
                        _allowLateSubmission = value;
                      });
                    },
                    onPublishDateTap: _selectPublishDate,
                  ),
                  SizedBox(height: 10.h),
                ],
              ),
            ),
          ),

          // Loading overlay
          if (_isLoading)
            Container(
              color: Colors.black.withValues(alpha: 0.3),
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(6.w),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceWhite,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(),
                      SizedBox(height: 2.h),
                      Text(
                        _isDraft ? 'Saving Draft...' : 'Creating Assignment...',
                        style:
                            AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.surfaceWhite,
          border: Border(
            top: BorderSide(color: AppTheme.outlineLight),
          ),
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _isLoading ? null : () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : () => _saveAssignment(),
                  child: Text(
                      _isVisible ? 'Create & Publish' : 'Create Assignment'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
