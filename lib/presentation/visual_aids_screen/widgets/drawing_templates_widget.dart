import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:guru_ai/theme/app_theme.dart';
import 'package:guru_ai/widgets/custom_icon_widget.dart';
import 'package:guru_ai/widgets/custom_image_widget.dart';
import 'package:sizer/sizer.dart';

class DrawingTemplatesWidget extends StatefulWidget {
  const DrawingTemplatesWidget({Key? key}) : super(key: key);

  @override
  State<DrawingTemplatesWidget> createState() => _DrawingTemplatesWidgetState();
}

class _DrawingTemplatesWidgetState extends State<DrawingTemplatesWidget> {
  String _selectedCategory = 'Science';
  final List<String> _categories = [
    'Science',
    'Mathematics',
    'Geography',
    'History',
    'General',
  ];

  final Map<String, List<Map<String, dynamic>>> _templates = {
    'Science': [
      {
        "id": 1,
        "title": "Human Body Systems",
        "description": "Basic outline of human body with major organs",
        "imageUrl":
            "https://images.unsplash.com/photo-1559757148-5c350d0d3c56?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
        "complexity": "Medium",
        "steps": [
          "Draw basic human outline",
          "Add head and facial features",
          "Mark major organ positions",
          "Label each system clearly",
          "Use different colors for each system",
        ],
        "materials": ["Colored chalk", "Ruler", "Eraser"],
      },
      {
        "id": 2,
        "title": "Plant Cell Structure",
        "description": "Detailed plant cell with organelles",
        "imageUrl":
            "https://images.unsplash.com/photo-1576086213369-97a306d36557?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
        "complexity": "Simple",
        "steps": [
          "Draw rectangular cell wall",
          "Add cell membrane inside",
          "Draw nucleus in center",
          "Add chloroplasts as green circles",
          "Include vacuole and label parts",
        ],
        "materials": ["Green chalk", "White chalk", "Compass"],
      },
      {
        "id": 3,
        "title": "Solar System",
        "description": "Planets in order from the sun",
        "imageUrl":
            "https://images.unsplash.com/photo-1446776653964-20c1d3a81b06?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
        "complexity": "Simple",
        "steps": [
          "Draw sun on the left side",
          "Add orbital paths as curved lines",
          "Draw planets in size order",
          "Label each planet name",
          "Add asteroid belt between Mars and Jupiter",
        ],
        "materials": ["Yellow chalk", "Colored chalk", "Compass"],
      },
    ],
    'Mathematics': [
      {
        "id": 4,
        "title": "Geometric Shapes",
        "description": "Basic 2D and 3D geometric shapes",
        "imageUrl":
            "https://images.unsplash.com/photo-1635070041078-e363dbe005cb?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
        "complexity": "Simple",
        "steps": [
          "Draw basic 2D shapes in a row",
          "Add 3D shapes below",
          "Label each shape clearly",
          "Show properties like angles and sides",
          "Use ruler for straight lines",
        ],
        "materials": ["Ruler", "Compass", "Protractor", "White chalk"],
      },
      {
        "id": 5,
        "title": "Coordinate System",
        "description": "X-Y coordinate plane with grid",
        "imageUrl":
            "https://images.unsplash.com/photo-1509228468518-180dd4864904?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
        "complexity": "Medium",
        "steps": [
          "Draw horizontal X-axis",
          "Draw vertical Y-axis",
          "Mark number scales on both axes",
          "Add grid lines for reference",
          "Plot example points and label",
        ],
        "materials": ["Ruler", "White chalk", "Colored chalk"],
      },
    ],
    'Geography': [
      {
        "id": 6,
        "title": "World Map Outline",
        "description": "Simple world map with continents",
        "imageUrl":
            "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
        "complexity": "Complex",
        "steps": [
          "Start with basic continent shapes",
          "Add major countries outlines",
          "Draw oceans and seas",
          "Label continents and major countries",
          "Add equator and major latitude lines",
        ],
        "materials": ["Blue chalk", "Green chalk", "White chalk"],
      },
      {
        "id": 7,
        "title": "Mountain Formation",
        "description": "Cross-section of mountain formation",
        "imageUrl":
            "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
        "complexity": "Medium",
        "steps": [
          "Draw ground level as horizontal line",
          "Add rock layers below ground",
          "Show folding and faulting",
          "Draw mountain peaks above",
          "Label different rock types",
        ],
        "materials": ["Brown chalk", "Gray chalk", "White chalk"],
      },
    ],
    'History': [
      {
        "id": 8,
        "title": "Timeline Template",
        "description": "Historical timeline with major events",
        "imageUrl":
            "https://images.unsplash.com/photo-1481627834876-b7833e8f5570?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
        "complexity": "Simple",
        "steps": [
          "Draw horizontal timeline arrow",
          "Mark equal time intervals",
          "Add vertical lines for events",
          "Write event names above lines",
          "Include dates below timeline",
        ],
        "materials": ["Ruler", "White chalk", "Colored chalk"],
      },
    ],
    'General': [
      {
        "id": 9,
        "title": "Venn Diagram",
        "description": "Two or three circle Venn diagram",
        "imageUrl":
            "https://images.unsplash.com/photo-1635070041078-e363dbe005cb?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
        "complexity": "Simple",
        "steps": [
          "Draw two overlapping circles",
          "Label each circle clearly",
          "Mark the intersection area",
          "Add examples in each section",
          "Use different colors for clarity",
        ],
        "materials": ["Compass", "Colored chalk", "White chalk"],
      },
    ],
  };

  List<Map<String, dynamic>> get _currentTemplates =>
      _templates[_selectedCategory] ?? [];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCategorySelector(),
          SizedBox(height: 3.h),
          _buildTemplateGrid(),
        ],
      ),
    );
  }

  Widget _buildCategorySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Template Category',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _categories.map((category) {
              final isSelected = _selectedCategory == category;
              return Padding(
                padding: EdgeInsets.only(right: 3.w),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategory = category;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 4.w,
                      vertical: 1.h,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? AppTheme.lightTheme.colorScheme.primary
                            : AppTheme.lightTheme.colorScheme.outline
                                  .withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      category,
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: isSelected
                            ? AppTheme.lightTheme.colorScheme.onPrimary
                            : AppTheme.lightTheme.colorScheme.onSurface,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildTemplateGrid() {
    if (_currentTemplates.isEmpty) {
      return Center(
        child: Column(
          children: [
            SizedBox(height: 10.h),
            CustomIconWidget(
              iconName: 'draw',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 48,
            ),
            SizedBox(height: 2.h),
            Text(
              'No templates available',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        crossAxisSpacing: 3.w,
        mainAxisSpacing: 3.h,
        childAspectRatio: 0.85,
      ),
      itemCount: _currentTemplates.length,
      itemBuilder: (context, index) {
        final template = _currentTemplates[index];
        return _buildTemplateCard(template);
      },
    );
  }

  Widget _buildTemplateCard(Map<String, dynamic> template) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow.withValues(
              alpha: 0.1,
            ),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Template Image
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            child: CustomImageWidget(
              imageUrl: template['imageUrl'] as String,
              width: double.infinity,
              height: 20.h,
              fit: BoxFit.cover,
            ),
          ),

          Expanded(
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Complexity
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          template['title'] as String,
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 2.w,
                          vertical: 0.5.h,
                        ),
                        decoration: BoxDecoration(
                          color: _getComplexityColor(
                            template['complexity'] as String,
                          ).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          template['complexity'] as String,
                          style: AppTheme.lightTheme.textTheme.bodySmall
                              ?.copyWith(
                                color: _getComplexityColor(
                                  template['complexity'] as String,
                                ),
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 1.h),

                  // Description
                  Text(
                    template['description'] as String,
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: 2.h),

                  // Materials needed
                  Text(
                    'Materials:',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Wrap(
                    spacing: 1.w,
                    runSpacing: 0.5.h,
                    children: ((template['materials'] as List).take(3).map((
                      material,
                    ) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 2.w,
                          vertical: 0.5.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.primary
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          material as String,
                          style: AppTheme.lightTheme.textTheme.bodySmall
                              ?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.primary,
                              ),
                        ),
                      );
                    }).toList()),
                  ),

                  Spacer(),

                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _showTemplateDetails(template),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 1.h),
                          ),
                          child: Text('View Steps'),
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _useTemplate(template),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 1.h),
                          ),
                          child: Text('Use Template'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getComplexityColor(String complexity) {
    switch (complexity.toLowerCase()) {
      case 'simple':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'complex':
        return Colors.red;
      default:
        return AppTheme.lightTheme.colorScheme.primary;
    }
  }

  void _showTemplateDetails(Map<String, dynamic> template) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 70.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              width: 12.w,
              height: 0.5.h,
              margin: EdgeInsets.symmetric(vertical: 1.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            template['title'] as String,
                            style: AppTheme.lightTheme.textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: CustomIconWidget(
                            iconName: 'close',
                            color: AppTheme.lightTheme.colorScheme.onSurface,
                            size: 24,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 2.h),

                    // Template image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CustomImageWidget(
                        imageUrl: template['imageUrl'] as String,
                        width: double.infinity,
                        height: 25.h,
                        fit: BoxFit.cover,
                      ),
                    ),

                    SizedBox(height: 3.h),

                    // Description
                    Text(
                      'Description',
                      style: AppTheme.lightTheme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      template['description'] as String,
                      style: AppTheme.lightTheme.textTheme.bodyMedium,
                    ),

                    SizedBox(height: 3.h),

                    // Drawing steps
                    Text(
                      'Drawing Steps',
                      style: AppTheme.lightTheme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 1.h),
                    ...((template['steps'] as List).asMap().entries.map((
                      entry,
                    ) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 1.h),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 6.w,
                              height: 6.w,
                              decoration: BoxDecoration(
                                color: AppTheme.lightTheme.colorScheme.primary,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '${entry.key + 1}',
                                  style: AppTheme.lightTheme.textTheme.bodySmall
                                      ?.copyWith(
                                        color: AppTheme
                                            .lightTheme
                                            .colorScheme
                                            .onPrimary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ),
                            ),
                            SizedBox(width: 3.w),
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

                    SizedBox(height: 3.h),

                    // Materials
                    Text(
                      'Required Materials',
                      style: AppTheme.lightTheme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 1.h),
                    Wrap(
                      spacing: 2.w,
                      runSpacing: 1.h,
                      children: (template['materials'] as List).map((material) {
                        return Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 3.w,
                            vertical: 1.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.primary
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppTheme.lightTheme.colorScheme.primary
                                  .withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomIconWidget(
                                iconName: 'check_circle',
                                color: AppTheme.lightTheme.colorScheme.primary,
                                size: 16,
                              ),
                              SizedBox(width: 1.w),
                              Text(
                                material as String,
                                style: AppTheme.lightTheme.textTheme.bodyMedium
                                    ?.copyWith(
                                      color: AppTheme
                                          .lightTheme
                                          .colorScheme
                                          .primary,
                                    ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),

                    SizedBox(height: 4.h),

                    // Action buttons
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
                            label: Text('Download PDF'),
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              _useTemplate(template);
                            },
                            icon: CustomIconWidget(
                              iconName: 'draw',
                              color: AppTheme.lightTheme.colorScheme.onPrimary,
                              size: 18,
                            ),
                            label: Text('Start Drawing'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _useTemplate(Map<String, dynamic> template) {
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Template "${template['title']}" is ready to use!'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}

