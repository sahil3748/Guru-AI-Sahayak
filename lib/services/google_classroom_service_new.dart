import 'dart:convert';
import 'package:googleapis/classroom/v1.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:guru_ai/services/auth_service.dart';
import 'package:guru_ai/models/classroom_models.dart';

class GoogleClassroomService {
  final AuthService _authService = AuthService();

  // Get access token for API calls
  Future<String?> _getAccessToken() async {
    try {
      return await _authService.getAccessToken();
    } catch (e) {
      print('Error getting access token: $e');
      return null;
    }
  }

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
      // Get the appropriate GoogleSignIn instance based on permissions
      GoogleSignIn googleSignIn;
      if (_authService.hasClassroomPermissions) {
        // Use the classroom GoogleSignIn instance from AuthService
        // We need to access it through a new temporary instance with same scopes
        googleSignIn = GoogleSignIn(
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
      } else {
        throw Exception('Classroom permissions not granted');
      }

      final account = googleSignIn.currentUser;
      if (account == null) {
        print('❌ No authenticated Google account found');
        return null;
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
  Future<List<ClassroomCourse>> getTeacherCourses() async {
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

        List<ClassroomCourse> courses = [];
        for (var course in coursesResponse.courses!) {
          print('📚 Course: ${course.name} (ID: ${course.id})');
          print('   Section: ${course.section ?? 'N/A'}');
          print('   State: ${course.courseState ?? 'N/A'}');

          courses.add(
            ClassroomCourse(
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
              descriptionHeading: '',
              creationTime: '',
              updateTime: '',
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
  Future<List<ClassroomCourse>> getStudentCourses() async {
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

        List<ClassroomCourse> courses = [];
        for (var course in coursesResponse.courses!) {
          print('📚 Course: ${course.name} (ID: ${course.id})');

          courses.add(
            ClassroomCourse(
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
              calendarId: course.calendarId ?? '',
              guardiansEnabled: course.guardiansEnabled ?? false,
              descriptionHeading: '',
              creationTime: '',
              updateTime: '',
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
  Future<List<ClassroomCourse>> getAllCourses() async {
    print('🔄 Fetching all courses (teacher + student)');
    try {
      final teacherCourses = await getTeacherCourses();
      final studentCourses = await getStudentCourses();

      // Combine and deduplicate courses
      final allCourses = <String, ClassroomCourse>{};

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

  // Fetch course announcements
  Future<List<ClassroomAnnouncement>> getAnnouncements(String courseId) async {
    print('🔄 Fetching announcements for course: $courseId');
    try {
      final classroomApi = await _getClassroomApi();
      if (classroomApi == null) return [];

      final announcementsResponse = await classroomApi.courses.announcements
          .list(courseId, orderBy: 'updateTime desc');

      if (announcementsResponse.announcements != null) {
        print(
          '✅ Successfully fetched ${announcementsResponse.announcements!.length} announcements',
        );

        return announcementsResponse.announcements!
            .map(
              (announcement) => ClassroomAnnouncement(
                id: announcement.id ?? '',
                courseId: courseId,
                text: announcement.text ?? '',
                state: announcement.state ?? 'UNKNOWN',
                creationTime: announcement.creationTime ?? '',
                updateTime: announcement.updateTime ?? '',
                alternateLink: announcement.alternateLink ?? '',
                materials: [],
                scheduledTime: '',
                assigneeMode: '',
                creatorUserId: '',
              ),
            )
            .toList();
      } else {
        print('ℹ️ No announcements found for course: $courseId');
        return [];
      }
    } catch (error) {
      print('❌ Error fetching announcements: $error');
      return [];
    }
  }

  // Fetch course work (assignments)
  Future<List<ClassroomAssignment>> getAssignments(String courseId) async {
    print('🔄 Fetching assignments for course: $courseId');
    try {
      final classroomApi = await _getClassroomApi();
      if (classroomApi == null) return [];

      final courseWorkResponse = await classroomApi.courses.courseWork.list(
        courseId,
        orderBy: 'updateTime desc',
      );

      if (courseWorkResponse.courseWork != null) {
        print(
          '✅ Successfully fetched ${courseWorkResponse.courseWork!.length} assignments',
        );

        return courseWorkResponse.courseWork!
            .map(
              (courseWork) => ClassroomAssignment(
                id: courseWork.id ?? '',
                courseId: courseId,
                title: courseWork.title ?? 'Untitled Assignment',
                description: courseWork.description ?? '',
                state: courseWork.state ?? 'UNKNOWN',
                workType: courseWork.workType ?? 'ASSIGNMENT',
                creationTime: courseWork.creationTime ?? '',
                updateTime: courseWork.updateTime ?? '',
                dueDate: courseWork.dueDate != null
                    ? DateTime(
                        courseWork.dueDate!.year ?? DateTime.now().year,
                        courseWork.dueDate!.month ?? DateTime.now().month,
                        courseWork.dueDate!.day ?? DateTime.now().day,
                      )
                    : null,
                alternateLink: courseWork.alternateLink ?? '',
                maxPoints: courseWork.maxPoints,
              ),
            )
            .toList();
      } else {
        print('ℹ️ No assignments found for course: $courseId');
        return [];
      }
    } catch (error) {
      print('❌ Error fetching assignments: $error');
      return [];
    }
  }

  // Get course details
  Future<ClassroomCourse?> getCourseDetails(String courseId) async {
    print('🔄 Fetching course details for: $courseId');
    try {
      final classroomApi = await _getClassroomApi();
      if (classroomApi == null) return null;

      final course = await classroomApi.courses.get(courseId);

      if (course != null) {
        print('✅ Successfully fetched course details: ${course.name}');
        return ClassroomCourse(
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
          calendarId: course.calendarId ?? '',
          guardiansEnabled: course.guardiansEnabled ?? false,
          descriptionHeading: '',
          creationTime: '',
          updateTime: '',
        );
      }
      return null;
    } catch (error) {
      print('❌ Error fetching course details: $error');
      return null;
    }
  }
}
