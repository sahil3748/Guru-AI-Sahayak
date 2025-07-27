import 'package:dio/dio.dart';
import '../api_service/api_service.dart';
import '../models/content_generation_response.dart';
import 'dart:io';
import 'package:http_parser/http_parser.dart';

class ContentGenerationService {
  final ApiService _apiService;

  ContentGenerationService(this._apiService);

  Future<ContentGenerationResponse> generateContent({
    required File file,
    required String contentType,
    required String outputFormat,
    required int researchDepth,
    required int contentLength,
    String localLanguage = 'english',
    String? userId,
  }) async {
    // Create form data
    FormData formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        file.path,
        filename: file.path.split('/').last,
        contentType: _getMediaType(file.path),
      ),
      'content_type': contentType.toLowerCase().replaceAll(' ', '_'),
      'output_format': outputFormat.toLowerCase().replaceAll(' ', '_'),
      'research_depth': researchDepth == 5
          ? "deep"
          : researchDepth == 4
          ? "detailed"
          : researchDepth == 3
          ? "moderate"
          : researchDepth == 2
          ? "basic"
          : "surface",
      'content_length': contentLength == 5
          ? "comprehensive"
          : contentLength == 4
          ? "detaied"
          : contentLength == 3
          ? "moderate"
          : contentLength == 2
          ? "brief"
          : "concise",
      'local_language': localLanguage,
      'user_id': userId ?? '',
    });

    try {
      print('Form Data:');
      formData.fields.forEach((field) {
        print('${field.key}: ${field.value}');
      });
      formData.files.forEach((file) {
        print('File field: ${file.key}, filename: ${file.value.filename}');
      });
      final response = await _apiService.post(
        ApiEndPoint.generateContent,
        data: formData,
      );

      return ContentGenerationResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Helper method to determine content type from file extension
  MediaType _getMediaType(String path) {
    final extension = path.split('.').last.toLowerCase();

    switch (extension) {
      case 'pdf':
        return MediaType('application', 'pdf');
      case 'doc':
      case 'docx':
        return MediaType('application', 'msword');
      case 'jpg':
      case 'jpeg':
        return MediaType('image', 'jpeg');
      case 'png':
        return MediaType('image', 'png');
      default:
        return MediaType('application', 'octet-stream');
    }
  }

  Exception _handleError(DioException e) {
    if (e.response != null) {
      return Exception(
        'Server error: ${e.response!.statusCode} - ${e.response!.data['message'] ?? e.message}',
      );
    } else if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return Exception(
        'Connection timeout. Please check your internet connection and try again.',
      );
    } else {
      return Exception('An error occurred: ${e.message}');
    }
  }
}
