import 'dart:convert';

class Session {
  final String sessionId;
  final String userId;
  final String languagePreference;
  final int messageCount;
  final List<String> contextKeys;
  final String lastActive;

  Session({
    required this.sessionId,
    required this.userId,
    required this.languagePreference,
    required this.messageCount,
    required this.contextKeys,
    required this.lastActive,
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      sessionId: json['session_id'],
      userId: json['user_id'],
      languagePreference: json['language_preference'],
      messageCount: json['message_count'],
      contextKeys: List<String>.from(json['context_keys']),
      lastActive: json['last_active'],
    );
  }
}

class VisualAidsResponse {
  final String status;
  final String agentType;
  final String language;
  final String subject;
  final List<int> gradeLevels;
  final List<VisualAid> visualAids;
  final String generationTime;
  final String? errorMessage;
  final Session? session;
  final VisualAidMetadata metadata;

  VisualAidsResponse({
    required this.status,
    required this.agentType,
    required this.language,
    required this.subject,
    required this.gradeLevels,
    required this.visualAids,
    required this.generationTime,
    this.errorMessage,
    this.session,
    required this.metadata,
  });

  factory VisualAidsResponse.fromJson(Map<String, dynamic> json) {
    return VisualAidsResponse(
      status: json['status'],
      agentType: json['agent_type'],
      language: json['language'],
      subject: json['subject'],
      gradeLevels: List<int>.from(json['grade_levels']),
      visualAids: List<VisualAid>.from(
        (json['visual_aids'] as List).map((x) => VisualAid.fromJson(x)),
      ),
      generationTime: json['generation_time'],
      errorMessage: json['error_message'],
      session: json['session'] != null
          ? Session.fromJson(json['session'])
          : null,
      metadata: VisualAidMetadata.fromJson(json['metadata']),
    );
  }
}

class VisualAid {
  final String title;
  final String description;
  final String imageUrl;
  final String imagePath;
  final String drawingInstructions;
  final String visualType;
  final String complexity;
  final String estimatedDrawingTime;
  final List<String> labels;
  final List<String> teachingTips;

  VisualAid({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.imagePath,
    required this.drawingInstructions,
    required this.visualType,
    required this.complexity,
    required this.estimatedDrawingTime,
    required this.labels,
    required this.teachingTips,
  });

  factory VisualAid.fromJson(Map<String, dynamic> json) {
    return VisualAid(
      title: json['title'] ?? 'Untitled Visual Aid',
      description: json['description'] ?? 'No description available',
      imageUrl: json['image_url'] ?? '',
      imagePath: json['image_path'] ?? '',
      drawingInstructions: json['drawing_instructions'] ?? '',
      visualType: json['visual_type'] ?? '',
      complexity: json['complexity'] ?? '',
      estimatedDrawingTime: json['estimated_drawing_time'] ?? '',
      labels: List<String>.from(json['labels'] ?? []),
      teachingTips: List<String>.from(json['teaching_tips'] ?? []),
    );
  }

  // Get numbered instructions as a list
  List<String> getNumberedInstructions() {
    // Remove asterisks and clean up the text
    String cleanedInstructions = drawingInstructions
        .replaceAll('**', '')
        .trim();

    // Split the instructions by numbered points
    List<String> lines = cleanedInstructions.split('\n\n');
    List<String> instructions = [];

    for (String line in lines) {
      if (line.trim().isEmpty) continue;
      // Check if line starts with a number followed by a period
      if (RegExp(r'^\d+\.\s').hasMatch(line.trim())) {
        // Remove the number and add the instruction
        String instruction = line.trim().replaceFirst(RegExp(r'^\d+\.\s'), '');
        instructions.add(instruction);
      }
    }

    return instructions;
  }
}

class VisualAidMetadata {
  final String? topic;
  final String? visualType;
  final String? complexity;
  final bool? blackboardFriendly;

  VisualAidMetadata({
    this.topic,
    this.visualType,
    this.complexity,
    this.blackboardFriendly,
  });

  factory VisualAidMetadata.fromJson(Map<String, dynamic> json) {
    return VisualAidMetadata(
      topic: json['topic'],
      visualType: json['visual_type'],
      complexity: json['complexity'],
      blackboardFriendly: json['blackboard_friendly'],
    );
  }
}
