import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PeopleCardWidget extends StatelessWidget {
  final Map<String, dynamic> person;
  final bool isTeacher;
  final bool isCurrentUser;
  final VoidCallback? onLongPress;

  const PeopleCardWidget({
    Key? key,
    required this.person,
    required this.isTeacher,
    required this.isCurrentUser,
    this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String role = person['role'] as String;
    final bool isOnline = person['isOnline'] as bool? ?? false;
    final String? profileImage = person['profileImage'] as String?;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.5.h),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onLongPress: isTeacher && !isCurrentUser ? onLongPress : null,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                Stack(
                  children: [
                    Container(
                      width: 12.w,
                      height: 12.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isCurrentUser
                              ? AppTheme.primaryBlue
                              : AppTheme.outlineLight,
                          width: isCurrentUser ? 2 : 1,
                        ),
                      ),
                      child: ClipOval(
                        child: profileImage != null
                            ? CustomImageWidget(
                                imageUrl: profileImage,
                                width: 12.w,
                                height: 12.w,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                color:
                                    AppTheme.primaryBlue.withValues(alpha: 0.1),
                                child: Center(
                                  child: Text(
                                    (person['name'] as String)
                                        .substring(0, 1)
                                        .toUpperCase(),
                                    style: AppTheme
                                        .lightTheme.textTheme.titleMedium
                                        ?.copyWith(
                                      color: AppTheme.primaryBlue,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                      ),
                    ),
                    if (isOnline)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 3.w,
                          height: 3.w,
                          decoration: BoxDecoration(
                            color: AppTheme.successGreen,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 1,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              person['name'] as String,
                              style: AppTheme.lightTheme.textTheme.titleMedium
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isCurrentUser)
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 2.w, vertical: 0.5.h),
                              decoration: BoxDecoration(
                                color:
                                    AppTheme.primaryBlue.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'You',
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: AppTheme.primaryBlue,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 0.5.h),
                      Row(
                        children: [
                          _buildRoleChip(role),
                          SizedBox(width: 2.w),
                          Text(
                            isOnline ? 'Online' : 'Offline',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: isOnline
                                  ? AppTheme.successGreen
                                  : AppTheme.onSurfaceSecondary,
                            ),
                          ),
                        ],
                      ),
                      if (person['email'] != null)
                        Container(
                          margin: EdgeInsets.only(top: 0.5.h),
                          child: Text(
                            person['email'] as String,
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.onSurfaceSecondary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                  ),
                ),
                if (isTeacher && !isCurrentUser)
                  CustomIconWidget(
                    iconName: 'more_vert',
                    color: AppTheme.onSurfaceSecondary,
                    size: 20,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleChip(String role) {
    Color backgroundColor;
    Color textColor;
    String iconName;

    switch (role.toLowerCase()) {
      case 'teacher':
        backgroundColor = AppTheme.primaryBlue.withValues(alpha: 0.1);
        textColor = AppTheme.primaryBlue;
        iconName = 'school';
        break;
      case 'student':
        backgroundColor = AppTheme.successGreen.withValues(alpha: 0.1);
        textColor = AppTheme.successGreen;
        iconName = 'person';
        break;
      default:
        backgroundColor = AppTheme.onSurfaceSecondary.withValues(alpha: 0.1);
        textColor = AppTheme.onSurfaceSecondary;
        iconName = 'group';
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: iconName,
            color: textColor,
            size: 12,
          ),
          SizedBox(width: 1.w),
          Text(
            role,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
