import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TopicInputField extends StatefulWidget {
  final String selectedSubject;
  final int selectedGrade;
  final TextEditingController controller;
  final Function(String) onTopicSelected;

  const TopicInputField({
    super.key,
    required this.selectedSubject,
    required this.selectedGrade,
    required this.controller,
    required this.onTopicSelected,
  });

  @override
  State<TopicInputField> createState() => _TopicInputFieldState();
}

class _TopicInputFieldState extends State<TopicInputField> {
  List<String> _suggestions = [];
  bool _showSuggestions = false;

  List<String> _getTopicSuggestions(String subject, int grade) {
    final Map<String, Map<int, List<String>>> curriculumTopics = {
      'Math': {
        3: [
          'Addition & Subtraction',
          'Multiplication Tables',
          'Basic Fractions',
          'Shapes & Patterns'
        ],
        4: ['Division', 'Decimals', 'Area & Perimeter', 'Time & Money'],
        5: [
          'Fractions & Decimals',
          'Geometry',
          'Data Handling',
          'Measurements'
        ],
        6: ['Integers', 'Algebra Basics', 'Ratio & Proportion', 'Symmetry'],
        7: ['Linear Equations', 'Triangles', 'Percentage', 'Statistics'],
        8: [
          'Quadratic Equations',
          'Coordinate Geometry',
          'Probability',
          'Mensuration'
        ],
      },
      'Science': {
        3: ['Plants & Animals', 'Our Body', 'Food & Health', 'Weather'],
        4: ['Living & Non-living', 'Water Cycle', 'Air & Wind', 'Rocks & Soil'],
        5: [
          'Human Body Systems',
          'Plants Life Cycle',
          'Light & Shadow',
          'Simple Machines'
        ],
        6: [
          'Motion & Measurement',
          'Light & Reflection',
          'Electricity',
          'Natural Resources'
        ],
        7: [
          'Heat & Temperature',
          'Acids & Bases',
          'Weather & Climate',
          'Nutrition in Plants'
        ],
        8: [
          'Force & Pressure',
          'Chemical Effects',
          'Sound',
          'Reproduction in Animals'
        ],
      },
      'English': {
        3: [
          'Phonics & Spelling',
          'Simple Sentences',
          'Story Reading',
          'Rhymes & Poems'
        ],
        4: [
          'Grammar Basics',
          'Paragraph Writing',
          'Comprehension',
          'Vocabulary Building'
        ],
        5: ['Tenses', 'Essay Writing', 'Reading Skills', 'Creative Writing'],
        6: [
          'Parts of Speech',
          'Letter Writing',
          'Literature',
          'Speaking Skills'
        ],
        7: [
          'Active & Passive Voice',
          'Formal Writing',
          'Poetry Analysis',
          'Debate & Discussion'
        ],
        8: [
          'Complex Grammar',
          'Report Writing',
          'Drama & Theatre',
          'Critical Thinking'
        ],
      },
      'Hindi': {
        3: ['वर्णमाला', 'सरल वाक्य', 'कहानी पढ़ना', 'कविता'],
        4: ['व्याकरण', 'अनुच्छेद लेखन', 'गद्यांश', 'शब्द भंडार'],
        5: ['काल', 'निबंध लेखन', 'पठन कौशल', 'रचनात्मक लेखन'],
        6: ['संज्ञा सर्वनाम', 'पत्र लेखन', 'साहित्य', 'भाषण कला'],
        7: ['वाच्य', 'औपचारिक लेखन', 'काव्य विश्लेषण', 'वाद-विवाद'],
        8: ['जटिल व्याकरण', 'रिपोर्ट लेखन', 'नाटक', 'आलोचनात्मक चिंतन'],
      },
    };

    return curriculumTopics[subject]?[grade] ?? [];
  }

  void _onTextChanged(String value) {
    if (value.isNotEmpty) {
      setState(() {
        _suggestions = _getTopicSuggestions(
                widget.selectedSubject, widget.selectedGrade)
            .where((topic) => topic.toLowerCase().contains(value.toLowerCase()))
            .toList();
        _showSuggestions = _suggestions.isNotEmpty;
      });
    } else {
      setState(() {
        _showSuggestions = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Enter Topic",
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.onSurfacePrimary,
          ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: widget.controller,
          onChanged: _onTextChanged,
          decoration: InputDecoration(
            hintText: "e.g., Fractions, Photosynthesis, Grammar...",
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: 'search',
                color: AppTheme.onSurfaceSecondary,
                size: 5.w,
              ),
            ),
          ),
          style: AppTheme.lightTheme.textTheme.bodyLarge,
        ),
        if (_showSuggestions) ...[
          SizedBox(height: 1.h),
          Container(
            constraints: BoxConstraints(maxHeight: 20.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.shadowLight,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: _suggestions.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
              ),
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    _suggestions[index],
                    style: AppTheme.lightTheme.textTheme.bodyMedium,
                  ),
                  leading: CustomIconWidget(
                    iconName: 'lightbulb_outline',
                    color: AppTheme.primaryBlue,
                    size: 5.w,
                  ),
                  onTap: () {
                    widget.controller.text = _suggestions[index];
                    widget.onTopicSelected(_suggestions[index]);
                    setState(() {
                      _showSuggestions = false;
                    });
                  },
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}
