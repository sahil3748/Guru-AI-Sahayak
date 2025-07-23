import 'dart:convert';
// import 'dart:html' as html if (dart.library.html) 'dart:html';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/additional_options_section.dart';
import './widgets/difficulty_slider.dart';
import './widgets/generation_progress_dialog.dart';
import './widgets/grade_level_picker.dart';
import './widgets/progress_indicator_widget.dart';
import './widgets/question_count_selector.dart';
import './widgets/subject_selection_card.dart';
import './widgets/topic_input_field.dart';
import './widgets/worksheet_type_card.dart';

class AiWorksheetGenerator extends StatefulWidget {
  const AiWorksheetGenerator({super.key});

  @override
  State<AiWorksheetGenerator> createState() => _AiWorksheetGeneratorState();
}

class _AiWorksheetGeneratorState extends State<AiWorksheetGenerator> {
  final PageController _pageController = PageController();
  final TextEditingController _topicController = TextEditingController();

  int _currentStep = 1;
  final int _totalSteps = 6;

  // Form data
  String _selectedSubject = '';
  int _selectedGrade = 5;
  String _selectedTopic = '';
  String _selectedWorksheetType = '';
  double _difficulty = 0.5;
  int _questionCount = 10;
  bool _includeAnswerKey = true;
  bool _includeHints = false;
  bool _culturalContext = true;

  // Mock worksheet data
  final List<Map<String, dynamic>> _mockWorksheetData = [
    {
      "id": 1,
      "question": "What is 15 + 27?",
      "type": "multiple_choice",
      "options": ["42", "41", "43", "40"],
      "correct_answer": "42",
      "hint":
          "Add the ones place first: 5 + 7 = 12, then add the tens place: 1 + 2 + 1 = 4",
      "explanation": "15 + 27 = (10 + 5) + (20 + 7) = 30 + 12 = 42"
    },
    {
      "id": 2,
      "question":
          "Ravi has ₹50. He buys a book for ₹23. How much money does he have left?",
      "type": "short_answer",
      "correct_answer": "₹27",
      "hint": "Subtract the cost of the book from the total money",
      "explanation": "₹50 - ₹23 = ₹27"
    },
    {
      "id": 3,
      "question": "Fill in the blank: 8 × 6 = ____",
      "type": "fill_blank",
      "correct_answer": "48",
      "hint": "Think of 8 groups of 6 or 6 groups of 8",
      "explanation": "8 × 6 = 8 + 8 + 8 + 8 + 8 + 8 = 48"
    }
  ];

  @override
  void dispose() {
    _pageController.dispose();
    _topicController.dispose();
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

  void _generateWorksheet() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => GenerationProgressDialog(
        topic: _selectedTopic,
        questionCount: _questionCount,
        onComplete: () {
          Navigator.of(context).pop();
          _showWorksheetPreview();
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

  Future<void> _downloadWorksheet() async {
    try {
      final worksheetContent = _generateWorksheetContent();
      final fileName = "${_selectedTopic.replaceAll(' ', '_')}_worksheet.txt";

      if (kIsWeb) {
        // final bytes = utf8.encode(worksheetContent);
        // final blob = html.Blob([bytes]);
        // final url = html.Url.createObjectUrlFromBlob(blob);
        // final anchor = html.AnchorElement(href: url)
        //   ..setAttribute("download", fileName)
        //   ..click();
        // html.Url.revokeObjectUrl(url);
      } else {
        // For mobile, we'll simulate the download
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Worksheet downloaded: $fileName"),
            backgroundColor: AppTheme.successGreen,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Download failed. Please try again."),
          backgroundColor: AppTheme.alertRed,
        ),
      );
    }
  }

  String _generateWorksheetContent() {
    final buffer = StringBuffer();
    buffer.writeln("AI GENERATED WORKSHEET");
    buffer.writeln("=" * 50);
    buffer.writeln("Subject: $_selectedSubject");
    buffer.writeln("Grade: $_selectedGrade");
    buffer.writeln("Topic: $_selectedTopic");
    buffer.writeln("Type: $_selectedWorksheetType");
    buffer.writeln("Difficulty: ${_getDifficultyLabel(_difficulty)}");
    buffer.writeln("Questions: $_questionCount");
    buffer.writeln("Generated on: ${DateTime.now().toString().split('.')[0]}");
    buffer.writeln("=" * 50);
    buffer.writeln();

    for (int i = 0; i < _mockWorksheetData.length && i < _questionCount; i++) {
      final question = _mockWorksheetData[i];
      buffer.writeln("Question ${i + 1}: ${question['question']}");

      if (question['type'] == 'multiple_choice') {
        final options = question['options'] as List;
        for (int j = 0; j < options.length; j++) {
          buffer.writeln("  ${String.fromCharCode(65 + j)}. ${options[j]}");
        }
      }

      if (_includeHints && question['hint'] != null) {
        buffer.writeln("Hint: ${question['hint']}");
      }

      buffer.writeln();
    }

    if (_includeAnswerKey) {
      buffer.writeln("ANSWER KEY");
      buffer.writeln("-" * 20);
      for (int i = 0;
          i < _mockWorksheetData.length && i < _questionCount;
          i++) {
        final question = _mockWorksheetData[i];
        buffer.writeln("${i + 1}. ${question['correct_answer']}");
        if (question['explanation'] != null) {
          buffer.writeln("   Explanation: ${question['explanation']}");
        }
      }
    }

    return buffer.toString();
  }

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
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline,
        ),
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
                child:
                    Text(_currentStep == _totalSteps - 1 ? "Review" : "Next"),
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
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
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
                        style:
                            AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.onSurfacePrimary,
                        ),
                      ),
                      Text(
                        "$_selectedSubject • Grade $_selectedGrade • $_selectedTopic",
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.onSurfaceSecondary,
                        ),
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
                  Text(
                    "Preview",
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.onSurfacePrimary,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  ...(_mockWorksheetData.take(_questionCount).map((question) {
                    final index = _mockWorksheetData.indexOf(question);
                    return Container(
                      margin: EdgeInsets.only(bottom: 3.h),
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: AppTheme
                            .lightTheme.colorScheme.surfaceContainerHighest,
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
                                ?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (question['type'] == 'multiple_choice') ...[
                            SizedBox(height: 1.h),
                            ...(question['options'] as List)
                                .asMap()
                                .entries
                                .map((entry) {
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
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _downloadWorksheet,
                    icon: CustomIconWidget(
                      iconName: 'download',
                      color: AppTheme.primaryBlue,
                      size: 5.w,
                    ),
                    label: const Text("Download"),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Worksheet shared successfully!"),
                          backgroundColor: AppTheme.successGreen,
                        ),
                      );
                    },
                    icon: CustomIconWidget(
                      iconName: 'share',
                      color: AppTheme.surfaceWhite,
                      size: 5.w,
                    ),
                    label: const Text("Share"),
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
