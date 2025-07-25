import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:guru_ai/presentation/visual_aids_screen/widgets/chart_creation_widget.dart';
import 'package:guru_ai/presentation/visual_aids_screen/widgets/diagram_creation_widget.dart';
import 'package:guru_ai/presentation/visual_aids_screen/widgets/drawing_templates_widget.dart';
import 'package:guru_ai/theme/app_theme.dart';
import 'package:guru_ai/widgets/custom_icon_widget.dart';
import 'package:guru_ai/widgets/custom_image_widget.dart';
import 'package:sizer/sizer.dart';

class VisualAidsCreatorScreen extends StatefulWidget {
  const VisualAidsCreatorScreen({Key? key}) : super(key: key);

  @override
  State<VisualAidsCreatorScreen> createState() =>
      _VisualAidsCreatorScreenState();
}

class _VisualAidsCreatorScreenState extends State<VisualAidsCreatorScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int _currentTabIndex = 0;

  // Customization settings
  double _lineThickness = 2.0;
  String _complexity = 'Medium';
  double _labelSize = 14.0;
  bool _highContrast = false;

  final List<Map<String, dynamic>> _tabs = [
    {
      'title': 'Diagrams',
      'icon': 'auto_awesome',
      'description': 'AI-generated educational diagrams',
    },
    {
      'title': 'Charts',
      'icon': 'bar_chart',
      'description': 'Data visualization tools',
    },
    {
      'title': 'Templates',
      'icon': 'draw',
      'description': 'Pre-made drawing outlines',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentTabIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                DiagramCreationWidget(),
                ChartCreationWidget(),
                DrawingTemplatesWidget(),
              ],
            ),
          ),
          // CustomizationPanelWidget(
          //   onLineThicknessChanged: (value) {
          //     setState(() {
          //       _lineThickness = value;
          //     });
          //   },
          //   onComplexityChanged: (value) {
          //     setState(() {
          //       _complexity = value;
          //     });
          //   },
          //   onLabelSizeChanged: (value) {
          //     setState(() {
          //       _labelSize = value;
          //     });
          //   },
          //   onHighContrastChanged: (value) {
          //     setState(() {
          //       _highContrast = value;
          //     });
          //   },
          // ),
        ],
      ),
      // floatingActionButton: _buildFloatingActionButton(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: CustomIconWidget(
          iconName: 'arrow_back',
          color: AppTheme.lightTheme.colorScheme.onSurface,
          size: 24,
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Visual Aids Creator',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            _tabs[_currentTabIndex]['description'] as String,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: _showHelpDialog,
          icon: CustomIconWidget(
            iconName: 'help_outline',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
        PopupMenuButton<String>(
          onSelected: _handleMenuSelection,
          icon: CustomIconWidget(
            iconName: 'more_vert',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'library',
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'library_books',
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    size: 20,
                  ),
                  SizedBox(width: 3.w),
                  Text('Content Library'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'settings',
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'settings',
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    size: 20,
                  ),
                  SizedBox(width: 3.w),
                  Text('Settings'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'feedback',
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'feedback',
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    size: 20,
                  ),
                  SizedBox(width: 3.w),
                  Text('Send Feedback'),
                ],
              ),
            ),
          ],
        ),
      ],
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Container(
          height: 1,
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: AppTheme.lightTheme.colorScheme.surface,
      child: TabBar(
        controller: _tabController,
        indicatorColor: AppTheme.lightTheme.colorScheme.primary,
        indicatorWeight: 3,
        labelColor: AppTheme.lightTheme.colorScheme.primary,
        unselectedLabelColor: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        labelStyle: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: AppTheme.lightTheme.textTheme.titleSmall
            ?.copyWith(fontWeight: FontWeight.w400),
        tabs: _tabs.map((tab) {
          return Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: tab['icon'] as String,
                  color: _currentTabIndex == _tabs.indexOf(tab)
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Flexible(
                  child: Text(
                    tab['title'] as String,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: _showVoiceInputDialog,
      backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
      child: CustomIconWidget(
        iconName: 'mic',
        color: AppTheme.lightTheme.colorScheme.onPrimary,
        size: 20,
      ),
      // label: Text(
      //   'Voice Input',
      //   style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
      //     color: AppTheme.lightTheme.colorScheme.onPrimary,
      //     fontWeight: FontWeight.w600,
      //   ),
      // ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'help',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 24,
            ),
            SizedBox(width: 3.w),
            Text(
              'How to Use',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHelpSection(
                'Diagrams Tab',
                'Describe what you want to draw and AI will generate a blackboard-optimized diagram with step-by-step instructions.',
              ),
              SizedBox(height: 2.h),
              _buildHelpSection(
                'Charts Tab',
                'Input your data to create bar charts, pie charts, or line graphs perfect for classroom presentation.',
              ),
              SizedBox(height: 2.h),
              _buildHelpSection(
                'Templates Tab',
                'Browse pre-made drawing templates organized by subject with detailed drawing instructions.',
              ),
              SizedBox(height: 2.h),
              _buildHelpSection(
                'Voice Input',
                'Use the microphone button to describe what you want to create using voice commands.',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Got it',
              style: TextStyle(
                color: AppTheme.lightTheme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpSection(String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.primary,
          ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          description,
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  void _showVoiceInputDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 50.h,
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
              child: Padding(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  children: [
                    Text(
                      'Voice Input',
                      style: AppTheme.lightTheme.textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'Describe what you want to create',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),

                    SizedBox(height: 4.h),

                    // Microphone animation
                    Container(
                      width: 30.w,
                      height: 30.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.lightTheme.colorScheme.primary
                            .withValues(alpha: 0.1),
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: CustomIconWidget(
                          iconName: 'mic',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 48,
                        ),
                      ),
                    ),

                    SizedBox(height: 4.h),

                    Text(
                      'Try saying:',
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 1.h),

                    // Example commands
                    ...[
                          '"Create a water cycle diagram"',
                          '"Make a bar chart with 4 data points"',
                          '"Show me human body templates"',
                        ]
                        .map(
                          (example) => Padding(
                            padding: EdgeInsets.only(bottom: 1.h),
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(3.w),
                              decoration: BoxDecoration(
                                color: AppTheme.lightTheme.colorScheme.primary
                                    .withValues(alpha: 0.05),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: AppTheme.lightTheme.colorScheme.primary
                                      .withValues(alpha: 0.2),
                                ),
                              ),
                              child: Text(
                                example,
                                style: AppTheme.lightTheme.textTheme.bodyMedium
                                    ?.copyWith(
                                      color: AppTheme
                                          .lightTheme
                                          .colorScheme
                                          .primary,
                                      fontStyle: FontStyle.italic,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        )
                        .toList(),

                    Spacer(),

                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('Cancel'),
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Voice input feature coming soon!',
                                  ),
                                  backgroundColor:
                                      AppTheme.lightTheme.colorScheme.primary,
                                ),
                              );
                            },
                            icon: CustomIconWidget(
                              iconName: 'mic',
                              color: AppTheme.lightTheme.colorScheme.onPrimary,
                              size: 18,
                            ),
                            label: Text('Start Listening'),
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

  void _handleMenuSelection(String value) {
    switch (value) {
      case 'library':
        Navigator.pushNamed(context, '/content-library-screen');
        break;
      case 'settings':
        _showSettingsDialog();
        break;
      case 'feedback':
        _showFeedbackDialog();
        break;
    }
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(
          'Settings',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: CustomIconWidget(
                iconName: 'language',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text('Language'),
              subtitle: Text('English'),
              onTap: () {},
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'palette',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text('Theme'),
              subtitle: Text('Light'),
              onTap: () {},
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'save',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text('Auto-save'),
              subtitle: Text('Enabled'),
              onTap: () {},
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: TextStyle(
                color: AppTheme.lightTheme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFeedbackDialog() {
    final TextEditingController feedbackController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(
          'Send Feedback',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Help us improve the Visual Aids Creator',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 2.h),
            TextField(
              controller: feedbackController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText:
                    'Share your thoughts, suggestions, or report issues...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Thank you for your feedback!'),
                  backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                ),
              );
            },
            child: Text('Send'),
          ),
        ],
      ),
    );
  }
}

class CustomizationPanelWidget extends StatefulWidget {
  final Function(double) onLineThicknessChanged;
  final Function(String) onComplexityChanged;
  final Function(double) onLabelSizeChanged;
  final Function(bool) onHighContrastChanged;

  const CustomizationPanelWidget({
    Key? key,
    required this.onLineThicknessChanged,
    required this.onComplexityChanged,
    required this.onLabelSizeChanged,
    required this.onHighContrastChanged,
  }) : super(key: key);

  @override
  State<CustomizationPanelWidget> createState() =>
      _CustomizationPanelWidgetState();
}

class _CustomizationPanelWidgetState extends State<CustomizationPanelWidget> {
  double _lineThickness = 2.0;
  String _complexity = 'Medium';
  double _labelSize = 14.0;
  bool _highContrast = false;
  bool _isExpanded = false;

  final List<String> _complexityLevels = ['Simple', 'Medium', 'Detailed'];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(4.w),
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
        children: [
          _buildHeader(),
          if (_isExpanded) _buildCustomizationOptions(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      child: Container(
        padding: EdgeInsets.all(4.w),
        child: Row(
          children: [
            CustomIconWidget(
              iconName: 'tune',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 24,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Text(
                'Customization Options',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            CustomIconWidget(
              iconName: _isExpanded ? 'expand_less' : 'expand_more',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomizationOptions() {
    return Container(
      padding: EdgeInsets.fromLTRB(4.w, 0, 4.w, 4.w),
      child: Column(
        children: [
          Divider(
            color: AppTheme.lightTheme.colorScheme.outline.withValues(
              alpha: 0.3,
            ),
            height: 1,
          ),
          SizedBox(height: 3.h),
          _buildLineThicknessControl(),
          SizedBox(height: 3.h),
          _buildComplexityControl(),
          SizedBox(height: 3.h),
          _buildLabelSizeControl(),
          SizedBox(height: 3.h),
          _buildHighContrastToggle(),
          SizedBox(height: 3.h),
          _buildPresetButtons(),
        ],
      ),
    );
  }

  Widget _buildLineThicknessControl() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Line Thickness',
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary.withValues(
                  alpha: 0.1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${_lineThickness.toInt()}px',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        Row(
          children: [
            CustomIconWidget(
              iconName: 'remove',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 20,
            ),
            Expanded(
              child: Slider(
                value: _lineThickness,
                min: 1.0,
                max: 5.0,
                divisions: 4,
                activeColor: AppTheme.lightTheme.colorScheme.primary,
                inactiveColor: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.3),
                onChanged: (value) {
                  setState(() {
                    _lineThickness = value;
                  });
                  widget.onLineThicknessChanged(value);
                },
              ),
            ),
            CustomIconWidget(
              iconName: 'add',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 20,
            ),
          ],
        ),
        // Visual preview
        Container(
          width: double.infinity,
          height: 4.h,
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline.withValues(
                alpha: 0.3,
              ),
            ),
          ),
          child: Center(
            child: Container(
              width: 20.w,
              height: _lineThickness,
              color: AppTheme.lightTheme.colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildComplexityControl() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Complexity Level',
          style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Row(
          children: _complexityLevels.map((level) {
            final isSelected = _complexity == level;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: level != _complexityLevels.last ? 2.w : 0,
                ),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _complexity = level;
                    });
                    widget.onComplexityChanged(level);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 1.5.h),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected
                            ? AppTheme.lightTheme.colorScheme.primary
                            : AppTheme.lightTheme.colorScheme.outline
                                  .withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      children: [
                        CustomIconWidget(
                          iconName: _getComplexityIcon(level),
                          color: isSelected
                              ? AppTheme.lightTheme.colorScheme.onPrimary
                              : AppTheme.lightTheme.colorScheme.onSurface,
                          size: 20,
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          level,
                          style: AppTheme.lightTheme.textTheme.bodySmall
                              ?.copyWith(
                                color: isSelected
                                    ? AppTheme.lightTheme.colorScheme.onPrimary
                                    : AppTheme.lightTheme.colorScheme.onSurface,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildLabelSizeControl() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Label Size',
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary.withValues(
                  alpha: 0.1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${_labelSize.toInt()}sp',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        Row(
          children: [
            Text(
              'A',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            Expanded(
              child: Slider(
                value: _labelSize,
                min: 10.0,
                max: 20.0,
                divisions: 10,
                activeColor: AppTheme.lightTheme.colorScheme.primary,
                inactiveColor: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.3),
                onChanged: (value) {
                  setState(() {
                    _labelSize = value;
                  });
                  widget.onLabelSizeChanged(value);
                },
              ),
            ),
            Text(
              'A',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        // Preview text
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline.withValues(
                alpha: 0.3,
              ),
            ),
          ),
          child: Center(
            child: Text(
              'Sample Label Text',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontSize: _labelSize,
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHighContrastToggle() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'High Contrast Mode',
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                'Optimized for blackboard visibility',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: _highContrast,
          onChanged: (value) {
            setState(() {
              _highContrast = value;
            });
            widget.onHighContrastChanged(value);
          },
          activeColor: AppTheme.lightTheme.colorScheme.primary,
        ),
      ],
    );
  }

  Widget _buildPresetButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Presets',
          style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _applyPreset('blackboard'),
                icon: CustomIconWidget(
                  iconName: 'school',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 16,
                ),
                label: Text('Blackboard'),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 1.h),
                ),
              ),
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _applyPreset('print'),
                icon: CustomIconWidget(
                  iconName: 'print',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 16,
                ),
                label: Text('Print'),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 1.h),
                ),
              ),
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _applyPreset('digital'),
                icon: CustomIconWidget(
                  iconName: 'computer',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 16,
                ),
                label: Text('Digital'),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 1.h),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _getComplexityIcon(String complexity) {
    switch (complexity) {
      case 'Simple':
        return 'radio_button_unchecked';
      case 'Medium':
        return 'adjust';
      case 'Detailed':
        return 'settings';
      default:
        return 'adjust';
    }
  }

  void _applyPreset(String preset) {
    setState(() {
      switch (preset) {
        case 'blackboard':
          _lineThickness = 3.0;
          _complexity = 'Simple';
          _labelSize = 16.0;
          _highContrast = true;
          break;
        case 'print':
          _lineThickness = 2.0;
          _complexity = 'Medium';
          _labelSize = 12.0;
          _highContrast = false;
          break;
        case 'digital':
          _lineThickness = 1.0;
          _complexity = 'Detailed';
          _labelSize = 14.0;
          _highContrast = false;
          break;
      }
    });

    // Notify parent of all changes
    widget.onLineThicknessChanged(_lineThickness);
    widget.onComplexityChanged(_complexity);
    widget.onLabelSizeChanged(_labelSize);
    widget.onHighContrastChanged(_highContrast);

    // Show feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${preset.toUpperCase()} preset applied'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
