# Guru AI Sahayak

An AI-powered educational assistant Flutter application that provides hyper-local content generation for personalized learning experiences.

## Features

### 🎯 Hyper-Local Content Generator
- **Subject-Based Learning**: Support for Mathematics, Science, English, Hindi, Social Studies, and Computer Science
- **Grade-Level Customization**: Content tailored for grades 1-12
- **Content Type Variety**: Worksheets, quizzes, assignments, practice problems, and study materials
- **Multi-Language Support**: Content generation in Hindi, English, Marathi, Gujarati, Telugu, Tamil, Bengali, and Punjabi
- **Location-Based Context**: Incorporating local examples, cultural context, and regional dialects
- **Real-time API Integration**: Dynamic content generation using AI services

### 🔧 Technical Features
- **Responsive Design**: Built with Sizer package for cross-platform compatibility
- **Modern UI/UX**: Material Design 3 components with custom theming
- **API Integration**: RESTful API calls using Dio HTTP client
- **Error Handling**: Comprehensive error handling and user feedback
- **Navigation**: Intuitive step-by-step wizard interface

## API Integration

### Hyper-Local Content Generation API

The application integrates with a backend AI service to generate hyper-local educational content.

#### Endpoint
```
POST /ai/generate-hyperlocal-content
```

#### Request Format
```json
{
  "subject": "Mathematics",
  "grade": 5,
  "topic": "Fractions",
  "content_type": "Worksheet",
  "language": "Hindi",
  "location": "Mumbai",
  "include_local_examples": true,
  "include_cultural_context": true,
  "include_local_dialect": false
}
```

#### Response Format
```json
{
  "success": true,
  "message": "Content generated successfully",
  "data": {
    "content": [
      {
        "content": "Generated educational content text",
        "type": "Question",
        "local_element": "Local market example",
        "cultural_context": "Regional festival context"
      }
    ],
    "metadata": {
      "generated_at": "2024-01-15T10:30:00Z",
      "content_id": "abc123",
      "language": "Hindi",
      "grade": 5
    }
  }
}
```

#### Error Handling
The API service handles various error scenarios:
- Network connectivity issues
- API server errors (500, 503)
- Invalid request data (400)
- Authentication failures (401)
- Rate limiting (429)

### API Service Implementation

#### HyperLocalContentService
Located at: `lib/api_service/hyperlocal_content_service.dart`

Key features:
- **Input Validation**: Validates all required parameters before API calls
- **Error Handling**: Comprehensive error catching and user-friendly error messages
- **Timeout Management**: 30-second timeout for content generation requests
- **Response Parsing**: Automatic JSON response parsing and validation

#### Usage Example
```dart
final contentService = HyperLocalContentService();

try {
  final response = await contentService.generateHyperLocalContent(
    subject: 'Mathematics',
    grade: 5,
    topic: 'Fractions',
    contentType: 'Worksheet',
    language: 'Hindi',
    location: 'Mumbai',
    includeLocalExamples: true,
    includeCulturalContext: true,
    includeLocalDialect: false,
  );
  
  // Handle successful response
  print('Generated content: ${response['content']}');
} catch (e) {
  // Handle error
  print('Error: $e');
}
```

## Project Structure

```
lib/
├── api_service/
│   ├── api_service.dart              # Base HTTP service
│   └── hyperlocal_content_service.dart  # Hyper-local content API service
├── core/
│   └── app_export.dart               # Core exports and themes
├── presentation/
│   └── hyperlocal_content_generator/
│       ├── hyperlocal_content_generator.dart  # Main generator screen
│       └── widgets/                  # UI component widgets
│           ├── additional_options_section.dart
│           ├── content_type_card.dart
│           ├── generation_progress_dialog.dart
│           ├── grade_level_picker.dart
│           ├── language_selector.dart
│           ├── location_input_field.dart
│           ├── progress_indicator_widget.dart
│           ├── subject_selection_card.dart
│           └── topic_input_field.dart
├── routes/
├── services/
├── theme/
└── main.dart
```

## Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  sizer: ^2.0.15          # Responsive design
  dio: ^5.x.x             # HTTP client for API calls
  # ... other dependencies
```

## Getting Started

### Prerequisites
- Flutter SDK (3.0 or higher)
- Dart SDK (3.0 or higher)
- Android Studio / VS Code
- API server running on configured base URL

### Installation
1. Clone the repository
```bash
git clone <repository-url>
cd guru-ai-sahayak
```

2. Install dependencies
```bash
flutter pub get
```

3. Configure API base URL in `lib/api_service/api_service.dart`
```dart
class ApiService {
  static const String baseUrl = 'YOUR_API_BASE_URL';
  // ...
}
```

4. Run the application
```bash
flutter run
```

### API Configuration
Update the base URL in `api_service.dart` to point to your backend server:
```dart
BaseOptions(
  baseUrl: 'https://your-api-server.com/api',
  connectTimeout: const Duration(seconds: 10),
  receiveTimeout: const Duration(seconds: 10),
)
```

## Usage

### Accessing Hyper-Local Content Generator
1. Navigate to Teacher Dashboard
2. Tap on "Generate Hyper-Local Content" card
3. Follow the 6-step wizard:
   - **Step 1**: Select Subject
   - **Step 2**: Choose Grade Level
   - **Step 3**: Enter Topic
   - **Step 4**: Select Content Type
   - **Step 5**: Choose Language and Location
   - **Step 6**: Configure Additional Options
4. Generate content and preview results
5. Download generated content

### Content Generation Process
1. User completes the wizard with their preferences
2. Application validates input data
3. API request is sent to the backend service
4. Progress dialog shows generation status
5. Generated content is displayed in preview
6. User can download the content in text format

## API Response Handling

### Success Response
```dart
if (response.statusCode == 200) {
  final data = response.data;
  if (data['success'] == true) {
    return data['data'];
  }
}
```

### Error Response
```dart
catch (DioException e) {
  if (e.response?.statusCode == 400) {
    throw Exception('Invalid request parameters');
  } else if (e.response?.statusCode == 500) {
    throw Exception('Server error occurred');
  }
  // ... handle other error codes
}
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support and questions:
- Create an issue in the repository
- Contact the development team
- Check the documentation

---

Built with ❤️ using Flutter
