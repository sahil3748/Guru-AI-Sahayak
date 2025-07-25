import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:guru_ai/theme/app_theme.dart';
import 'package:guru_ai/widgets/custom_icon_widget.dart';
import 'package:guru_ai/widgets/custom_image_widget.dart';
import 'package:sizer/sizer.dart';

class DiagramCreationWidget extends StatefulWidget {
  const DiagramCreationWidget({Key? key}) : super(key: key);

  @override
  State<DiagramCreationWidget> createState() => _DiagramCreationWidgetState();
}

class _DiagramCreationWidgetState extends State<DiagramCreationWidget> {
  final TextEditingController _descriptionController = TextEditingController();
  String _selectedSubject = 'Science';
  String _selectedTemplate = 'Water Cycle';
  bool _isGenerating = false;
  String? _generatedDiagram;

  final List<String> _subjects = [
    'Science',
    'Mathematics',
    'History',
    'Geography',
    'Biology',
  ];

  final Map<String, List<String>> _templates = {
    'Science': [
      'Water Cycle',
      'Solar System',
      'Plant Cell',
      'Food Chain',
      'States of Matter',
    ],
    'Mathematics': [
      'Geometric Shapes',
      'Number Line',
      'Coordinate System',
      'Fractions',
      'Angles',
    ],
    'History': [
      'Timeline',
      'Family Tree',
      'Battle Map',
      'Trade Routes',
      'Government Structure',
    ],
    'Geography': [
      'World Map',
      'Climate Zones',
      'Mountain Formation',
      'River System',
      'Continents',
    ],
    'Biology': [
      'Human Body',
      'Animal Classification',
      'Ecosystem',
      'DNA Structure',
      'Digestive System',
    ],
  };

  final List<Map<String, dynamic>> _mockDiagrams = [
    {
      "id": 1,
      "title": "Water Cycle Diagram",
      "description":
          "Simple water cycle showing evaporation, condensation, and precipitation",
      "imageUrl":
          "https://images.unsplash.com/photo-1544551763-46a013bb70d5?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "subject": "Science",
      "complexity": "Simple",
      "steps": [
        "Draw sun in top right corner",
        "Add wavy lines for evaporation from ocean",
        "Draw clouds in the sky",
        "Add arrows showing water movement",
        "Label each process clearly",
      ],
    },
    {
      "id": 2,
      "title": "Plant Cell Structure",
      "description": "Detailed plant cell with all major organelles labeled",
      "imageUrl":
          "https://images.unsplash.com/photo-1576086213369-97a306d36557?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "subject": "Science",
      "complexity": "Detailed",
      "steps": [
        "Draw outer cell wall as rectangle",
        "Add cell membrane inside",
        "Draw nucleus in center",
        "Add chloroplasts as green ovals",
        "Include vacuole and other organelles",
      ],
    },
  ];

  void _generateDiagram() async {
    if (_descriptionController.text.trim().isEmpty) return;

    setState(() {
      _isGenerating = true;
    });

    // Simulate AI generation
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _isGenerating = false;
      _generatedDiagram = _mockDiagrams.first['imageUrl'] as String;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDescriptionInput(),
          SizedBox(height: 3.h),
          _buildSubjectSelector(),
          SizedBox(height: 3.h),
          _buildTemplateSelector(),
          SizedBox(height: 3.h),
          _buildGenerateButton(),
          if (_generatedDiagram != null) ...[
            SizedBox(height: 3.h),
            _buildGeneratedDiagram(),
          ],
          SizedBox(height: 3.h),
        ],
      ),
    );
  }

  Widget _buildDescriptionInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Describe Your Diagram',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline.withValues(
                alpha: 0.3,
              ),
            ),
          ),
          child: TextField(
            controller: _descriptionController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText:
                  'E.g., Create a simple water cycle diagram with labels for evaporation, condensation, and precipitation',
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(4.w),
              hintStyle: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubjectSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Subject',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline.withValues(
                alpha: 0.3,
              ),
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedSubject,
              isExpanded: true,
              items: _subjects.map((subject) {
                return DropdownMenuItem(value: subject, child: Text(subject));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedSubject = value!;
                  _selectedTemplate = _templates[_selectedSubject]!.first;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTemplateSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Template',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline.withValues(
                alpha: 0.3,
              ),
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedTemplate,
              isExpanded: true,
              items: _templates[_selectedSubject]!.map((template) {
                return DropdownMenuItem(value: template, child: Text(template));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedTemplate = value!;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGenerateButton() {
    return SizedBox(
      width: double.infinity,
      height: 6.h,
      child: ElevatedButton(
        onPressed: _isGenerating ? null : _generateDiagram,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.lightTheme.colorScheme.primary,
          foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: _isGenerating
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 5.w,
                    height: 5.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppTheme.lightTheme.colorScheme.onPrimary,
                      ),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Text('Generating...'),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'auto_awesome',
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Text('Generate Diagram'),
                ],
              ),
      ),
    );
  }

  Widget _buildGeneratedDiagram() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Text(
              'Generated Diagram',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CustomImageWidget(
              imageUrl: _generatedDiagram!,
              width: double.infinity,
              height: 25.h,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Drawing Steps:',
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 1.h),
                ...((_mockDiagrams.first['steps'] as List).asMap().entries.map((
                  entry,
                ) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 0.5.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${entry.key + 1}. ',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w500),
                        ),
                        Expanded(
                          child: Text(
                            entry.value as String,
                            style: AppTheme.lightTheme.textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList()),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: CustomIconWidget(
                          iconName: 'download',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 18,
                        ),
                        label: Text('Export'),
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: CustomIconWidget(
                          iconName: 'share',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 18,
                        ),
                        label: Text('Share'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }
}
