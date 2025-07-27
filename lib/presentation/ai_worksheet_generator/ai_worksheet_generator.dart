import 'dart:convert';
// import 'dart:html' as html if (dart.library.html) 'dart:html';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
// import 'package:open_file/open_file.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/app_export.dart';
import '../../models/worksheet_response.dart';
import '../../services/worksheet_service.dart';
import './widgets/additional_options_section.dart';
import './widgets/difficulty_slider.dart';
import './widgets/generation_progress_dialog.dart';
import './widgets/grade_level_picker.dart';
import './widgets/progress_indicator_widget.dart';
import './widgets/question_count_selector.dart';
import './widgets/subject_selection_card.dart';
import './widgets/title_input_field.dart';
import './widgets/topic_input_field.dart';
import './widgets/worksheet_type_card.dart';
import 'package:open_file/open_file.dart';

class AiWorksheetGenerator extends StatefulWidget {
  const AiWorksheetGenerator({super.key});

  @override
  State<AiWorksheetGenerator> createState() => _AiWorksheetGeneratorState();
}

class _AiWorksheetGeneratorState extends State<AiWorksheetGenerator> {
  final PageController _pageController = PageController();
  final TextEditingController _topicController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final WorksheetService _worksheetService = WorksheetService();

  int _currentStep = 1;
  final int _totalSteps = 6;

  bool _isLoading = false;
  bool _isWorksheetGenerated = false;
  WorksheetResponse? _worksheetResponse;
  String? _errorMessage;

  // Form data
  String _selectedSubject = '';
  int _selectedGrade = 5;
  String _selectedTopic = '';
  String _selectedWorksheetType = '';
  double _difficulty = 0.5; // Not used in API but kept for UI
  int _questionCount = 10;
  bool _includeAnswerKey = true;
  bool _includeHints = false; // Not used in API but kept for UI
  bool _culturalContext = true; // Not used in API but kept for UI

  // Mapping for worksheet types
  final Map<String, String> _worksheetTypeMapping = {
    'Multiple Choice': 'multiple_choice',
    'Short Answers': 'short_answers',
    'Fill in the Blanks': 'fill_in_blanks',
  };

  // Mock worksheet data - kept for reference
  final List<Map<String, dynamic>> _mockWorksheetData = [
    {
      "id": 1,
      "question": "What is 15 + 27?",
      "type": "multiple_choice",
      "options": ["42", "41", "43", "40"],
      "correct_answer": "42",
      "hint":
          "Add the ones place first: 5 + 7 = 12, then add the tens place: 1 + 2 + 1 = 4",
      "explanation": "15 + 27 = (10 + 5) + (20 + 7) = 30 + 12 = 42",
    },
    {
      "id": 2,
      "question":
          "Ravi has ₹50. He buys a book for ₹23. How much money does he have left?",
      "type": "short_answer",
      "correct_answer": "₹27",
      "hint": "Subtract the cost of the book from the total money",
      "explanation": "₹50 - ₹23 = ₹27",
    },
    {
      "id": 3,
      "question": "Fill in the blank: 8 × 6 = ____",
      "type": "fill_blank",
      "correct_answer": "48",
      "hint": "Think of 8 groups of 6 or 6 groups of 8",
      "explanation": "8 × 6 = 8 + 8 + 8 + 8 + 8 + 8 = 48",
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    _topicController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < _totalSteps) {
      setState(() {
        _currentStep++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousStep() {
    if (_currentStep > 1) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  bool _canProceedToNextStep() {
    switch (_currentStep) {
      case 1:
        return _selectedSubject.isNotEmpty;
      case 2:
        return true; // Grade is always selected
      case 3:
        return _selectedTopic.isNotEmpty;
      case 4:
        return _selectedWorksheetType.isNotEmpty;
      case 5:
        return true; // Difficulty and count always have values
      case 6:
        return true; // Additional options are optional
      default:
        return false;
    }
  }

  Future<void> _generateWorksheet() async {
    // Validate topic title if not provided
    if (_titleController.text.isEmpty) {
      _titleController.text = '$_selectedTopic Worksheet';
    }

    // Get the worksheet type in API format
    String worksheetType = _selectedWorksheetType.toLowerCase().replaceAll(
      ' ',
      '_',
    );
    if (_worksheetTypeMapping.containsKey(_selectedWorksheetType)) {
      worksheetType = _worksheetTypeMapping[_selectedWorksheetType]!;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => GenerationProgressDialog(
        topic: _selectedTopic,
        questionCount: _questionCount,
        onComplete: () async {
          // The dialog will handle its own state
          try {
            // Make the actual API call
            final response = await _worksheetService.generateWorksheet(
              subject: _selectedSubject,
              grade: _selectedGrade.toString(),
              topic: _selectedTopic,
              worksheetType: worksheetType,
              numQuestions: _questionCount,
              title: _titleController.text,
              includeAnswers: _includeAnswerKey,
            );

            // Process the response
            if (response.containsKey('success') &&
                response['success'] == false) {
              setState(() {
                _errorMessage =
                    response['message'] ?? 'Failed to generate worksheet';
                _isLoading = false;
                _isWorksheetGenerated = false;
              });
              Navigator.of(context).pop(); // Close the dialog
              _showErrorMessage(_errorMessage!);
              return;
            }

            // Create worksheet response object
            _worksheetResponse = WorksheetResponse.fromJson(response);

            setState(() {
              _isLoading = false;
              _isWorksheetGenerated = true;
            });

            Navigator.of(context).pop(); // Close the dialog
            _showWorksheetPreview();
          } catch (e) {
            setState(() {
              _errorMessage = 'Error: $e';
              _isLoading = false;
              _isWorksheetGenerated = false;
            });
            Navigator.of(context).pop(); // Close the dialog
            _showErrorMessage(
              'An unexpected error occurred. Please try again.',
            );
          }
        },
      ),
    );
  }

  void _showWorksheetPreview() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildWorksheetPreviewSheet(),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppTheme.alertRed),
    );
  }

  Future<void> _downloadWorksheet() async {
    if (_worksheetResponse == null) {
      _showErrorMessage('No worksheet available to download');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final pdfUrl = _worksheetResponse!.getFullPdfUrl();
      print("Pdf Url : $pdfUrl");

      // Show downloading message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Downloading worksheet..."),
          backgroundColor: AppTheme.primaryBlue,
          duration: Duration(seconds: 2),
        ),
      );

      // First download the file using dio
      final response = await Dio().get(
        pdfUrl,
        options: Options(responseType: ResponseType.bytes),
      );

      // Get the temporary directory path
      final directory = await getTemporaryDirectory();
      final filePath = '${directory.path}/worksheet.pdf';

      // Write the file
      File(filePath).writeAsBytesSync(response.data);

      // Open the file
      final result = await OpenFile.open(filePath);

      if (result.type != ResultType.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Opening worksheet PDF"),
            backgroundColor: AppTheme.successGreen,
          ),
        );
      } else {
        throw 'Could not launch $pdfUrl';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error opening PDF: $e"),
          backgroundColor: AppTheme.alertRed,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Helper method to convert difficulty slider to readable label - kept for UI display
  String _getDifficultyLabel(double value) {
    if (value <= 0.33) return "Easy";
    if (value <= 0.66) return "Medium";
    return "Hard";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundOffWhite,
      appBar: AppBar(
        title: const Text("Generate Worksheet"),
        leading: IconButton(
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.onSurfacePrimary,
            size: 6.w,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (_currentStep > 1)
            TextButton(
              onPressed: _previousStep,
              child: Text(
                "Back",
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.primaryBlue,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          ProgressIndicatorWidget(
            currentStep: _currentStep,
            totalSteps: _totalSteps,
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildSubjectSelectionStep(),
                _buildGradeLevelStep(),
                _buildTopicInputStep(),
                _buildWorksheetTypeStep(),
                _buildDifficultyStep(),
                _buildAdditionalOptionsStep(),
              ],
            ),
          ),
          _buildBottomNavigationBar(),
        ],
      ),
    );
  }

  Widget _buildSubjectSelectionStep() {
    final subjects = [
      {'name': 'Math', 'icon': 'calculate', 'color': AppTheme.primaryBlue},
      {'name': 'Science', 'icon': 'science', 'color': AppTheme.successGreen},
      {'name': 'English', 'icon': 'menu_book', 'color': AppTheme.alertRed},
      {'name': 'Hindi', 'icon': 'translate', 'color': AppTheme.warningYellow},
    ];

    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Choose Subject",
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.onSurfacePrimary,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            "Select the subject for your worksheet",
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.onSurfaceSecondary,
            ),
          ),
          SizedBox(height: 4.h),
          Wrap(
            children: subjects.map((subject) {
              return SubjectSelectionCard(
                subject: subject['name'] as String,
                iconName: subject['icon'] as String,
                backgroundColor: subject['color'] as Color,
                isSelected: _selectedSubject == subject['name'],
                onTap: () {
                  setState(() {
                    _selectedSubject = subject['name'] as String;
                  });
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildGradeLevelStep() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Select Grade Level",
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.onSurfacePrimary,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            "Choose the appropriate grade level for your students",
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.onSurfaceSecondary,
            ),
          ),
          SizedBox(height: 4.h),
          GradeLevelPicker(
            selectedGrade: _selectedGrade,
            onGradeSelected: (grade) {
              setState(() {
                _selectedGrade = grade;
                // Adjust question count based on grade
                if (grade <= 4) {
                  _questionCount = 8;
                } else if (grade <= 6) {
                  _questionCount = 12;
                } else {
                  _questionCount = 15;
                }
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTopicInputStep() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Enter Topic",
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.onSurfacePrimary,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            "Specify the topic you want to create questions about",
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.onSurfaceSecondary,
            ),
          ),
          SizedBox(height: 4.h),
          TopicInputField(
            selectedSubject: _selectedSubject,
            selectedGrade: _selectedGrade,
            controller: _topicController,
            onTopicSelected: (topic) {
              setState(() {
                _selectedTopic = topic;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWorksheetTypeStep() {
    final worksheetTypes = [
      {
        'type': 'Multiple Choice',
        'description': 'Questions with 4 answer options',
        'example': 'What is 2 + 2? A) 3 B) 4 C) 5 D) 6',
        'icon': 'radio_button_checked',
      },
      {
        'type': 'Fill in Blanks',
        'description': 'Complete the missing information',
        'example': 'The capital of India is ____.',
        'icon': 'edit',
      },
      {
        'type': 'Short Answer',
        'description': 'Brief written responses',
        'example': 'Explain photosynthesis in 2-3 sentences.',
        'icon': 'short_text',
      },
      {
        'type': 'Mixed Format',
        'description': 'Combination of different question types',
        'example': 'Mix of MCQ, fill-in-blanks, and short answers',
        'icon': 'shuffle',
      },
    ];

    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Worksheet Type",
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.onSurfacePrimary,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            "Choose the format for your worksheet questions",
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.onSurfaceSecondary,
            ),
          ),
          SizedBox(height: 4.h),
          Column(
            children: worksheetTypes.map((type) {
              return WorksheetTypeCard(
                type: type['type'] as String,
                description: type['description'] as String,
                example: type['example'] as String,
                iconName: type['icon'] as String,
                isSelected: _selectedWorksheetType == type['type'],
                onTap: () {
                  setState(() {
                    _selectedWorksheetType = type['type'] as String;
                  });
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDifficultyStep() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Customize Difficulty",
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.onSurfacePrimary,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            "Set the difficulty level and number of questions",
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.onSurfaceSecondary,
            ),
          ),
          SizedBox(height: 4.h),
          DifficultySlider(
            difficulty: _difficulty,
            // difficultyLabel: _getDifficultyLabel(_difficulty),
            onDifficultyChanged: (value) {
              setState(() {
                _difficulty = value;
              });
            },
          ),
          SizedBox(height: 4.h),
          QuestionCountSelector(
            questionCount: _questionCount,
            selectedGrade: _selectedGrade,
            onCountChanged: (count) {
              setState(() {
                _questionCount = count;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalOptionsStep() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Additional Options",
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.onSurfacePrimary,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            "Customize your worksheet with additional features",
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.onSurfaceSecondary,
            ),
          ),
          SizedBox(height: 4.h),
          // Add title input field
          TitleInputField(
            controller: _titleController,
            topic: _selectedTopic,
            subject: _selectedSubject,
            onTitleChanged: (title) {
              // No need to do anything here as the controller already updates
            },
          ),
          SizedBox(height: 3.h),
          AdditionalOptionsSection(
            includeAnswerKey: _includeAnswerKey,
            includeHints: _includeHints,
            culturalContext: _culturalContext,
            onAnswerKeyChanged: (value) {
              setState(() {
                _includeAnswerKey = value;
              });
            },
            onHintsChanged: (value) {
              setState(() {
                _includeHints = value;
              });
            },
            onCulturalContextChanged: (value) {
              setState(() {
                _culturalContext = value;
              });
            },
          ),
          SizedBox(height: 4.h),
          _buildPreviewButton(),
        ],
      ),
    );
  }

  Widget _buildPreviewButton() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.lightTheme.colorScheme.outline),
      ),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: 'preview',
            color: AppTheme.primaryBlue,
            size: 8.w,
          ),
          SizedBox(height: 2.h),
          Text(
            "Preview Sample Questions",
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.onSurfacePrimary,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            "See a few sample questions before generating the full worksheet",
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.onSurfaceSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 2.h),
          OutlinedButton(
            onPressed: () {
              _showSampleQuestions();
            },
            child: const Text("Show Preview"),
          ),
        ],
      ),
    );
  }

  void _showSampleQuestions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Sample Questions"),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Here are sample questions for $_selectedTopic:",
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
              SizedBox(height: 2.h),
              ...(_mockWorksheetData.take(2).map((question) {
                return Container(
                  margin: EdgeInsets.only(bottom: 2.h),
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color:
                        AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    question['question'] as String,
                    style: AppTheme.lightTheme.textTheme.bodyMedium,
                  ),
                );
              }).toList()),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          if (_currentStep < _totalSteps) ...[
            Expanded(
              child: ElevatedButton(
                onPressed: _canProceedToNextStep() ? _nextStep : null,
                child: Text(
                  _currentStep == _totalSteps - 1 ? "Review" : "Next",
                ),
              ),
            ),
          ] else ...[
            Expanded(
              child: ElevatedButton(
                onPressed: _generateWorksheet,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.successGreen,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'auto_awesome',
                      color: AppTheme.surfaceWhite,
                      size: 5.w,
                    ),
                    SizedBox(width: 2.w),
                    const Text("Generate Worksheet"),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildWorksheetPreviewSheet() {
    return Container(
      height: 90.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.outline.withValues(
                    alpha: 0.3,
                  ),
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Worksheet Generated!",
                        style: AppTheme.lightTheme.textTheme.titleLarge
                            ?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppTheme.onSurfacePrimary,
                            ),
                      ),
                      Text(
                        "${_worksheetResponse?.subject ?? _selectedSubject} • Grade ${_worksheetResponse?.grade ?? _selectedGrade} • ${_worksheetResponse?.topic ?? _selectedTopic}",
                        style: AppTheme.lightTheme.textTheme.bodyMedium
                            ?.copyWith(color: AppTheme.onSurfaceSecondary),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.onSurfaceSecondary,
                    size: 6.w,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_worksheetResponse != null) ...[
                    // PDF information box
                    Container(
                      margin: EdgeInsets.only(bottom: 3.h),
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CustomIconWidget(
                                iconName: 'picture_as_pdf',
                                color: AppTheme.primaryBlue,
                                size: 8.w,
                              ),
                              SizedBox(width: 3.w),
                              Expanded(
                                child: Text(
                                  _worksheetResponse!.title,
                                  style: AppTheme
                                      .lightTheme
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            "Your worksheet has been generated and is ready to view. Click the Open PDF button below to view or download your worksheet.",
                            style: AppTheme.lightTheme.textTheme.bodyMedium,
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            "Questions: ${_worksheetResponse!.questionCount}",
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ],
                  Text(
                    "Preview",
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.onSurfacePrimary,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  if (_worksheetResponse == null) ...[
                    // Mock data preview
                    ...(_mockWorksheetData.take(_questionCount).map((question) {
                      final index = _mockWorksheetData.indexOf(question);
                      return Container(
                        margin: EdgeInsets.only(bottom: 3.h),
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          color: AppTheme
                              .lightTheme
                              .colorScheme
                              .surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Question ${index + 1}",
                              style: AppTheme.lightTheme.textTheme.labelMedium
                                  ?.copyWith(
                                    color: AppTheme.primaryBlue,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              question['question'] as String,
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.w500),
                            ),
                            if (question['type'] == 'multiple_choice') ...[
                              SizedBox(height: 1.h),
                              ...(question['options'] as List).asMap().entries.map((
                                entry,
                              ) {
                                return Padding(
                                  padding: EdgeInsets.only(top: 0.5.h),
                                  child: Text(
                                    "${String.fromCharCode(65 + entry.key)}. ${entry.value}",
                                    style:
                                        AppTheme.lightTheme.textTheme.bodySmall,
                                  ),
                                );
                              }).toList(),
                            ],
                          ],
                        ),
                      );
                    }).toList()),
                  ] else ...[
                    // Real data - preview not available
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 2.h),
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.amber),
                      ),
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'info',
                            color: Colors.amber[800]!,
                            size: 6.w,
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Text(
                              "PDF generated. Please click 'Open PDF' to view the full worksheet content.",
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(color: Colors.amber[800]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.outline.withValues(
                    alpha: 0.3,
                  ),
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: CustomIconWidget(
                      iconName: 'close',
                      color: AppTheme.onSurfaceSecondary,
                      size: 5.w,
                    ),
                    label: const Text("Close"),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _downloadWorksheet,
                    icon: _isLoading
                        ? SizedBox(
                            width: 5.w,
                            height: 5.w,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppTheme.surfaceWhite,
                              ),
                              strokeWidth: 2,
                            ),
                          )
                        : CustomIconWidget(
                            iconName: _worksheetResponse != null
                                ? 'open_in_browser'
                                : 'download',
                            color: AppTheme.surfaceWhite,
                            size: 5.w,
                          ),
                    label: Text(
                      _worksheetResponse != null ? "Open PDF" : "Download",
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
