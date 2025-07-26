import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class GenerationProgressDialog extends StatefulWidget {
  final String topic;
  final String language;
  final String location;
  final VoidCallback onComplete;

  const GenerationProgressDialog({
    super.key,
    required this.topic,
    required this.language,
    required this.location,
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
  int _currentStep = 0;

  final List<String> _steps = [
    "Analyzing topic and location...",
    "Gathering local cultural data...",
    "Generating localized content...",
    "Adding regional examples...",
    "Finalizing content...",
  ];

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.repeat(reverse: true);
    _startProgress();
  }

  void _startProgress() async {
    for (int i = 0; i < _steps.length; i++) {
      setState(() {
        _currentStep = i;
      });

      await Future.delayed(const Duration(milliseconds: 800));

      setState(() {
        _progress = (i + 1) / _steps.length;
      });
    }

    await Future.delayed(const Duration(milliseconds: 500));

    if (mounted) {
      _animationController.stop();
      widget.onComplete();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
                        iconName: 'translate',
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
              "Generating Hyper-Local Content",
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
              "Language: ${widget.language}",
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.onSurfaceSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              "Location: ${widget.location}",
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
              minHeight: 0.8.h,
            ),
            SizedBox(height: 2.h),
            Text(
              _currentStep < _steps.length ? _steps[_currentStep] : "Complete!",
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
}
