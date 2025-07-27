import 'package:flutter/material.dart';

class ContentGenerationOptions {
  final String contentType;
  final int researchDepth;
  final int contentLength;
  final String outputFormat;
  final String language;

  ContentGenerationOptions({
    required this.contentType,
    required this.researchDepth,
    required this.contentLength,
    required this.outputFormat,
    required this.language,
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
  State<ContentGenerationSettings> createState() =>
      _ContentGenerationSettingsState();
}

class _ContentGenerationSettingsState extends State<ContentGenerationSettings> {
  late String _contentType;
  late int _researchDepth;
  late int _contentLength;
  late String _outputFormat;
  late String _language;

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

  final List<String> _languages = [
    'English',
    'Hindi',
    'Spanish',
    'French',
    'German',
    'Chinese',
    'Japanese',
    'Arabic',
    'Russian',
  ];

  @override
  void initState() {
    super.initState();
    _contentType = widget.initialOptions.contentType;
    _researchDepth = widget.initialOptions.researchDepth;
    _contentLength = widget.initialOptions.contentLength;
    _outputFormat = widget.initialOptions.outputFormat;
    _language = widget.initialOptions.language;
  }

  void _updateSettings() {
    widget.onSettingsChanged(
      ContentGenerationOptions(
        contentType: _contentType,
        researchDepth: _researchDepth,
        contentLength: _contentLength,
        outputFormat: _outputFormat,
        language: _language,
      ),
    );
  }

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
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.settings,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Content Generation Settings',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(height: 30),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Content Type',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.article),
              ),
              value: _contentType,
              items: _contentTypes
                  .map(
                    (type) => DropdownMenuItem(value: type, child: Text(type)),
                  )
                  .toList(),
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
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.psychology, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Research Depth: ${_getResearchDepthLabel(_researchDepth)}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: Theme.of(context).primaryColor,
                      thumbColor: Theme.of(context).primaryColor,
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 12,
                      ),
                      overlayShape: const RoundSliderOverlayShape(
                        overlayRadius: 20,
                      ),
                    ),
                    child: Slider(
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
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Surface', style: TextStyle(fontSize: 12)),
                      const Text('Deep', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.text_fields, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Content Length: ${_getContentLengthLabel(_contentLength)}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: Theme.of(context).primaryColor,
                      thumbColor: Theme.of(context).primaryColor,
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 12,
                      ),
                      overlayShape: const RoundSliderOverlayShape(
                        overlayRadius: 20,
                      ),
                    ),
                    child: Slider(
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
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Concise', style: TextStyle(fontSize: 12)),
                      const Text(
                        'Comprehensive',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Output Format',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.format_align_left),
              ),
              value: _outputFormat,
              items: _outputFormats
                  .map(
                    (format) =>
                        DropdownMenuItem(value: format, child: Text(format)),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _outputFormat = value;
                  });
                  _updateSettings();
                }
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Language',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.language),
              ),
              value: _language,
              items: _languages
                  .map(
                    (lang) => DropdownMenuItem(value: lang, child: Text(lang)),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _language = value;
                  });
                  _updateSettings();
                }
              },
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade100),
              ),
              child: Row(
                children: [
                  const Icon(Icons.tips_and_updates, color: Colors.blue),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Tip: Adjust settings to customize your learning experience',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Your changes are applied automatically. Different combinations work best for different learning goals.',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
