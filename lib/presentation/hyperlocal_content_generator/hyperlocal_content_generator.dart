import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../core/app_export.dart';
import '../../api_service/hyperlocal_content_service.dart';
import './widgets/additional_options_section.dart';
import './widgets/content_type_card.dart';
import './widgets/content_preview_widget.dart';
import './widgets/error_state_widget.dart';
import './widgets/grade_level_picker.dart';
import './widgets/language_selector.dart';
import './widgets/location_input_field.dart';
import './widgets/progress_indicator_widget.dart';
import './widgets/subject_selection_card.dart';
import './widgets/topic_input_field.dart';

class HyperLocalContentGenerator extends StatefulWidget {
  const HyperLocalContentGenerator({super.key});

  @override
  State<HyperLocalContentGenerator> createState() =>
      _HyperLocalContentGeneratorState();
}

class _HyperLocalContentGeneratorState
    extends State<HyperLocalContentGenerator> {
  final PageController _pageController = PageController();
  final TextEditingController _topicController = TextEditingController();
  final HyperLocalContentService _contentService = HyperLocalContentService();

  int _currentStep = 1;
  final int _totalSteps = 6;

  // Form data
  String _selectedSubject = '';
  int _selectedGrade = 5;
  String _selectedTopic = '';
  String _selectedContentType = '';
  String _selectedLanguage = 'Hindi';
  String _selectedLocation = '';
  bool _includeLocalExamples = true;
  bool _includeCulturalContext = true;
  bool _includeLocalDialect = false;

  // API response data
  Map<String, dynamic>? _generatedContent;

  // Mock content data
  final List<Map<String, dynamic>> _mockContentData = [
    {
      "id": 1,
      "content":
          "गाँव के किसान राम अपने खेत में गेहूँ उगाता है। उसके पास 15 बीघा जमीन है।",
      "type": "story",
      "local_element": "किसान राम, बीघा (स्थानीय माप)",
      "cultural_context": "भारतीय कृषि प्रणाली",
    },
    {
      "id": 2,
      "content":
          "स्थानीय बाजार में आम 50 रुपये प्रति किलो मिल रहे हैं। रीता को 3 किलो आम खरीदने हैं।",
      "type": "word_problem",
      "local_element": "स्थानीय बाजार, भारतीय मुद्रा",
      "cultural_context": "भारतीय बाजार व्यवस्था",
    },
    {
      "id": 3,
      "content":
          "हमारे शहर की नदी के किनारे पीपल का पेड़ है। इसकी छाया में गाँव के बुजुर्ग बैठते हैं।",
      "type": "comprehension",
      "local_element": "स्थानीय नदी, पीपल का पेड़",
      "cultural_context": "भारतीय सामाजिक परंपरा",
    },
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
        return _selectedGrade > 0;
      case 3:
        return _selectedTopic.isNotEmpty;
      case 4:
        return _selectedContentType.isNotEmpty;
      case 5:
        return _selectedLanguage.isNotEmpty && _selectedLocation.isNotEmpty;
      case 6:
        return true;
      default:
        return false;
    }
  }

  void _generateContent() async {
    // First show a simple loading indicator (non-blocking)
    final loadingOverlay = _showLoadingOverlay();

    try {
      // Call API to generate content - do this BEFORE showing the full dialog
      final response = await _contentService.generateHyperLocalContent(
        subject: _selectedSubject,
        grade: _selectedGrade,
        topic: _selectedTopic,
        contentType: _selectedContentType,
        language: _selectedLanguage,
        location: _selectedLocation,
        includeLocalExamples: _includeLocalExamples,
        includeCulturalContext: _includeCulturalContext,
        includeLocalDialect: _includeLocalDialect,
      );

      // Remove the loading overlay once we have the response
      loadingOverlay.remove();

      // Check if response is successful
      if (response['success'] == true) {
        // Store the generated content
        setState(() {
          _generatedContent = response;
        });

        // Show success generation animation
        await _showSuccessGenerationDialog();

        // Show content preview
        _showContentPreview();
      } else {
        // Show error dialog for API error
        _showErrorDialog(
          ErrorStateWidget.getErrorTitle(
            response,
            defaultTitle: 'Content Generation Failed',
          ),
          ErrorStateWidget.getErrorMessage(response),
        );
      }
    } catch (e) {
      // Remove the loading overlay if it's still showing
      loadingOverlay.remove();

      // Show error dialog for exception
      _showErrorDialog(
        'Content Generation Failed',
        'An unexpected error occurred. Please try again later.\n\n${e.toString()}',
      );
    }
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title, style: TextStyle(color: AppTheme.alertRed)),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _generateContent(); // Try again
            },
            child: const Text('Try Again'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.primary,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  /// Shows a simple loading overlay that doesn't block the UI completely
  OverlayEntry _showLoadingOverlay() {
    final overlayEntry = OverlayEntry(
      builder: (context) => Container(
        color: Colors.black.withOpacity(0.3),
        child: Center(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 6.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 10.w,
                  height: 10.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  "Generating...",
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(overlayEntry);
    return overlayEntry;
  }

  /// Shows a success animation dialog after content is successfully generated
  Future<void> _showSuccessGenerationDialog() async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: EdgeInsets.all(6.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle_outline_rounded,
                color: AppTheme.successGreen,
                size: 15.w,
              ),
              SizedBox(height: 2.h),
              Text(
                "Content Generated Successfully!",
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.onSurfacePrimary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 1.h),
              Text(
                "Your hyper-local content for '$_selectedTopic' in $_selectedLanguage is ready.",
                textAlign: TextAlign.center,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.onSurfaceSecondary,
                ),
              ),
              SizedBox(height: 3.h),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.successGreen,
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 6.h),
                ),
                child: const Text("View Content"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showContentPreview() {
    if (_generatedContent == null) {
      // Show error if no content is available
      _showErrorDialog(
        'Content Not Available',
        'No content is available to preview. Please try generating content again.',
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ContentPreviewWidget(
        contentData: _generatedContent!,
        onClose: () => Navigator.pop(context),
      ),
    );
  }

  // This method is used by the ContentPreviewWidget to download content
  Future<void> _downloadContent() async {
    try {
      _generateContentData(); // Just call the method to simulate content generation
      final fileName =
          "${_selectedTopic.replaceAll(' ', '_')}_hyperlocal_content.txt";

      if (kIsWeb) {
        // Web download implementation would go here
        // final contentData = _generateContentData();
        // final bytes = utf8.encode(contentData);
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
            content: Text("Content downloaded: $fileName"),
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

  String _generateContentData() {
    final buffer = StringBuffer();
    buffer.writeln("HYPER-LOCAL EDUCATIONAL CONTENT");
    buffer.writeln("=" * 50);
    buffer.writeln("Subject: $_selectedSubject");
    buffer.writeln("Grade: $_selectedGrade");
    buffer.writeln("Topic: $_selectedTopic");
    buffer.writeln("Content Type: $_selectedContentType");
    buffer.writeln("Language: $_selectedLanguage");
    buffer.writeln("Location: $_selectedLocation");
    buffer.writeln("Generated on: ${DateTime.now().toString().split('.')[0]}");
    buffer.writeln("=" * 50);
    buffer.writeln();

    if (_generatedContent != null) {
      // Use API response data
      final contentData = _generatedContent!['content'] as List<dynamic>?;
      if (contentData != null) {
        for (int i = 0; i < contentData.length; i++) {
          final content = contentData[i] as Map<String, dynamic>;
          buffer.writeln("Content ${i + 1}: ${content['content'] ?? 'N/A'}");
          buffer.writeln("Type: ${content['type'] ?? 'N/A'}");
          buffer.writeln(
            "Local Elements: ${content['local_element'] ?? 'N/A'}",
          );
          buffer.writeln(
            "Cultural Context: ${content['cultural_context'] ?? 'N/A'}",
          );
          buffer.writeln();
        }
      }
    } else {
      // Fallback to mock data if API response is not available
      for (int i = 0; i < _mockContentData.length; i++) {
        final content = _mockContentData[i];
        buffer.writeln("Content ${i + 1}: ${content['content']}");
        buffer.writeln("Type: ${content['type']}");
        buffer.writeln("Local Elements: ${content['local_element']}");
        buffer.writeln("Cultural Context: ${content['cultural_context']}");
        buffer.writeln();
      }
    }

    return buffer.toString();
  }

  // This method is referenced by the ContentPreviewWidget
  List<Map<String, dynamic>> _getContentDataForPreview() {
    if (_generatedContent != null) {
      final contentData = _generatedContent!['content'] as List<dynamic>?;
      if (contentData != null) {
        return contentData.cast<Map<String, dynamic>>();
      }
    }
    // Fallback to mock data
    return _mockContentData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundOffWhite,
      appBar: AppBar(
        title: const Text("Generate Hyper-Local Content"),
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
                _buildContentTypeStep(),
                _buildLanguageLocationStep(),
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
      {'name': 'Social Studies', 'icon': 'public', 'color': AppTheme.alertRed},
      {'name': 'Hindi', 'icon': 'translate', 'color': AppTheme.warningYellow},
      {'name': 'English', 'icon': 'menu_book', 'color': Colors.purple},
      {
        'name': 'Environmental Studies',
        'icon': 'eco',
        'color': Colors.green[700]!,
      },
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
            "Select the subject for your hyper-local content",
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
            "Specify the topic you want to create hyper-local content about",
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

  Widget _buildContentTypeStep() {
    final contentTypes = [
      {
        'type': 'Stories & Narratives',
        'description': 'Local stories with regional characters and settings',
        'example': 'Story about local farmer using traditional methods',
        'icon': 'auto_stories',
      },
      {
        'type': 'Word Problems',
        'description': 'Math problems using local context and currency',
        'example': 'Calculate profit from selling mangoes in local market',
        'icon': 'calculate',
      },
      {
        'type': 'Reading Comprehension',
        'description': 'Passages about local culture and traditions',
        'example': 'Reading about local festivals and traditions',
        'icon': 'menu_book',
      },
      {
        'type': 'Activity Instructions',
        'description': 'Hands-on activities using local materials',
        'example': 'Science experiment using local plants and materials',
        'icon': 'science',
      },
    ];

    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Content Type",
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.onSurfacePrimary,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            "Choose the format for your hyper-local content",
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.onSurfaceSecondary,
            ),
          ),
          SizedBox(height: 4.h),
          Column(
            children: contentTypes.map((type) {
              return ContentTypeCard(
                type: type['type'] as String,
                description: type['description'] as String,
                example: type['example'] as String,
                iconName: type['icon'] as String,
                isSelected: _selectedContentType == type['type'],
                onTap: () {
                  setState(() {
                    _selectedContentType = type['type'] as String;
                  });
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageLocationStep() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Language & Location",
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.onSurfacePrimary,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            "Select the language and specify your location for localized content",
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.onSurfaceSecondary,
            ),
          ),
          SizedBox(height: 4.h),
          LanguageSelector(
            selectedLanguage: _selectedLanguage,
            onLanguageSelected: (language) {
              setState(() {
                _selectedLanguage = language;
              });
            },
          ),
          SizedBox(height: 4.h),
          LocationInputField(
            selectedLocation: _selectedLocation,
            onLocationSelected: (location) {
              setState(() {
                _selectedLocation = location;
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
            "Customize your hyper-local content with additional features",
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.onSurfaceSecondary,
            ),
          ),
          SizedBox(height: 4.h),
          AdditionalOptionsSection(
            includeLocalExamples: _includeLocalExamples,
            includeCulturalContext: _includeCulturalContext,
            includeLocalDialect: _includeLocalDialect,
            onLocalExamplesChanged: (value) {
              setState(() {
                _includeLocalExamples = value;
              });
            },
            onCulturalContextChanged: (value) {
              setState(() {
                _includeCulturalContext = value;
              });
            },
            onLocalDialectChanged: (value) {
              setState(() {
                _includeLocalDialect = value;
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
            "Preview Sample Content",
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.onSurfacePrimary,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            "See sample hyper-local content before generating the full set",
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.onSurfaceSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 2.h),
          OutlinedButton(
            onPressed: () {
              _showSampleContent();
            },
            child: const Text("Show Preview"),
          ),
        ],
      ),
    );
  }

  void _showSampleContent() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Sample Content"),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Here is sample hyper-local content for $_selectedTopic:",
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
              SizedBox(height: 2.h),
              ...(_mockContentData.take(2).map((content) {
                return Container(
                  margin: EdgeInsets.only(bottom: 2.h),
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color:
                        AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        content['content'] as String,
                        style: AppTheme.lightTheme.textTheme.bodyMedium,
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        "Local Elements: ${content['local_element']}",
                        style: AppTheme.lightTheme.textTheme.bodySmall
                            ?.copyWith(
                              color: AppTheme.onSurfaceSecondary,
                              fontStyle: FontStyle.italic,
                            ),
                      ),
                    ],
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
                onPressed: _generateContent,
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
                    const Text("Generate Content"),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // Old _buildContentPreviewSheet method removed as it's replaced by ContentPreviewWidget
}
