import 'package:flutter/material.dart';

class ContentProcessingWidget extends StatelessWidget {
  final bool isLoading;
  final String? content;

  const ContentProcessingWidget({
    Key? key,
    required this.isLoading,
    this.content,
  }) : super(key: key);

  Widget _buildFormattedContent(String content) {
    // Check if it's a Q&A format
    if (content.contains('Q1:') || content.contains('Q:')) {
      // Parse Q&A format
      return _buildQAFormat(content);
    }
    // Check if it's bullet points format
    else if (content.contains('• ') ||
        content.contains('- ') ||
        content.contains('* ')) {
      return _buildBulletPoints(content);
    }
    // Default to regular text
    return Text(content, style: const TextStyle(fontSize: 16));
  }

  Widget _buildQAFormat(String content) {
    final List<Widget> qaWidgets = [];
    final RegExp questionPattern = RegExp(r'Q\d*:?|Question\s*\d*:?');

    final questions = content.split(questionPattern);

    // First item might be empty if the content starts with a Q pattern
    if (questions.isNotEmpty && questions[0].trim().isEmpty) {
      questions.removeAt(0);
    }

    int index = 1;
    for (final question in questions) {
      if (question.trim().isEmpty) continue;

      // Split to separate answer from question
      final parts = question.split(RegExp(r'A\d*:?|Answer\s*\d*:?'));
      final questionText = parts[0].trim();
      final answerText = parts.length > 1 ? parts[1].trim() : '';

      qaWidgets.add(
        Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Q$index: $questionText',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'A$index: $answerText',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      );
      index++;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: qaWidgets,
    );
  }

  Widget _buildBulletPoints(String content) {
    final List<Widget> bulletWidgets = [];
    final lines = content.split('\n');

    for (final line in lines) {
      final trimmedLine = line.trim();
      if (trimmedLine.startsWith('• ') ||
          trimmedLine.startsWith('- ') ||
          trimmedLine.startsWith('* ')) {
        final bulletText = trimmedLine.substring(2).trim();
        bulletWidgets.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '•',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(bulletText, style: const TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
        );
      } else if (trimmedLine.isNotEmpty) {
        // Regular text paragraph
        bulletWidgets.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(trimmedLine, style: const TextStyle(fontSize: 16)),
          ),
        );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: bulletWidgets,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Processing content...', style: TextStyle(fontSize: 16)),
          ],
        ),
      );
    }

    if (content == null) {
      return const Center(
        child: Text(
          'Upload a file or image to get started',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Generated Content:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: _buildFormattedContent(content!),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
