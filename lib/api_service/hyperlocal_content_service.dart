import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';

class HyperLocalContentService {
  final ApiService _apiService = ApiService();

  /// Generates hyperlocal content based on user selections
  Future<Map<String, dynamic>> generateHyperLocalContent({
    required String subject,
    required int grade,
    required String topic,
    required String contentType,
    required String language,
    required String location,
    required bool includeLocalExamples,
    required bool includeCulturalContext,
    required bool includeLocalDialect,
  }) async {
    try {
      final requestData = {
        'subject': subject.toLowerCase().replaceAll(' ', '_'),
        'grade_levels': [grade],
        'topic': topic,
        'content_type': contentType.toLowerCase().replaceAll(' ', '_'),
        'language': language.toLowerCase(),
        'location': location,
        'include_local_examples': includeLocalExamples,
        'include_cultural_context': includeCulturalContext,
        'include_local_dialect': includeLocalDialect,
        'timestamp': DateTime.now().toIso8601String(),
      };

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String apiEssentialId = prefs.getString('api_essential_id') ?? '';

      requestData['user_id'] = apiEssentialId;

      print('Sending hyperlocal content request: $requestData');

      final response = await _apiService.post(
        ApiEndPoint.generateHyperLocalContent,
        data: requestData,
      );

      if (response.statusCode == 200) {
        // For our new API format
        if (response.data['status'] == 'success') {
          // Specifically handle the new API response format
          return {
            'success': true,
            'data': response.data,
            'content': response.data['content_pieces'] ?? [],
            'metadata': {
              'topic':
                  response.data['metadata']['topic'] ??
                  topic.toLowerCase().replaceAll(' ', '_'),
              'content_type':
                  response.data['metadata']['content_type'] ?? contentType,
              'difficulty_level':
                  response.data['metadata']['difficulty_level'] ?? 'medium',
              'piece_count': response.data['content_pieces']?.length ?? 0,
              'language': response.data['language'] ?? language,
              'location': response.data['location'] ?? location,
              'subject': response.data['subject'] ?? subject,
              'grade_levels': response.data['grade_levels'] ?? [grade],
              'cultural_elements_used':
                  response.data['cultural_elements_used'] ?? [],
              'local_references': response.data['local_references'] ?? [],
            },
            'questions': response.data['questions'] ?? [],
          };
        }
        // For backward compatibility with old API format
        else {
          return {
            'success': true,
            'data': response.data,
            'content': response.data['content'] ?? [],
            'metadata': response.data['metadata'] ?? {},
          };
        }
      } else {
        return {
          'success': false,
          'error': 'Server error: ${response.statusCode}',
          'message': response.data['message'] ?? 'Unknown error occurred',
          'error_code': response.statusCode,
        };
      }
    } on DioException catch (e) {
      print('API Error: ${e.message}');
      return {
        'success': false,
        'error': 'Network error',
        'message': _handleDioError(e),
      };
    } catch (e) {
      print('Unexpected error: $e');
      return {
        'success': false,
        'error': 'Unexpected error',
        'message': 'An unexpected error occurred. Please try again.',
      };
    }
  }

  /// Handles Dio exceptions and returns user-friendly messages
  String _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout. Please check your internet connection.';
      case DioExceptionType.sendTimeout:
        return 'Request timeout. Please try again.';
      case DioExceptionType.receiveTimeout:
        return 'Response timeout. Please try again.';
      case DioExceptionType.badResponse:
        return 'Server error. Please try again later.';
      case DioExceptionType.cancel:
        return 'Request was cancelled.';
      case DioExceptionType.connectionError:
        return 'No internet connection. Please check your connection.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }

  /// Validates user input before API call
  Map<String, dynamic> validateInput({
    required String subject,
    required int grade,
    required String topic,
    required String contentType,
    required String language,
    required String location,
  }) {
    List<String> errors = [];

    if (subject.isEmpty) errors.add('Subject is required');
    if (grade < 3 || grade > 8) errors.add('Grade must be between 3 and 8');
    if (topic.isEmpty) errors.add('Topic is required');
    if (contentType.isEmpty) errors.add('Content type is required');
    if (language.isEmpty) errors.add('Language is required');
    if (location.isEmpty) errors.add('Location is required');

    return {'isValid': errors.isEmpty, 'errors': errors};
  }

  /// Gets supported languages for the service
  List<Map<String, String>> getSupportedLanguages() {
    return [
      {'name': 'Hindi', 'code': 'hi', 'icon': '🇮🇳'},
      {'name': 'English', 'code': 'en', 'icon': '🇬🇧'},
      {'name': 'Bengali', 'code': 'bn', 'icon': '🇧🇩'},
      {'name': 'Tamil', 'code': 'ta', 'icon': '🏴'},
      {'name': 'Telugu', 'code': 'te', 'icon': '🏴'},
      {'name': 'Marathi', 'code': 'mr', 'icon': '🏴'},
      {'name': 'Gujarati', 'code': 'gu', 'icon': '🏴'},
      {'name': 'Punjabi', 'code': 'pa', 'icon': '🏴'},
    ];
  }

  /// Gets supported content types
  List<Map<String, String>> getSupportedContentTypes() {
    return [
      {
        'type': 'Stories & Narratives',
        'description': 'Local stories with regional characters and settings',
        'example': 'Story about local farmer using traditional methods',
        'icon': 'auto_stories',
      },
      {
        'type': 'Word Problems',
        'description': 'Math problems using local context and currency',
        'example': 'Calculate profit from selling mangoes in local market',
        'icon': 'calculate',
      },
      {
        'type': 'Reading Comprehension',
        'description': 'Passages about local culture and traditions',
        'example': 'Reading about local festivals and traditions',
        'icon': 'menu_book',
      },
      {
        'type': 'Activity Instructions',
        'description': 'Hands-on activities using local materials',
        'example': 'Science experiment using local plants and materials',
        'icon': 'science',
      },
    ];
  }
}
