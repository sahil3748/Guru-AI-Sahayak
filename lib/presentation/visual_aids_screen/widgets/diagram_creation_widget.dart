import 'package:flutter/material.dart';
import 'package:guru_ai/api_service/api_service.dart';
import 'package:guru_ai/api_service/visual_aids_service.dart';
import 'package:guru_ai/models/visual_aids_response.dart';
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
  bool _isGenerating = false;
  VisualAid? _generatedVisualAid;
  final VisualAidsService _visualAidsService = VisualAidsService();
  String? _errorMessage;

  final List<String> _subjects = [
    'Science',
    'Mathematics',
    'History',
    'Geography',
    'Biology',
    'Social Studies',
  ];

  void _generateDiagram() async {
    if (_descriptionController.text.trim().isEmpty) return;

    setState(() {
      _isGenerating = true;
      _errorMessage = null;
    });

    try {
      // Call the API service
      VisualAidsResponse response = await _visualAidsService.generateVisualAid(
        description: _descriptionController.text.trim(),
        subject: _selectedSubject,
      );

      if (response.visualAids.isNotEmpty) {
        setState(() {
          _isGenerating = false;
          _generatedVisualAid = response.visualAids.first;
        });
      } else {
        setState(() {
          _isGenerating = false;
          _errorMessage = 'No visual aids were generated. Please try again.';
        });
      }
    } catch (e) {
      setState(() {
        _isGenerating = false;
        _errorMessage = 'Error generating visual aid: ${e.toString()}';
      });
      print('Error generating visual aid: $e');
    }
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
          _buildGenerateButton(),
          if (_errorMessage != null) ...[
            SizedBox(height: 3.h),
            _buildErrorMessage(),
          ],
          if (_generatedVisualAid != null) ...[
            SizedBox(height: 3.h),
            _buildGeneratedDiagram(),
          ],
          SizedBox(height: 3.h),
        ],
      ),
    );
  }

  Widget _buildErrorMessage() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        _errorMessage ?? 'An error occurred',
        style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
          color: AppTheme.lightTheme.colorScheme.onErrorContainer,
        ),
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
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGenerateButton() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 6.h,
          child: ElevatedButton(
            onPressed: _isGenerating ? null : _generateDiagram,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.primary,
              foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
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
        ),
        if (_isGenerating) ...[
          SizedBox(height: 3.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primaryContainer
                  .withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                LinearProgressIndicator(
                  backgroundColor: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppTheme.lightTheme.colorScheme.primary,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'Creating your visual aid...\nThis may take 10-15 seconds',
                  textAlign: TextAlign.center,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildGeneratedDiagram() {
    // Get the drawing instructions as a list
    List<String> instructions = _generatedVisualAid!.getNumberedInstructions();

    // Construct the full image URL
    // String baseUrl = 'https://backend-infra-200499489667.us-central1.run.app';
    String imageUrl = ApiService.baseUrl + _generatedVisualAid!.imageUrl;

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
              _generatedVisualAid!.title,
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CustomImageWidget(
              imageUrl: imageUrl,
              width: double.infinity,
              height: 25.h,
              fit: BoxFit.contain,
              errorWidget: Container(
                width: double.infinity,
                height: 25.h,
                color: AppTheme.lightTheme.colorScheme.errorContainer,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'error_outline',
                        color: AppTheme.lightTheme.colorScheme.onErrorContainer,
                        size: 48,
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        'Failed to load image',
                        style: AppTheme.lightTheme.textTheme.bodyMedium
                            ?.copyWith(
                              color: AppTheme
                                  .lightTheme
                                  .colorScheme
                                  .onErrorContainer,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
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
                ...(instructions.asMap().entries.map((entry) {
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
                            entry.value,
                            style: AppTheme.lightTheme.textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList()),
                SizedBox(height: 2.h),
                // Row(
                //   children: [
                //     Expanded(
                //       child: OutlinedButton.icon(
                //         onPressed: () {},
                //         icon: CustomIconWidget(
                //           iconName: 'download',
                //           color: AppTheme.lightTheme.colorScheme.primary,
                //           size: 18,
                //         ),
                //         label: Text('Export'),
                //       ),
                //     ),
                //     SizedBox(width: 3.w),
                //     Expanded(
                //       child: OutlinedButton.icon(
                //         onPressed: () {},
                //         icon: CustomIconWidget(
                //           iconName: 'share',
                //           color: AppTheme.lightTheme.colorScheme.primary,
                //           size: 18,
                //         ),
                //         label: Text('Share'),
                //       ),
                //     ),
                //   ],
                // ),
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
