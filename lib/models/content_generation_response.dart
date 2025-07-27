class ContentGenerationResponse {
  final String content;
  final String language;
  final String contentType;
  final String outputFormat;
  final String sourceType;
  final String? additionalResources;
  final String? sessionId;
  final String? userId;

  ContentGenerationResponse({
    required this.content,
    required this.language,
    required this.contentType,
    required this.outputFormat,
    required this.sourceType,
    this.additionalResources,
    this.sessionId,
    this.userId,
  });

  factory ContentGenerationResponse.fromJson(Map<String, dynamic> json) {
    return ContentGenerationResponse(
      content: json['content'] ?? '',
      language: json['language'] ?? 'english',
      contentType: json['content_type'] ?? '',
      outputFormat: json['output_format'] ?? '',
      sourceType: json['source_type'] ?? '',
      additionalResources: json['additional_resources'],
      sessionId: json['session_id'],
      userId: json['user_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'language': language,
      'content_type': contentType,
      'output_format': outputFormat,
      'source_type': sourceType,
      'additional_resources': additionalResources,
      'session_id': sessionId,
      'user_id': userId,
    };
  }
}
