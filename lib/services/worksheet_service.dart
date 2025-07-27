import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api_service/api_service.dart';
import 'package:flutter/material.dart';

class WorksheetService {
  final ApiService _apiService;

  WorksheetService() : _apiService = ApiService();

  /// Generates a worksheet using the API
  Future<Map<String, dynamic>> generateWorksheet({
    required String subject,
    required String grade,
    required String topic,
    required String worksheetType,
    required int numQuestions,
    required String title,
    required bool includeAnswers,
    String language = 'english',
  }) async {
    try {
      // Prepare request data
      Map<String, dynamic> requestData = {
        'subject': subject,
        'grade': grade,
        'topic': topic,
        'worksheet_type':
            worksheetType, // short_answers, multiple_choice, fill_in_blanks
        'num_questions': numQuestions,
        'title': title,
        'include_answers': includeAnswers,
        'language': language,
      };

      // Get user ID from SharedPreferences if available
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String apiEssentialId = prefs.getString('api_essential_id') ?? '';
      if (apiEssentialId.isNotEmpty) {
        requestData['user_id'] = apiEssentialId;
      }

      debugPrint('Sending worksheet generation request: $requestData');

      // Make API request
      final response = await _apiService.post(
        '/worksheets/generate',
        data: {'request': requestData},
      );

      if (response.statusCode == 200) {
        debugPrint('Worksheet generated successfully');
        return response.data;
      } else {
        return {
          'success': false,
          'error': 'Server error: ${response.statusCode}',
          'message': response.data['message'] ?? 'Unknown error occurred',
        };
      }
    } on DioException catch (e) {
      debugPrint('API Error: ${e.message}');
      return {
        'success': false,
        'error': 'Network error',
        'message': _handleDioError(e),
      };
    } catch (e) {
      debugPrint('Unexpected error: $e');
      return {
        'success': false,
        'error': 'Unexpected error',
        'message': 'An unexpected error occurred. Please try again.',
      };
    }
  }

  /// Handle Dio exceptions and return user-friendly messages
  String _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout. Please check your internet connection.';
      case DioExceptionType.sendTimeout:
        return 'Request timeout. Please try again.';
      case DioExceptionType.receiveTimeout:
        return 'Response timeout. Please try again.';
      case DioExceptionType.badResponse:
        if (e.response?.statusCode == 429) {
          return 'Too many requests. Please try again later.';
        }
        return 'Server error. Please try again later.';
      case DioExceptionType.cancel:
        return 'Request was cancelled.';
      default:
        return 'Network error. Please check your connection and try again.';
    }
  }
}
