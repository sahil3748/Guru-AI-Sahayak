import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class HintSystemWidget extends StatefulWidget {
  final List<String> hints;
  final Function(String) onHintRequested;

  const HintSystemWidget({
    Key? key,
    required this.hints,
    required this.onHintRequested,
  }) : super(key: key);

  @override
  State<HintSystemWidget> createState() => _HintSystemWidgetState();
}

class _HintSystemWidgetState extends State<HintSystemWidget> {
  int _currentHintIndex = 0;
  bool _isExpanded = false;

  void _showNextHint() {
    if (_currentHintIndex < widget.hints.length - 1) {
      setState(() {
        _currentHintIndex++;
      });
      widget.onHintRequested(widget.hints[_currentHintIndex]);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.hints.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(3.w),
        ),
        child: ExpansionTile(
          leading: CustomIconWidget(
            iconName: 'lightbulb',
            color: AppTheme.warningYellow,
            size: 6.w,
          ),
          title: Text(
            'Need a hint?',
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              color: AppTheme.onSurfacePrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            'Tap to reveal step-by-step guidance',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.onSurfaceSecondary,
            ),
          ),
          onExpansionChanged: (expanded) {
            setState(() {
              _isExpanded = expanded;
            });
          },
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: AppTheme.warningYellow.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(2.w),
                      border: Border.all(
                        color: AppTheme.warningYellow.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'info',
                              color: AppTheme.warningYellow,
                              size: 4.w,
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              'Hint ${_currentHintIndex + 1} of ${widget.hints.length}',
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme.onSurfacePrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          widget.hints[_currentHintIndex],
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme.onSurfacePrimary,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_currentHintIndex < widget.hints.length - 1) ...[
                    SizedBox(height: 2.h),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _showNextHint,
                        icon: CustomIconWidget(
                          iconName: 'arrow_forward',
                          color: AppTheme.surfaceWhite,
                          size: 4.w,
                        ),
                        label: Text('Show Next Hint'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.warningYellow,
                          foregroundColor: AppTheme.onSurfacePrimary,
                          padding: EdgeInsets.symmetric(vertical: 2.h),
                        ),
                      ),
                    ),
                  ] else ...[
                    SizedBox(height: 2.h),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color: AppTheme.successGreen.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(2.w),
                        border: Border.all(
                          color: AppTheme.successGreen.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'check_circle',
                            color: AppTheme.successGreen,
                            size: 5.w,
                          ),
                          SizedBox(width: 2.w),
                          Expanded(
                            child: Text(
                              'You\'ve seen all available hints! Try solving it step by step.',
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme.successGreen,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
