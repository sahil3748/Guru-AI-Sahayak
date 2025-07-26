# Google Classroom Integration Setup and Testing Guide

## Overview
The Guru AI Sahayak app now integrates with Google Classroom to fetch dynamic classroom data for both teachers and students. This replaces the static mock data with real classroom information.

## Features Implemented

### 1. Google Classroom Service (`lib/services/google_classroom_service.dart`)
- Authenticates using existing Google Sign-in
- Fetches teacher courses
- Fetches student courses  
- Retrieves course students and announcements
- Handles permission requests
- Converts classroom data to dashboard format

### 2. Classroom Models (`lib/models/classroom_models.dart`)
- `ClassroomCourse`: Represents a Google Classroom course
- `ClassroomStudent`: Represents students in a course
- `ClassroomAnnouncement`: Represents course announcements
- `ClassroomData`: Helper class to convert API data to dashboard format

### 3. Updated Teacher Dashboard
- Dynamic loading of classroom data
- Permission request UI when classroom access is not granted
- Error handling and retry functionality
- Loading indicators during data fetch

### 4. Updated Student Dashboard
- Dynamic loading of joined classes
- Same permission and error handling as teacher dashboard

## Setup Instructions

### Prerequisites
1. Google Classroom API must be enabled in Google Cloud Console
2. OAuth 2.0 client IDs must include classroom scopes
3. Test users must have Google Classroom accounts with courses

### Testing the Integration

#### For Teachers:
1. **Sign in to the app** using Google account
2. **Grant Classroom Permissions** when prompted
3. **View Dynamic Classes**: The dashboard will now show:
   - Real course names from Google Classroom
   - Actual student counts
   - Recent activity from announcements
   - Last update timestamps

#### For Students:
1. **Sign in to the app** using Google account
2. **Grant Classroom Permissions** when prompted  
3. **View Joined Classes**: The dashboard will show:
   - Classes the student is enrolled in
   - Teacher information
   - Recent announcements

### Permission Flow
1. **Initial Load**: App checks if user has classroom permissions
2. **No Permissions**: Shows permission request UI with "Grant Access" button
3. **Grant Access**: Opens Google sign-in flow with classroom scopes
4. **Success**: Fetches and displays real classroom data
5. **Error**: Shows error message with retry option

## API Scopes Required

The following Google Classroom API scopes are configured in `AuthService`:

```dart
// Course access
'https://www.googleapis.com/auth/classroom.courses.readonly',
'https://www.googleapis.com/auth/classroom.courses',

// Student roster access  
'https://www.googleapis.com/auth/classroom.rosters.readonly',
'https://www.googleapis.com/auth/classroom.rosters',

// Announcements access
'https://www.googleapis.com/auth/classroom.announcements.readonly',

// Profile access
'https://www.googleapis.com/auth/classroom.profile.emails',
'https://www.googleapis.com/auth/classroom.profile.photos',
```

## Data Mapping

### Classroom Course → Dashboard Format
- **Course ID** → Class ID
- **Course Name** → Class Name  
- **Course Name** (parsed) → Subject and Grade
- **Student Count** → Actual enrolled students
- **Latest Announcement** → Recent Activity
- **Update Time** → Last Active

### Automatic Subject Detection
The system automatically detects subjects from course names:
- "Mathematics Grade 8" → Subject: Mathematics, Grade: 8
- "Science Class 7B" → Subject: Science, Grade: 7
- "English Literature" → Subject: English, Grade: N/A

## Error Handling

### Network Errors
- Connection timeouts
- API rate limiting
- Authentication failures

### Permission Errors
- Missing classroom access
- Insufficient scopes
- User denied permission

### Data Errors
- No courses found
- Invalid course data
- API response parsing errors

## Testing Scenarios

### 1. New User (No Permissions)
```
Expected Flow:
1. Sign in → Permission request screen
2. Tap "Grant Access" → Google consent screen
3. Accept permissions → Classroom data loads
4. Dashboard shows real courses
```

### 2. Existing User (Has Permissions)
```
Expected Flow:
1. Sign in → Loading indicator
2. Fetch classroom data → Dashboard shows courses
3. Pull to refresh → Data updates
```

### 3. Teacher with Multiple Classes
```
Expected Data:
- List of all courses where user is teacher
- Student count for each course
- Recent announcements as activity
- Proper subject/grade parsing
```

### 4. Student in Multiple Classes  
```
Expected Data:
- List of all courses where user is student
- Teacher names (may need enhancement)
- Recent announcements
- Pending assignments (future enhancement)
```

## Troubleshooting

### Issue: "No access token available"
**Solution**: Ensure user is signed in with Google and has granted permissions

### Issue: "Failed to fetch courses: 403"
**Solution**: 
1. Check Google Cloud Console API enablement
2. Verify OAuth client configuration
3. Ensure test account has classroom access

### Issue: Empty courses list
**Solution**:
1. Verify test account has created/joined courses in Google Classroom
2. Check course states (only ACTIVE courses are fetched)
3. Confirm user role (teacher vs student)

### Issue: Permission request loops
**Solution**:
1. Clear app data/cache
2. Sign out and sign in again
3. Check Google account permissions in settings

## Future Enhancements

### Immediate (Next Sprint)
- [ ] Fetch teacher names for student courses
- [ ] Get pending assignments count
- [ ] Cache classroom data for offline use
- [ ] Add course creation through app

### Medium Term
- [ ] Real-time updates using webhooks
- [ ] Detailed course analytics
- [ ] Assignment submission tracking
- [ ] Grade management integration

### Long Term  
- [ ] Google Drive integration for course materials
- [ ] Google Meet integration for virtual classes
- [ ] Calendar integration for scheduling
- [ ] Advanced classroom management features

## File Structure
```
lib/
├── models/
│   └── classroom_models.dart          # Classroom API models
├── services/
│   ├── auth_service.dart              # Enhanced with classroom scopes
│   └── google_classroom_service.dart  # Classroom API integration
└── presentation/
    ├── teacher_dashboard/
    │   └── teacher_dashboard.dart     # Dynamic classroom loading
    └── student_dashboard/
        └── student_dashboard.dart     # Dynamic class enrollment
```

## Dependencies Added
- `http: ^1.1.2` - For Google Classroom API calls

## Configuration Notes
- All classroom scopes are pre-configured in `AuthService`
- HTTP package added to pubspec.yaml
- Models handle null safety for optional fields
- Error states include user-friendly messages and retry options
