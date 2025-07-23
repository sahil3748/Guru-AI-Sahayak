import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class TabSelectorWidget extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabSelected;
  final List<String> tabs;

  const TabSelectorWidget({
    Key? key,
    required this.selectedIndex,
    required this.onTabSelected,
    required this.tabs,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: tabs.asMap().entries.map((entry) {
          final int index = entry.key;
          final String tab = entry.value;
          final bool isSelected = index == selectedIndex;

          return Expanded(
            child: GestureDetector(
              onTap: () => onTabSelected(index),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                margin: EdgeInsets.all(1.w),
                padding: EdgeInsets.symmetric(vertical: 2.h),
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.primaryBlue : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppTheme.primaryBlue.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    tab,
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: isSelected
                          ? Colors.white
                          : AppTheme.onSurfaceSecondary,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
