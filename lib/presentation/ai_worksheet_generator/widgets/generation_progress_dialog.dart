import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class GenerationProgressDialog extends StatefulWidget {
  final String topic;
  final int questionCount;
  final VoidCallback onComplete;

  const GenerationProgressDialog({
    super.key,
    required this.topic,
    required this.questionCount,
    required this.onComplete,
  });

  @override
  State<GenerationProgressDialog> createState() =>
      _GenerationProgressDialogState();
}

class _GenerationProgressDialogState extends State<GenerationProgressDialog>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  double _progress = 0.0;
  String _currentStatus = "Initializing AI...";

  final List<String> _statusMessages = [
    "Initializing AI...",
    "Analyzing curriculum standards...",
    "Generating questions...",
    "Creating answer key...",
    "Formatting worksheet...",
    "Finalizing content...",
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.repeat(reverse: true);
    _startGeneration();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _startGeneration() async {
    for (int i = 0; i < _statusMessages.length; i++) {
      await Future.delayed(Duration(milliseconds: 1500 + (i * 500)));
      if (mounted) {
        setState(() {
          _currentStatus = _statusMessages[i];
          _progress = (i + 1) / _statusMessages.length;
        });
      }
    }

    await Future.delayed(const Duration(milliseconds: 1000));
    if (mounted) {
      _animationController.stop();
      widget.onComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: _scaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Container(
                    width: 20.w,
                    height: 20.w,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: CustomIconWidget(
                        iconName: 'auto_awesome',
                        color: AppTheme.primaryBlue,
                        size: 10.w,
                      ),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 4.h),
            Text(
              "Generating Worksheet",
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.onSurfacePrimary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.h),
            Text(
              "Topic: ${widget.topic}",
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.onSurfaceSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              "${widget.questionCount} Questions",
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.onSurfaceSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            LinearProgressIndicator(
              value: _progress,
              backgroundColor: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.3),
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryBlue),
              minHeight: 6,
            ),
            SizedBox(height: 2.h),
            Text(
              _currentStatus,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.primaryBlue,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.h),
            Text(
              "Estimated time: ${_getEstimatedTime()} seconds",
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.onSurfaceSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  String _getEstimatedTime() {
    final baseTime = widget.questionCount * 2;
    final remaining = (baseTime * (1 - _progress)).round();
    return remaining.toString();
  }
}
