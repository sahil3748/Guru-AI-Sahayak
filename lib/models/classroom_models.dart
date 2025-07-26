class ClassroomCourse {
  final String id;
  final String name;
  final String description;
  final String descriptionHeading;
  final String room;
  final String ownerId;
  final String creationTime;
  final String updateTime;
  final String enrollmentCode;
  final String courseState;
  final String alternateLink;
  final String teacherGroupEmail;
  final String courseGroupEmail;
  final bool? guardiansEnabled;
  final String? calendarId;

  ClassroomCourse({
    required this.id,
    required this.name,
    required this.description,
    required this.descriptionHeading,
    required this.room,
    required this.ownerId,
    required this.creationTime,
    required this.updateTime,
    required this.enrollmentCode,
    required this.courseState,
    required this.alternateLink,
    required this.teacherGroupEmail,
    required this.courseGroupEmail,
    this.guardiansEnabled,
    this.calendarId,
  });

  factory ClassroomCourse.fromJson(Map<String, dynamic> json) {
    return ClassroomCourse(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      descriptionHeading: json['descriptionHeading'] ?? '',
      room: json['room'] ?? '',
      ownerId: json['ownerId'] ?? '',
      creationTime: json['creationTime'] ?? '',
      updateTime: json['updateTime'] ?? '',
      enrollmentCode: json['enrollmentCode'] ?? '',
      courseState: json['courseState'] ?? '',
      alternateLink: json['alternateLink'] ?? '',
      teacherGroupEmail: json['teacherGroupEmail'] ?? '',
      courseGroupEmail: json['courseGroupEmail'] ?? '',
      guardiansEnabled: json['guardiansEnabled'],
      calendarId: json['calendarId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'descriptionHeading': descriptionHeading,
      'room': room,
      'ownerId': ownerId,
      'creationTime': creationTime,
      'updateTime': updateTime,
      'enrollmentCode': enrollmentCode,
      'courseState': courseState,
      'alternateLink': alternateLink,
      'teacherGroupEmail': teacherGroupEmail,
      'courseGroupEmail': courseGroupEmail,
      'guardiansEnabled': guardiansEnabled,
      'calendarId': calendarId,
    };
  }
}

class ClassroomStudent {
  final String courseId;
  final String userId;
  final UserProfile profile;
  final String studentWorkFolder;

  ClassroomStudent({
    required this.courseId,
    required this.userId,
    required this.profile,
    required this.studentWorkFolder,
  });

  factory ClassroomStudent.fromJson(Map<String, dynamic> json) {
    return ClassroomStudent(
      courseId: json['courseId'] ?? '',
      userId: json['userId'] ?? '',
      profile: UserProfile.fromJson(json['profile'] ?? {}),
      studentWorkFolder: json['studentWorkFolder'] ?? '',
    );
  }
}

class UserProfile {
  final String id;
  final Name name;
  final String emailAddress;
  final String photoUrl;
  final List<String> permissions;
  final bool verifiedTeacher;

  UserProfile({
    required this.id,
    required this.name,
    required this.emailAddress,
    required this.photoUrl,
    required this.permissions,
    required this.verifiedTeacher,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] ?? '',
      name: Name.fromJson(json['name'] ?? {}),
      emailAddress: json['emailAddress'] ?? '',
      photoUrl: json['photoUrl'] ?? '',
      permissions: List<String>.from(json['permissions'] ?? []),
      verifiedTeacher: json['verifiedTeacher'] ?? false,
    );
  }
}

class Name {
  final String givenName;
  final String familyName;
  final String fullName;

  Name({
    required this.givenName,
    required this.familyName,
    required this.fullName,
  });

  factory Name.fromJson(Map<String, dynamic> json) {
    return Name(
      givenName: json['givenName'] ?? '',
      familyName: json['familyName'] ?? '',
      fullName: json['fullName'] ?? '',
    );
  }
}

class ClassroomAnnouncement {
  final String id;
  final String courseId;
  final String text;
  final List<Material> materials;
  final String state;
  final String alternateLink;
  final String creationTime;
  final String updateTime;
  final String scheduledTime;
  final String assigneeMode;
  final String creatorUserId;

  ClassroomAnnouncement({
    required this.id,
    required this.courseId,
    required this.text,
    required this.materials,
    required this.state,
    required this.alternateLink,
    required this.creationTime,
    required this.updateTime,
    required this.scheduledTime,
    required this.assigneeMode,
    required this.creatorUserId,
  });

  factory ClassroomAnnouncement.fromJson(Map<String, dynamic> json) {
    return ClassroomAnnouncement(
      id: json['id'] ?? '',
      courseId: json['courseId'] ?? '',
      text: json['text'] ?? '',
      materials:
          (json['materials'] as List<dynamic>?)
              ?.map((item) => Material.fromJson(item))
              .toList() ??
          [],
      state: json['state'] ?? '',
      alternateLink: json['alternateLink'] ?? '',
      creationTime: json['creationTime'] ?? '',
      updateTime: json['updateTime'] ?? '',
      scheduledTime: json['scheduledTime'] ?? '',
      assigneeMode: json['assigneeMode'] ?? '',
      creatorUserId: json['creatorUserId'] ?? '',
    );
  }
}

class Material {
  final DriveFile? driveFile;
  final YoutubeVideo? youtubeVideo;
  final Link? link;
  final Form? form;

  Material({this.driveFile, this.youtubeVideo, this.link, this.form});

  factory Material.fromJson(Map<String, dynamic> json) {
    return Material(
      driveFile: json['driveFile'] != null
          ? DriveFile.fromJson(json['driveFile'])
          : null,
      youtubeVideo: json['youtubeVideo'] != null
          ? YoutubeVideo.fromJson(json['youtubeVideo'])
          : null,
      link: json['link'] != null ? Link.fromJson(json['link']) : null,
      form: json['form'] != null ? Form.fromJson(json['form']) : null,
    );
  }
}

class DriveFile {
  final String id;
  final String title;
  final String alternateLink;
  final String thumbnailUrl;

  DriveFile({
    required this.id,
    required this.title,
    required this.alternateLink,
    required this.thumbnailUrl,
  });

  factory DriveFile.fromJson(Map<String, dynamic> json) {
    return DriveFile(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      alternateLink: json['alternateLink'] ?? '',
      thumbnailUrl: json['thumbnailUrl'] ?? '',
    );
  }
}

class YoutubeVideo {
  final String id;
  final String title;
  final String alternateLink;
  final String thumbnailUrl;

  YoutubeVideo({
    required this.id,
    required this.title,
    required this.alternateLink,
    required this.thumbnailUrl,
  });

  factory YoutubeVideo.fromJson(Map<String, dynamic> json) {
    return YoutubeVideo(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      alternateLink: json['alternateLink'] ?? '',
      thumbnailUrl: json['thumbnailUrl'] ?? '',
    );
  }
}

class Link {
  final String url;
  final String title;
  final String thumbnailUrl;

  Link({required this.url, required this.title, required this.thumbnailUrl});

  factory Link.fromJson(Map<String, dynamic> json) {
    return Link(
      url: json['url'] ?? '',
      title: json['title'] ?? '',
      thumbnailUrl: json['thumbnailUrl'] ?? '',
    );
  }
}

class Form {
  final String formUrl;
  final String responseUrl;
  final String title;
  final String thumbnailUrl;

  Form({
    required this.formUrl,
    required this.responseUrl,
    required this.title,
    required this.thumbnailUrl,
  });

  factory Form.fromJson(Map<String, dynamic> json) {
    return Form(
      formUrl: json['formUrl'] ?? '',
      responseUrl: json['responseUrl'] ?? '',
      title: json['title'] ?? '',
      thumbnailUrl: json['thumbnailUrl'] ?? '',
    );
  }
}

// Helper class to map classroom data to dashboard format
class ClassroomData {
  final String id;
  final String name;
  final String subject;
  final String grade;
  final int studentCount;
  final String recentActivity;
  final int unreadAnnouncements;
  final String lastActive;

  ClassroomData({
    required this.id,
    required this.name,
    required this.subject,
    required this.grade,
    required this.studentCount,
    required this.recentActivity,
    required this.unreadAnnouncements,
    required this.lastActive,
  });

  factory ClassroomData.fromClassroomCourse(
    ClassroomCourse course,
    int studentCount,
    String recentActivity,
    int unreadAnnouncements,
  ) {
    return ClassroomData(
      id: course.id,
      name: course.name,
      subject: _extractSubject(course.name),
      grade: _extractGrade(course.name),
      studentCount: studentCount,
      recentActivity: recentActivity,
      unreadAnnouncements: unreadAnnouncements,
      lastActive: _formatLastActive(course.updateTime),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'subject': subject,
      'grade': grade,
      'studentCount': studentCount,
      'recentActivity': recentActivity,
      'unreadAnnouncements': unreadAnnouncements,
      'lastActive': lastActive,
    };
  }

  static String _extractSubject(String courseName) {
    // Try to extract subject from course name
    final subjects = [
      'Mathematics',
      'Math',
      'Science',
      'English',
      'Hindi',
      'Social Studies',
      'Computer Science',
      'Physics',
      'Chemistry',
      'Biology',
      'History',
      'Geography',
    ];

    for (String subject in subjects) {
      if (courseName.toLowerCase().contains(subject.toLowerCase())) {
        return subject;
      }
    }
    return 'General';
  }

  static String _extractGrade(String courseName) {
    // Try to extract grade from course name
    final gradePatterns = [
      RegExp(r'grade\s*(\d+)', caseSensitive: false),
      RegExp(r'class\s*(\d+)', caseSensitive: false),
      RegExp(r'(\d+)(?:st|nd|rd|th)', caseSensitive: false),
    ];

    for (RegExp pattern in gradePatterns) {
      final match = pattern.firstMatch(courseName);
      if (match != null && match.group(1) != null) {
        return match.group(1)!;
      }
    }
    return 'N/A';
  }

  static String _formatLastActive(String updateTime) {
    if (updateTime.isEmpty) return 'Unknown';

    try {
      final updatedDateTime = DateTime.parse(updateTime);
      final now = DateTime.now();
      final difference = now.difference(updatedDateTime);

      if (difference.inMinutes < 60) {
        return '${difference.inMinutes} minutes ago';
      } else if (difference.inHours < 24) {
        return '${difference.inHours} hours ago';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} days ago';
      } else {
        return 'More than a week ago';
      }
    } catch (e) {
      return 'Unknown';
    }
  }
}

class ClassroomAssignment {
  final String id;
  final String courseId;
  final String title;
  final String description;
  final String state;
  final String workType;
  final String creationTime;
  final String updateTime;
  final DateTime? dueDate;
  final String alternateLink;
  final double? maxPoints;

  ClassroomAssignment({
    required this.id,
    required this.courseId,
    required this.title,
    required this.description,
    required this.state,
    required this.workType,
    required this.creationTime,
    required this.updateTime,
    this.dueDate,
    required this.alternateLink,
    this.maxPoints,
  });

  factory ClassroomAssignment.fromJson(Map<String, dynamic> json) {
    return ClassroomAssignment(
      id: json['id'] ?? '',
      courseId: json['courseId'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      state: json['state'] ?? '',
      workType: json['workType'] ?? 'ASSIGNMENT',
      creationTime: json['creationTime'] ?? '',
      updateTime: json['updateTime'] ?? '',
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
      alternateLink: json['alternateLink'] ?? '',
      maxPoints: json['maxPoints']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'courseId': courseId,
      'title': title,
      'description': description,
      'state': state,
      'workType': workType,
      'creationTime': creationTime,
      'updateTime': updateTime,
      'dueDate': dueDate?.toIso8601String(),
      'alternateLink': alternateLink,
      'maxPoints': maxPoints,
    };
  }
}
