import 'dart:io' if (dart.library.io) 'dart:io';

import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AttachmentSectionWidget extends StatefulWidget {
  final List<Map<String, dynamic>> attachments;
  final Function(Map<String, dynamic>) onAttachmentAdded;
  final Function(int) onAttachmentRemoved;

  const AttachmentSectionWidget({
    super.key,
    required this.attachments,
    required this.onAttachmentAdded,
    required this.onAttachmentRemoved,
  });

  @override
  State<AttachmentSectionWidget> createState() =>
      _AttachmentSectionWidgetState();
}

class _AttachmentSectionWidgetState extends State<AttachmentSectionWidget> {
  List<CameraDescription>? _cameras;
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  bool _showCamera = false;
  final ImagePicker _imagePicker = ImagePicker();
  final TextEditingController _linkController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _linkController.dispose();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    try {
      if (!await _requestCameraPermission()) return;

      _cameras = await availableCameras();
      if (_cameras!.isEmpty) return;

      final camera = kIsWeb
          ? _cameras!.firstWhere(
              (c) => c.lensDirection == CameraLensDirection.front,
              orElse: () => _cameras!.first)
          : _cameras!.firstWhere(
              (c) => c.lensDirection == CameraLensDirection.back,
              orElse: () => _cameras!.first);

      _cameraController = CameraController(
        camera,
        kIsWeb ? ResolutionPreset.medium : ResolutionPreset.high,
      );

      await _cameraController!.initialize();
      await _applySettings();

      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      debugPrint('Camera initialization error: $e');
    }
  }

  Future<bool> _requestCameraPermission() async {
    if (kIsWeb) return true;
    return (await Permission.camera.request()).isGranted;
  }

  Future<void> _applySettings() async {
    if (_cameraController == null) return;

    try {
      await _cameraController!.setFocusMode(FocusMode.auto);
      if (!kIsWeb) {
        await _cameraController!.setFlashMode(FlashMode.auto);
      }
    } catch (e) {
      debugPrint('Camera settings error: $e');
    }
  }

  Future<void> _capturePhoto() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    try {
      final XFile photo = await _cameraController!.takePicture();
      final bytes = await photo.readAsBytes();

      widget.onAttachmentAdded({
        'type': 'image',
        'name': 'Camera_${DateTime.now().millisecondsSinceEpoch}.jpg',
        'path': photo.path,
        'bytes': bytes,
        'size': bytes.length,
      });

      setState(() {
        _showCamera = false;
      });
    } catch (e) {
      debugPrint('Photo capture error: $e');
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final List<XFile> images = await _imagePicker.pickMultiImage();

      for (final image in images) {
        final bytes = await image.readAsBytes();
        widget.onAttachmentAdded({
          'type': 'image',
          'name': image.name,
          'path': image.path,
          'bytes': bytes,
          'size': bytes.length,
        });
      }
    } catch (e) {
      debugPrint('Gallery picker error: $e');
    }
  }

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'txt'],
        allowMultiple: true,
      );

      if (result != null) {
        for (final file in result.files) {
          final bytes =
              kIsWeb ? file.bytes! : await File(file.path!).readAsBytes();
          widget.onAttachmentAdded({
            'type': 'file',
            'name': file.name,
            'path': file.path,
            'bytes': bytes,
            'size': file.size,
          });
        }
      }
    } catch (e) {
      debugPrint('File picker error: $e');
    }
  }

  void _addLink() {
    if (_linkController.text.trim().isNotEmpty) {
      widget.onAttachmentAdded({
        'type': 'link',
        'name': _linkController.text.trim(),
        'url': _linkController.text.trim(),
        'size': 0,
      });
      _linkController.clear();
      Navigator.pop(context);
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '${bytes}B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)}KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)}MB';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Attachments',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),

        // Attachment buttons
        Row(
          children: [
            Expanded(
              child: _buildAttachmentButton(
                'Camera',
                'camera_alt',
                AppTheme.primaryBlue,
                () {
                  if (_isCameraInitialized) {
                    setState(() {
                      _showCamera = true;
                    });
                  }
                },
              ),
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: _buildAttachmentButton(
                'Gallery',
                'photo_library',
                AppTheme.successGreen,
                _pickFromGallery,
              ),
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: _buildAttachmentButton(
                'Files',
                'attach_file',
                AppTheme.warningYellow,
                _pickFile,
              ),
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: _buildAttachmentButton(
                'Link',
                'link',
                AppTheme.alertRed,
                () => _showLinkDialog(),
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),

        // Camera preview
        _showCamera && _isCameraInitialized
            ? _buildCameraPreview()
            : const SizedBox.shrink(),

        // Attachments list
        widget.attachments.isNotEmpty
            ? _buildAttachmentsList()
            : const SizedBox.shrink(),
      ],
    );
  }

  Widget _buildAttachmentButton(
      String label, String iconName, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 1.5.h),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          border: Border.all(color: color),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            CustomIconWidget(
              iconName: iconName,
              color: color,
              size: 24,
            ),
            SizedBox(height: 0.5.h),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCameraPreview() {
    return Container(
      height: 40.h,
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 2.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.outlineLight),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            CameraPreview(_cameraController!),
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FloatingActionButton(
                    heroTag: "close_camera",
                    onPressed: () {
                      setState(() {
                        _showCamera = false;
                      });
                    },
                    backgroundColor: AppTheme.alertRed,
                    child: CustomIconWidget(
                      iconName: 'close',
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  FloatingActionButton(
                    heroTag: "capture_photo",
                    onPressed: _capturePhoto,
                    backgroundColor: AppTheme.primaryBlue,
                    child: CustomIconWidget(
                      iconName: 'camera_alt',
                      color: Colors.white,
                      size: 24,
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

  Widget _buildAttachmentsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Added Attachments (${widget.attachments.length})',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.h),
        SizedBox(
          height: 12.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: widget.attachments.length,
            separatorBuilder: (context, index) => SizedBox(width: 2.w),
            itemBuilder: (context, index) {
              final attachment = widget.attachments[index];
              return _buildAttachmentCard(attachment, index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAttachmentCard(Map<String, dynamic> attachment, int index) {
    final type = attachment['type'] as String;
    final name = attachment['name'] as String;
    final size = attachment['size'] as int;

    Color cardColor;
    String iconName;

    switch (type) {
      case 'image':
        cardColor = AppTheme.successGreen;
        iconName = 'image';
        break;
      case 'file':
        cardColor = AppTheme.warningYellow;
        iconName = 'description';
        break;
      case 'link':
        cardColor = AppTheme.alertRed;
        iconName = 'link';
        break;
      default:
        cardColor = AppTheme.primaryBlue;
        iconName = 'attach_file';
    }

    return Container(
      width: 25.w,
      padding: EdgeInsets.all(2.w),
      decoration: BoxDecoration(
        color: cardColor.withValues(alpha: 0.1),
        border: Border.all(color: cardColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomIconWidget(
                iconName: iconName,
                color: cardColor,
                size: 20,
              ),
              InkWell(
                onTap: () => widget.onAttachmentRemoved(index),
                child: CustomIconWidget(
                  iconName: 'close',
                  color: AppTheme.alertRed,
                  size: 16,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            name.length > 15 ? '${name.substring(0, 15)}...' : name,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (size > 0) ...[
            SizedBox(height: 0.5.h),
            Text(
              _formatFileSize(size),
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.onSurfaceSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showLinkDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Link'),
        content: TextField(
          controller: _linkController,
          decoration: const InputDecoration(
            hintText: 'Enter URL',
            prefixIcon: Icon(Icons.link),
          ),
          keyboardType: TextInputType.url,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: _addLink,
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
