import 'package:googleapis/classroom/v1.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:guru_ai/services/auth_service.dart';

// Simple course class for immediate use
class SimpleCourse {
  final String id;
  final String name;
  final String description;
  final String room;
  final String enrollmentCode;
  final String courseState;
  final String alternateLink;
  final String ownerId;
  final String teacherGroupEmail;
  final String courseGroupEmail;
  final String? calendarId;
  final bool? guardiansEnabled;

  SimpleCourse({
    required this.id,
    required this.name,
    required this.description,
    required this.room,
    required this.enrollmentCode,
    required this.courseState,
    required this.alternateLink,
    required this.ownerId,
    required this.teacherGroupEmail,
    required this.courseGroupEmail,
    this.calendarId,
    this.guardiansEnabled,
  });
}

class GoogleClassroomService {
  final AuthService _authService = AuthService();

  // Request classroom permissions
  Future<bool> requestClassroomPermissions() async {
    try {
      final currentUser = _authService.currentUser;
      if (currentUser == null) return false;

      // Request classroom permissions through AuthService
      return await _authService.requestClassroomPermissions();
    } catch (e) {
      print('Error requesting classroom permissions: $e');
      return false;
    }
  }

  // Check if classroom permissions are granted
  bool get hasClassroomPermissions => _authService.hasClassroomPermissions;

  // Get authenticated Classroom API client
  Future<ClassroomApi?> _getClassroomApi() async {
    print('🔄 Attempting to get Classroom API client');
    try {
      if (!_authService.hasClassroomPermissions) {
        throw Exception('Classroom permissions not granted');
      }

      // Create a GoogleSignIn instance with classroom scopes
      final googleSignIn = GoogleSignIn(
        signInOption: SignInOption.standard,
        scopes: [
          'email',
          'profile',
          'https://www.googleapis.com/auth/classroom.courses.readonly',
          'https://www.googleapis.com/auth/classroom.rosters.readonly',
          'https://www.googleapis.com/auth/classroom.profile.emails',
          'https://www.googleapis.com/auth/classroom.profile.photos',
          'https://www.googleapis.com/auth/classroom.courses',
          'https://www.googleapis.com/auth/classroom.announcements',
          'https://www.googleapis.com/auth/classroom.announcements.readonly',
          'https://www.googleapis.com/auth/classroom.coursework.students',
          'https://www.googleapis.com/auth/classroom.coursework.students.readonly',
          'https://www.googleapis.com/auth/classroom.coursework.me',
          'https://www.googleapis.com/auth/classroom.coursework.me.readonly',
          'https://www.googleapis.com/auth/classroom.topics',
          'https://www.googleapis.com/auth/classroom.topics.readonly',
          'https://www.googleapis.com/auth/classroom.student-submissions.students.readonly',
          'https://www.googleapis.com/auth/classroom.student-submissions.me.readonly',
          'https://www.googleapis.com/auth/classroom.guardianlinks.students',
          'https://www.googleapis.com/auth/classroom.guardianlinks.me.readonly',
          'https://www.googleapis.com/auth/classroom.push-notifications',
          'https://www.googleapis.com/auth/drive.readonly',
          'https://www.googleapis.com/auth/drive.file',
        ],
      );

      // Try to get current user, attempt sign-in if none found
      var account = googleSignIn.currentUser;

      // If no signed-in user, try to sign in silently (token refresh)
      if (account == null) {
        try {
          account = await googleSignIn.signInSilently();
        } catch (e) {
          print('❌ Silent sign-in failed: $e');
        }
      }

      if (account == null) {
        print('❌ No authenticated Google account found');
        throw Exception('No authenticated Google account found');
      }

      print('🔄 Getting authenticated HTTP client for: ${account.email}');

      // Get the HTTP client with auth using the extension
      final httpClient = await googleSignIn.authenticatedClient();

      if (httpClient == null) {
        print('❌ Failed to get authenticated HTTP client');
        return null;
      }

      print('✅ Successfully obtained authenticated HTTP client');
      return ClassroomApi(httpClient);
    } catch (error) {
      print('❌ Error creating Classroom API client: $error');
      print(
        '💡 Stack trace: ${error is Error ? error.stackTrace : 'Not available'}',
      );
      return null;
    }
  }

  // Get courses where user is a teacher
  Future<List<SimpleCourse>> getTeacherCourses() async {
    print('🔄 Fetching teacher courses from Google Classroom API');
    try {
      if (!hasClassroomPermissions) {
        print('❌ No classroom permissions. Cannot fetch courses.');
        return [];
      }

      final classroomApi = await _getClassroomApi();
      if (classroomApi == null) {
        print('❌ Failed to get Classroom API client');
        return [];
      }

      final coursesResponse = await classroomApi.courses.list(
        teacherId: 'me', // Only courses where current user is teacher
        courseStates: ['ACTIVE'], // Only active courses
      );

      if (coursesResponse.courses != null &&
          coursesResponse.courses!.isNotEmpty) {
        print(
          '✅ Successfully fetched ${coursesResponse.courses!.length} teacher courses:',
        );

        List<SimpleCourse> courses = [];
        for (var course in coursesResponse.courses!) {
          print('📚 Course: ${course.name} (ID: ${course.id})');
          print('   Section: ${course.section ?? 'N/A'}');
          print('   State: ${course.courseState ?? 'N/A'}');

          courses.add(
            SimpleCourse(
              id: course.id ?? '',
              name: course.name ?? 'Unnamed Course',
              description: course.description ?? '',
              room: course.room ?? '',
              enrollmentCode: course.enrollmentCode ?? '',
              courseState: course.courseState ?? 'UNKNOWN',
              alternateLink: course.alternateLink ?? '',
              ownerId: course.ownerId ?? '',
              teacherGroupEmail: course.teacherGroupEmail ?? '',
              courseGroupEmail: course.courseGroupEmail ?? '',
              calendarId: course.calendarId,
              guardiansEnabled: course.guardiansEnabled,
            ),
          );
        }
        return courses;
      } else {
        print('ℹ️ No teacher courses found for this account');
        return [];
      }
    } catch (error) {
      print('❌ Error fetching teacher courses: $error');
      print(
        '💡 Stack trace: ${error is Error ? error.stackTrace : 'Not available'}',
      );
      return [];
    }
  }

  // Get courses where user is a student
  Future<List<SimpleCourse>> getStudentCourses() async {
    print('🔄 Fetching student courses from Google Classroom API');
    try {
      if (!hasClassroomPermissions) {
        print('❌ No classroom permissions. Cannot fetch courses.');
        return [];
      }

      final classroomApi = await _getClassroomApi();
      if (classroomApi == null) {
        print('❌ Failed to get Classroom API client');
        return [];
      }

      final coursesResponse = await classroomApi.courses.list(
        studentId: 'me', // Only courses where current user is student
        courseStates: ['ACTIVE'], // Only active courses
      );

      if (coursesResponse.courses != null &&
          coursesResponse.courses!.isNotEmpty) {
        print(
          '✅ Successfully fetched ${coursesResponse.courses!.length} student courses:',
        );

        List<SimpleCourse> courses = [];
        for (var course in coursesResponse.courses!) {
          print('📚 Course: ${course.name} (ID: ${course.id})');

          courses.add(
            SimpleCourse(
              id: course.id ?? '',
              name: course.name ?? 'Unnamed Course',
              description: course.description ?? '',
              room: course.room ?? '',
              enrollmentCode: course.enrollmentCode ?? '',
              courseState: course.courseState ?? 'UNKNOWN',
              alternateLink: course.alternateLink ?? '',
              ownerId: course.ownerId ?? '',
              teacherGroupEmail: course.teacherGroupEmail ?? '',
              courseGroupEmail: course.courseGroupEmail ?? '',
              calendarId: course.calendarId,
              guardiansEnabled: course.guardiansEnabled,
            ),
          );
        }
        return courses;
      } else {
        print('ℹ️ No student courses found for this account');
        return [];
      }
    } catch (error) {
      print('❌ Error fetching student courses: $error');
      print(
        '💡 Stack trace: ${error is Error ? error.stackTrace : 'Not available'}',
      );
      return [];
    }
  }

  // Get all courses (both teacher and student)
  Future<List<SimpleCourse>> getAllCourses() async {
    print('🔄 Fetching all courses (teacher + student)');
    try {
      // First check if we can get a valid API client
      final classroomApi = await _getClassroomApi();
      if (classroomApi == null) {
        throw Exception('No authenticated Google account found');
      }

      final teacherCourses = await getTeacherCourses();
      final studentCourses = await getStudentCourses();

      // Combine and deduplicate courses
      final allCourses = <String, SimpleCourse>{};

      for (var course in teacherCourses) {
        allCourses[course.id] = course;
      }

      for (var course in studentCourses) {
        allCourses[course.id] = course;
      }

      final result = allCourses.values.toList();
      print('✅ Total unique courses found: ${result.length}');
      return result;
    } catch (error) {
      print('❌ Error fetching all courses: $error');
      return [];
    }
  }
}
