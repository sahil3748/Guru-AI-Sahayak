import 'package:flutter/material.dart';
import 'content_generation_settings.dart';

class GenerationPreviewDialog extends StatelessWidget {
  final ContentGenerationOptions options;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const GenerationPreviewDialog({
    Key? key,
    required this.options,
    required this.onConfirm,
    required this.onCancel,
  }) : super(key: key);

  String _getResearchDepthLabel(int depth) {
    return ['Surface', 'Basic', 'Moderate', 'Detailed', 'Deep'][depth - 1];
  }

  String _getContentLengthLabel(int length) {
    return [
      'Concise',
      'Brief',
      'Moderate',
      'Detailed',
      'Comprehensive',
    ][length - 1];
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirm Generation Settings'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSection('Content Type', [options.contentType]),
            const SizedBox(height: 16),
            _buildSection('Research Depth', [
              _getResearchDepthLabel(options.researchDepth),
            ]),
            const SizedBox(height: 16),
            _buildSection('Content Length', [
              _getContentLengthLabel(options.contentLength),
            ]),
            const SizedBox(height: 16),
            _buildSection('Output Format', [options.outputFormat]),
            const SizedBox(height: 16),
            _buildSection('Language', [
              options.language.substring(0, 1).toUpperCase() +
                  options.language.substring(1),
            ]),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: onCancel, child: const Text('Adjust Settings')),
        ElevatedButton(
          onPressed: onConfirm,
          child: const Text('Generate Content'),
        ),
      ],
    );
  }

  Widget _buildSection(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 4),
            child: Text(item),
          ),
        ),
      ],
    );
  }
}
