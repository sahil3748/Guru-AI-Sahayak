import 'package:flutter/material.dart';

class ContentGenerationOptions {
  final String contentType;
  final int researchDepth;
  final int contentLength;
  final String outputFormat;

  ContentGenerationOptions({
    required this.contentType,
    required this.researchDepth,
    required this.contentLength,
    required this.outputFormat,
  });
}

class ContentGenerationSettings extends StatefulWidget {
  final ContentGenerationOptions initialOptions;
  final Function(ContentGenerationOptions) onSettingsChanged;

  const ContentGenerationSettings({
    Key? key,
    required this.initialOptions,
    required this.onSettingsChanged,
  }) : super(key: key);

  @override
  State<ContentGenerationSettings> createState() => _ContentGenerationSettingsState();
}

class _ContentGenerationSettingsState extends State<ContentGenerationSettings> {
  late String _contentType;
  late int _researchDepth;
  late int _contentLength;
  late String _outputFormat;

  final List<String> _contentTypes = [
    'Detailed Content',
    'Summary',
    'Key Points',
    'Study Guide',
    'Practice Questions',
  ];

  final List<String> _outputFormats = [
    'Text',
    'Bullet Points',
    'Q&A Format',
    'Mind Map',
    'Flashcards',
  ];

  @override
  void initState() {
    super.initState();
    _contentType = widget.initialOptions.contentType;
    _researchDepth = widget.initialOptions.researchDepth;
    _contentLength = widget.initialOptions.contentLength;
    _outputFormat = widget.initialOptions.outputFormat;
  }

  void _updateSettings() {
    widget.onSettingsChanged(ContentGenerationOptions(
      contentType: _contentType,
      researchDepth: _researchDepth,
      contentLength: _contentLength,
      outputFormat: _outputFormat,
    ));
  }

  String _getResearchDepthLabel(int depth) {
    return ['Surface', 'Basic', 'Moderate', 'Detailed', 'Deep'][depth - 1];
  }

  String _getContentLengthLabel(int length) {
    return ['Concise', 'Brief', 'Moderate', 'Detailed', 'Comprehensive'][length - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Content Generation Settings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Content Type',
                border: OutlineInputBorder(),
              ),
              value: _contentType,
              items: _contentTypes.map((type) => DropdownMenuItem(
                value: type,
                child: Text(type),
              )).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _contentType = value;
                  });
                  _updateSettings();
                }
              },
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Research Depth: ${_getResearchDepthLabel(_researchDepth)}'),
                Slider(
                  value: _researchDepth.toDouble(),
                  min: 1,
                  max: 5,
                  divisions: 4,
                  label: _getResearchDepthLabel(_researchDepth),
                  onChanged: (value) {
                    setState(() {
                      _researchDepth = value.round();
                    });
                    _updateSettings();
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Content Length: ${_getContentLengthLabel(_contentLength)}'),
                Slider(
                  value: _contentLength.toDouble(),
                  min: 1,
                  max: 5,
                  divisions: 4,
                  label: _getContentLengthLabel(_contentLength),
                  onChanged: (value) {
                    setState(() {
                      _contentLength = value.round();
                    });
                    _updateSettings();
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Output Format',
                border: OutlineInputBorder(),
              ),
              value: _outputFormat,
              items: _outputFormats.map((format) => DropdownMenuItem(
                value: format,
                child: Text(format),
              )).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _outputFormat = value;
                  });
                  _updateSettings();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}