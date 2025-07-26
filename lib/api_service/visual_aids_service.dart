import 'package:guru_ai/api_service/api_service.dart';
import 'package:guru_ai/models/visual_aids_response.dart';

class VisualAidsService {
  final ApiService _apiService;

  VisualAidsService() : _apiService = ApiService();

  Future<VisualAidsResponse> generateVisualAid({
    required String description,
    required String subject,
  }) async {
    try {
      final response = await _apiService.post(
        ApiEndPoint.generateVisualAids,
        data: {
          'description': description,
          'subject': _formatSubjectForApi(subject),
        },
      );

      return VisualAidsResponse.fromJson(response.data);
    } catch (e) {
      print('Error generating visual aid: $e');
      rethrow;
    }
  }

  // Helper method to convert UI-friendly subject names to API format
  String _formatSubjectForApi(String subject) {
    // Convert spaces to underscores and make lowercase
    switch (subject.toLowerCase()) {
      case 'science':
        return 'science';
      case 'mathematics':
        return 'mathematics';
      case 'history':
        return 'history';
      case 'geography':
        return 'geography';
      case 'biology':
        return 'biology';
      case 'social studies':
        return 'social_studies';
      default:
        return subject.toLowerCase().replaceAll(' ', '_');
    }
  }
}
