import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'widgets/content_processing_widget.dart';
import 'widgets/content_generation_settings.dart';
import 'widgets/generation_preview_dialog.dart';

class TextbookScannerScreen extends StatefulWidget {
  const TextbookScannerScreen({Key? key}) : super(key: key);

  @override
  _TextbookScannerScreenState createState() => _TextbookScannerScreenState();
}

class _TextbookScannerScreenState extends State<TextbookScannerScreen> {
  final ImagePicker _imagePicker = ImagePicker();
  String? _scannedContent;
  bool _isLoading = false;
  late ContentGenerationOptions _generationOptions;
  XFile? _selectedImage;
  FilePickerResult? _selectedFile;

  @override
  void initState() {
    super.initState();
    _generationOptions = ContentGenerationOptions(
      contentType: 'Detailed Content',
      researchDepth: 3,
      contentLength: 3,
      outputFormat: 'Text',
      language: 'English',
    );
  }

  Future<void> _processContent() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Implement actual content processing logic here
      await Future.delayed(const Duration(seconds: 2)); // Simulated processing

      setState(() {
        _scannedContent =
            '''Generation Settings:
- Content Type: ${_generationOptions.contentType}
- Research Depth: ${['Surface', 'Basic', 'Moderate', 'Detailed', 'Deep'][_generationOptions.researchDepth - 1]}
- Content Length: ${['Concise', 'Brief', 'Moderate', 'Detailed', 'Comprehensive'][_generationOptions.contentLength - 1]}
- Output Format: ${_generationOptions.outputFormat}

Source: ${_selectedImage != null
                ? 'Image - ${_selectedImage!.path}'
                : _selectedFile != null
                ? 'File - ${_selectedFile!.files.first.name}'
                : 'None'}

Processing will begin with these settings...''';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error processing content: $e')));
    }
  }

  void _handleSettingsChanged(ContentGenerationOptions options) {
    setState(() {
      _generationOptions = options;
    });
  }

  Future<void> _showGenerationPreview() async {
    return showDialog(
      context: context,
      builder: (context) => GenerationPreviewDialog(
        options: _generationOptions,
        onConfirm: () {
          Navigator.of(context).pop();
          _processContent();
        },
        onCancel: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }

  Future<void> _scanContent() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Implement actual content processing logic here
      await Future.delayed(const Duration(seconds: 2)); // Simulated processing

      setState(() {
        _scannedContent =
            'Generated ${_generationOptions.contentType}\n' +
            'For: ${_generationOptions.contentType}\n' +
            'Complexity Level: ${_generationOptions.researchDepth}\n' +
            'Including: ${_generationOptions.contentLength}\n\n' +
            'Content will be processed according to these preferences\n\n' +
            (_selectedImage != null
                ? 'Processing image: ${_selectedImage!.path}'
                : _selectedFile != null
                ? 'Processing file: ${_selectedFile!.files.first.name}'
                : '');
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error processing content: $e')));
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
      );
      if (image != null) {
        setState(() {
          _selectedImage = image;
          _selectedFile = null;
        });
        _showGenerationPreview();
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error picking image: $e')));
    }
  }

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
      );

      if (result != null) {
        setState(() {
          _selectedFile = result;
          _selectedImage = null;
        });
        _showGenerationPreview();
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error picking file: $e')));
    }
  }

  Widget _buildSourceOption({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onPressed,
    required bool isSelected,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).primaryColor.withOpacity(0.1)
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).primaryColor
                : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 36,
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : Colors.grey.shade700,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Textbook Scanner')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Upload a textbook page or document',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ContentGenerationSettings(
                onSettingsChanged: _handleSettingsChanged,
                initialOptions: _generationOptions,
              ),
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Select Content Source',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: _buildSourceOption(
                              context: context,
                              icon: Icons.image,
                              title: 'Image',
                              subtitle: 'Upload photos of textbook pages',
                              onPressed: _pickImage,
                              isSelected: _selectedImage != null,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildSourceOption(
                              context: context,
                              icon: Icons.upload_file,
                              title: 'Document',
                              subtitle: 'Upload PDF, DOC, or DOCX files',
                              onPressed: _pickFile,
                              isSelected: _selectedFile != null,
                            ),
                          ),
                        ],
                      ),
                      if (_selectedImage != null || _selectedFile != null) ...[
                        const SizedBox(height: 16),
                        Text(
                          'Selected: ${_selectedImage?.path ?? _selectedFile?.files.first.name}',
                          style: const TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              if (_isLoading || _scannedContent != null)
                Container(
                  height: 300,
                  child: ContentProcessingWidget(
                    isLoading: _isLoading,
                    content: _scannedContent,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
