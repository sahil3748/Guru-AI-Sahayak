# Google Classroom Permission Flow Update

## Overview

This update implements a more user-friendly permission flow for Google Classroom integration. Instead of requesting all permissions during the initial Google Sign-In, permissions are now requested progressively based on user actions.

## Changes Made

### 1. AuthService Updates (`lib/services/auth_service.dart`)

**Before:**
- Single `GoogleSignIn` instance with all classroom permissions
- All permissions requested during initial sign-in

**After:**
- Two separate `GoogleSignIn` instances:
  - `_basicGoogleSignIn`: Only requests `email` and `profile` permissions
  - `_classroomGoogleSignIn`: Requests full classroom permissions when needed

**New Methods:**
- `signInWithGoogle()`: Basic sign-in with minimal permissions
- `requestClassroomPermissions()`: Request classroom permissions when user needs classroom access
- `hasClassroomPermissions`: Check if classroom permissions are granted
- `getAccessToken()`: Get access token with appropriate permissions

### 2. GoogleClassroomService Updates (`lib/services/google_classroom_service.dart`)

**Changes:**
- Updated to use `AuthService.getAccessToken()` instead of managing its own GoogleSignIn
- Simplified permission checking through `AuthService.hasClassroomPermissions`
- Removed duplicate `GoogleSignIn` instance

### 3. Teacher Dashboard Updates (`lib/presentation/teacher_dashboard/teacher_dashboard.dart`)

**Changes:**
- Updated to use the new permission system
- Classroom permissions are checked through `_classroomService.hasClassroomPermissions`
- Permission request flow remains the same but now uses the improved backend

## New User Flow

### Step 1: Initial Sign-In
```dart
// User signs in with basic permissions only
final result = await authService.signInWithGoogle();
// Only requests: email, profile
```

### Step 2: Classroom Access Request
```dart
// When user tries to access classroom features
if (!authService.hasClassroomPermissions) {
  final granted = await authService.requestClassroomPermissions();
  if (granted) {
    // User can now access classroom features
  }
}
```

### Step 3: Using Classroom Features
```dart
// All classroom API calls now work with full permissions
final courses = await classroomService.getTeacherCourses();
```

## Benefits

1. **Better User Experience**: Users aren't overwhelmed with permission requests during initial sign-in
2. **Clear Intent**: Permissions are requested when users actually want to use classroom features
3. **Reduced Drop-off**: Users are more likely to complete basic sign-in without extensive permissions
4. **Contextual Permissions**: Users understand why classroom permissions are needed when they're about to use classroom features

## Example Implementation

See `lib/presentation/classroom_access_example.dart` for a complete example of how to implement this flow in your UI.

## Migration Guide

### For Existing Code

If you have existing code that uses the AuthService:

1. **No changes needed** for basic sign-in functionality
2. **Add permission checks** before accessing classroom features:
   ```dart
   if (!authService.hasClassroomPermissions) {
     await authService.requestClassroomPermissions();
   }
   ```

### For New Features

When implementing new classroom-related features:

1. Check for permissions first: `authService.hasClassroomPermissions`
2. Request permissions if needed: `authService.requestClassroomPermissions()`
3. Provide clear UI feedback about what permissions are needed and why

## Testing

To test the new flow:

1. Sign out completely from your Google account in the app
2. Use the example screen (`ClassroomAccessExample`) to test the step-by-step flow
3. Verify that basic sign-in works without classroom permissions
4. Verify that classroom permissions are requested only when accessing classroom features
5. Test that all classroom functionality works after permissions are granted

## Technical Notes

- The system maintains state about whether classroom permissions have been granted
- Both GoogleSignIn instances are managed automatically
- Sign-out clears both basic and classroom sessions
- Access tokens are retrieved from the appropriate GoogleSignIn instance based on permission state
