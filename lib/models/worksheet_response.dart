class WorksheetResponse {
  final bool success;
  final String pdfUrl;
  final String worksheetType;
  final String subject;
  final String grade;
  final String topic;
  final String title;
  final int questionCount;
  final String? sessionId;
  final String? errorMessage;

  WorksheetResponse({
    required this.success,
    required this.pdfUrl,
    required this.worksheetType,
    required this.subject,
    required this.grade,
    required this.topic,
    required this.title,
    required this.questionCount,
    this.sessionId,
    this.errorMessage,
  });

  factory WorksheetResponse.fromJson(Map<String, dynamic> json) {
    // Check if this is an error response
    if (json.containsKey('success') && json['success'] == false) {
      return WorksheetResponse(
        success: false,
        pdfUrl: '',
        worksheetType: '',
        subject: '',
        grade: '',
        topic: '',
        title: '',
        questionCount: 0,
        errorMessage: json['message'] ?? 'Unknown error occurred',
      );
    }

    // Otherwise parse as a success response
    return WorksheetResponse(
      success: true,
      pdfUrl: json['pdf_url'] ?? '',
      worksheetType: json['worksheet_type'] ?? '',
      subject: json['subject'] ?? '',
      grade: json['grade'] ?? '',
      topic: json['topic'] ?? '',
      title: json['title'] ?? '',
      questionCount: json['question_count'] ?? 0,
      sessionId: json['session_id'],
    );
  }

  // Return the full PDF URL with base URL
  String getFullPdfUrl() {
    // Check if the URL is already absolute
    if (pdfUrl.startsWith('http://') || pdfUrl.startsWith('https://')) {
      return pdfUrl;
    }

    // Otherwise append to the base URL
    const String baseUrl =
        'https://backend-infra-200499489667.us-central1.run.app';
    return '$baseUrl$pdfUrl';
  }
}
