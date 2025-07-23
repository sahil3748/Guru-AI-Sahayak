import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TypingIndicatorWidget extends StatefulWidget {
  const TypingIndicatorWidget({Key? key}) : super(key: key);

  @override
  State<TypingIndicatorWidget> createState() => _TypingIndicatorWidgetState();
}

class _TypingIndicatorWidgetState extends State<TypingIndicatorWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Container(
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue
                      .withValues(alpha: 0.7 + (_animation.value * 0.3)),
                  borderRadius: BorderRadius.circular(4.w),
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: 'psychology',
                    color: AppTheme.surfaceWhite,
                    size: 5.w,
                  ),
                ),
              );
            },
          ),
          SizedBox(width: 2.w),
          Container(
            constraints: BoxConstraints(maxWidth: 75.w),
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: AppTheme.surfaceWhite,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(4.w),
                topRight: Radius.circular(4.w),
                bottomLeft: Radius.circular(1.w),
                bottomRight: Radius.circular(4.w),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.shadowLight,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'GuruAI is thinking',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.onSurfaceSecondary,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                SizedBox(width: 2.w),
                SizedBox(
                  width: 6.w,
                  height: 2.h,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(3, (index) {
                      return AnimatedBuilder(
                        animation: _animationController,
                        builder: (context, child) {
                          final delay = index * 0.2;
                          final animValue = (_animationController.value - delay)
                              .clamp(0.0, 1.0);
                          return Transform.translate(
                            offset: Offset(0, -2 * animValue),
                            child: Container(
                              width: 1.w,
                              height: 1.w,
                              decoration: BoxDecoration(
                                color: AppTheme.primaryBlue
                                    .withValues(alpha: 0.5 + (animValue * 0.5)),
                                shape: BoxShape.circle,
                              ),
                            ),
                          );
                        },
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
