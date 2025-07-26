import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../core/app_export.dart';

class ContentPreviewWidget extends StatefulWidget {
  final Map<String, dynamic> contentData;
  final Function() onClose;

  const ContentPreviewWidget({
    super.key,
    required this.contentData,
    required this.onClose,
  });

  @override
  State<ContentPreviewWidget> createState() => _ContentPreviewWidgetState();
}

class _ContentPreviewWidgetState extends State<ContentPreviewWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabs = ['Content', 'Questions', 'Metadata'];
  int _activeIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(() {
      if (_tabController.index != _activeIndex) {
        setState(() {
          _activeIndex = _tabController.index;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final contentPieces = widget.contentData['content'] as List<dynamic>? ?? [];
    final questions = widget.contentData['questions'] as List<dynamic>? ?? [];
    final metadata =
        widget.contentData['metadata'] as Map<String, dynamic>? ?? {};

    return Container(
      height: 90.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          _buildHeader(),
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildContentTab(contentPieces),
                _buildQuestionsTab(questions),
                _buildMetadataTab(metadata),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final String subject = widget.contentData['metadata']?['subject'] ?? '';
    final dynamic grade = widget.contentData['metadata']?['grade_levels'] ?? [];
    final String topic = widget.contentData['metadata']?['topic'] ?? '';
    final String language = widget.contentData['metadata']?['language'] ?? '';

    String gradeText = '';
    if (grade is List && grade.isNotEmpty) {
      if (grade.length == 1) {
        gradeText = 'Grade ${grade[0]}';
      } else {
        gradeText = 'Grades ${grade.join(', ')}';
      }
    }

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppTheme.lightTheme.colorScheme.outline.withOpacity(0.3),
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
                  "Hyper-Local Content Generated!",
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.onSurfacePrimary,
                  ),
                ),
                if (subject.isNotEmpty ||
                    topic.isNotEmpty ||
                    language.isNotEmpty)
                  Text(
                    [
                      if (subject.isNotEmpty) _formatField(subject),
                      if (gradeText.isNotEmpty) gradeText,
                      if (topic.isNotEmpty) _formatField(topic),
                      if (language.isNotEmpty) language,
                    ].join(' • '),
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.onSurfaceSecondary,
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            onPressed: widget.onClose,
            icon: Icon(
              Icons.close_rounded,
              color: AppTheme.onSurfaceSecondary,
              size: 6.w,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppTheme.lightTheme.colorScheme.outline.withOpacity(0.3),
          ),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
        labelColor: AppTheme.lightTheme.colorScheme.primary,
        unselectedLabelColor: AppTheme.onSurfaceSecondary,
        indicatorColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  Widget _buildContentTab(List<dynamic> contentPieces) {
    if (contentPieces.isEmpty) {
      return _buildEmptyState("No content pieces available");
    }

    return ListView.builder(
      padding: EdgeInsets.all(4.w),
      itemCount: contentPieces.length,
      itemBuilder: (context, index) {
        final content = contentPieces[index] as Map<String, dynamic>;
        final title = content['title'] ?? 'Content ${index + 1}';
        final contentText = content['content'] ?? '';
        final contentType = content['content_type'] ?? '';
        final difficultyLevel = content['difficulty_level'] ?? '';
        final estimatedTime = content['estimated_time'] ?? '';

        return Card(
          margin: EdgeInsets.only(bottom: 3.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primaryContainer
                      .withOpacity(0.3),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: AppTheme.lightTheme.textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    if (contentType.isNotEmpty ||
                        difficultyLevel.isNotEmpty ||
                        estimatedTime.isNotEmpty)
                      Row(
                        children: [
                          if (difficultyLevel.isNotEmpty)
                            Chip(
                              label: Text(
                                _formatField(difficultyLevel),
                                style: AppTheme.lightTheme.textTheme.labelSmall,
                              ),
                              backgroundColor: _getDifficultyColor(
                                difficultyLevel,
                              ),
                              padding: EdgeInsets.zero,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                            ),
                          if (estimatedTime.isNotEmpty)
                            Padding(
                              padding: EdgeInsets.only(left: 2.w),
                              child: Text(
                                estimatedTime,
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                      color: AppTheme.onSurfaceSecondary,
                                    ),
                              ),
                            ),
                        ],
                      ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(4.w),
                child: Text(
                  contentText,
                  style: AppTheme.lightTheme.textTheme.bodyMedium,
                ),
              ),
              // Content footer with local elements, if any
              _buildContentFooter(content),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContentFooter(Map<String, dynamic> content) {
    final List<dynamic> localElements = content['local_elements'] ?? [];
    final List<dynamic> culturalAnnotations =
        content['cultural_annotations'] ?? [];

    if (localElements.isEmpty && culturalAnnotations.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (localElements.isNotEmpty) ...[
            Text(
              'Local Elements:',
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
            Wrap(
              spacing: 2.w,
              runSpacing: 1.h,
              children: localElements.map<Widget>((element) {
                return Chip(
                  label: Text(element.toString()),
                  backgroundColor:
                      AppTheme.lightTheme.colorScheme.secondaryContainer,
                  padding: EdgeInsets.zero,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                );
              }).toList(),
            ),
          ],
          if (culturalAnnotations.isNotEmpty &&
              culturalAnnotations.length <= 5) ...[
            SizedBox(height: 2.h),
            Text(
              'Cultural Context:',
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
            ...culturalAnnotations.map((annotation) {
              return Padding(
                padding: EdgeInsets.only(bottom: 0.5.h),
                child: Text(
                  '• $annotation',
                  style: AppTheme.lightTheme.textTheme.bodySmall,
                ),
              );
            }).toList(),
          ],
        ],
      ),
    );
  }

  Widget _buildQuestionsTab(List<dynamic> questions) {
    if (questions.isEmpty) {
      return _buildEmptyState("No questions available");
    }

    return ListView.builder(
      padding: EdgeInsets.all(4.w),
      itemCount: questions.length,
      itemBuilder: (context, index) {
        final question = questions[index] as Map<String, dynamic>;
        final type = question['type'] ?? '';
        final content = question['content'] ?? '';
        final subject = question['subject'] ?? '';

        return Card(
          margin: EdgeInsets.only(bottom: 3.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.tertiaryContainer
                      .withOpacity(0.3),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Question ${index + 1}',
                        style: AppTheme.lightTheme.textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    if (type.isNotEmpty)
                      Chip(
                        label: Text(
                          _formatQuestionType(type),
                          style: AppTheme.lightTheme.textTheme.labelSmall,
                        ),
                        backgroundColor:
                            AppTheme.lightTheme.colorScheme.tertiaryContainer,
                        padding: EdgeInsets.zero,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(4.w),
                child: Text(
                  content,
                  style: AppTheme.lightTheme.textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMetadataTab(Map<String, dynamic> metadata) {
    if (metadata.isEmpty) {
      return _buildEmptyState("No metadata available");
    }

    final items = <MapEntry<String, dynamic>>[];
    metadata.forEach((key, value) {
      // Skip certain fields or nested objects
      if (value is! List && value is! Map) {
        items.add(MapEntry(key, value));
      } else if (value is List &&
          key != 'cultural_elements_used' &&
          key != 'local_references') {
        items.add(MapEntry(key, value.join(', ')));
      }
    });

    // Add cultural elements and local references separately
    final culturalElements =
        metadata['cultural_elements_used'] as List<dynamic>? ?? [];
    final localReferences =
        metadata['local_references'] as List<dynamic>? ?? [];

    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Content Information',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  ...items.map((entry) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 1.5.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              _formatField(entry.key),
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              entry.value.toString(),
                              style: AppTheme.lightTheme.textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
          SizedBox(height: 3.h),
          if (culturalElements.isNotEmpty) ...[
            Text(
              'Cultural Elements Used',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
              child: Padding(
                padding: EdgeInsets.all(3.w),
                child: Wrap(
                  spacing: 2.w,
                  runSpacing: 1.h,
                  children: culturalElements.map<Widget>((element) {
                    return Chip(
                      label: Text(element.toString()),
                      backgroundColor:
                          AppTheme.lightTheme.colorScheme.secondaryContainer,
                      padding: EdgeInsets.zero,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
          SizedBox(height: 3.h),
          if (localReferences.isNotEmpty) ...[
            Text(
              'Local References',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
              child: Padding(
                padding: EdgeInsets.all(3.w),
                child: Wrap(
                  spacing: 2.w,
                  runSpacing: 1.h,
                  children: localReferences.map<Widget>((reference) {
                    return Chip(
                      label: Text(reference.toString()),
                      backgroundColor:
                          AppTheme.lightTheme.colorScheme.tertiaryContainer,
                      padding: EdgeInsets.zero,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 16.w,
            color: AppTheme.onSurfaceSecondary,
          ),
          SizedBox(height: 2.h),
          Text(
            message,
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.onSurfaceSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _formatField(String text) {
    if (text.isEmpty) return '';

    final words = text.split('_');
    return words
        .map(
          (word) =>
              word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : '',
        )
        .join(' ');
  }

  String _formatQuestionType(String type) {
    switch (type.toLowerCase()) {
      case 'mcq':
        return 'Multiple Choice';
      case 'short_answer':
        return 'Short Answer';
      case 'essay':
        return 'Essay';
      case 'true_false':
        return 'True/False';
      default:
        return _formatField(type);
    }
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return Colors.green.shade100;
      case 'medium':
        return Colors.orange.shade100;
      case 'hard':
        return Colors.red.shade100;
      default:
        return AppTheme.lightTheme.colorScheme.surfaceVariant;
    }
  }
}
