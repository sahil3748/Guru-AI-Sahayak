import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:record/record.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ChatInputWidget extends StatefulWidget {
  final Function(String) onSendMessage;
  final Function(String) onSendImage;
  final Function(String) onSendVoice;

  const ChatInputWidget({
    Key? key,
    required this.onSendMessage,
    required this.onSendImage,
    required this.onSendVoice,
  }) : super(key: key);

  @override
  State<ChatInputWidget> createState() => _ChatInputWidgetState();
}

class _ChatInputWidgetState extends State<ChatInputWidget> {
  final TextEditingController _textController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  // final AudioRecorder _audioRecorder = AudioRecorder();

  List<CameraDescription> _cameras = [];
  CameraController? _cameraController;
  bool _isRecording = false;
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _textController.dispose();
    _cameraController?.dispose();
    // _audioRecorder.dispose();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    try {
      if (await _requestCameraPermission()) {
        _cameras = await availableCameras();
        if (_cameras.isNotEmpty) {
          final camera = kIsWeb
              ? _cameras.firstWhere(
                  (c) => c.lensDirection == CameraLensDirection.front,
                  orElse: () => _cameras.first)
              : _cameras.firstWhere(
                  (c) => c.lensDirection == CameraLensDirection.back,
                  orElse: () => _cameras.first);

          _cameraController = CameraController(
              camera, kIsWeb ? ResolutionPreset.medium : ResolutionPreset.high);

          await _cameraController!.initialize();
          await _applySettings();

          if (mounted) {
            setState(() {
              _isCameraInitialized = true;
            });
          }
        }
      }
    } catch (e) {
      // Silent fail - camera functionality will be disabled
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
    } catch (e) {
      // Ignore focus mode errors
    }

    if (!kIsWeb) {
      try {
        await _cameraController!.setFlashMode(FlashMode.auto);
      } catch (e) {
        // Ignore flash mode errors on unsupported devices
      }
    }
  }

  Future<void> _capturePhoto() async {
    if (_cameraController == null || !_isCameraInitialized) {
      await _pickImageFromGallery();
      return;
    }

    try {
      final XFile photo = await _cameraController!.takePicture();
      widget.onSendImage(photo.path);
    } catch (e) {
      await _pickImageFromGallery();
    }
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (image != null) {
        widget.onSendImage(image.path);
      }
    } catch (e) {
      // Silent fail
    }
  }

  Future<void> _toggleRecording() async {
    if (_isRecording) {
      await _stopRecording();
    } else {
      await _startRecording();
    }
  }

  Future<void> _startRecording() async {
    try {
      // if (await _audioRecorder.hasPermission()) {
      //   if (kIsWeb) {
      //     await _audioRecorder.start(
      //         const RecordConfig(encoder: AudioEncoder.wav),
      //         path: 'recording.wav');
      //   } else {
      //     await _audioRecorder.start(const RecordConfig(), path: 'recording.m4a');
      //   }

      //   setState(() {
      //     _isRecording = true;
      //   });
      // }
    } catch (e) {
      // Silent fail
    }
  }

  Future<void> _stopRecording() async {
    try {
      // final String? path = await _audioRecorder.stop();

      // setState(() {
      //   _isRecording = false;
      // });

      // if (path != null) {
      //   widget.onSendVoice(path);
      // }
    } catch (e) {
      setState(() {
        _isRecording = false;
      });
    }
  }

  void _sendTextMessage() {
    final text = _textController.text.trim();
    if (text.isNotEmpty) {
      widget.onSendMessage(text);
      _textController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.surfaceWhite,
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            GestureDetector(
              onTap: _capturePhoto,
              child: Container(
                width: 10.w,
                height: 10.w,
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(5.w),
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: 'camera_alt',
                    color: AppTheme.primaryBlue,
                    size: 6.w,
                  ),
                ),
              ),
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(6.w),
                ),
                child: TextField(
                  controller: _textController,
                  maxLines: null,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _sendTextMessage(),
                  decoration: InputDecoration(
                    hintText: 'Ask GuruAI for help...',
                    hintStyle:
                        AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.onSurfaceSecondary,
                    ),
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  ),
                  style: AppTheme.lightTheme.textTheme.bodyMedium,
                ),
              ),
            ),
            SizedBox(width: 2.w),
            GestureDetector(
              onTap: _toggleRecording,
              child: Container(
                width: 10.w,
                height: 10.w,
                decoration: BoxDecoration(
                  color: _isRecording
                      ? AppTheme.alertRed.withValues(alpha: 0.1)
                      : AppTheme.successGreen.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(5.w),
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: _isRecording ? 'stop' : 'mic',
                    color: _isRecording
                        ? AppTheme.alertRed
                        : AppTheme.successGreen,
                    size: 6.w,
                  ),
                ),
              ),
            ),
            SizedBox(width: 2.w),
            GestureDetector(
              onTap: _sendTextMessage,
              child: Container(
                width: 10.w,
                height: 10.w,
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue,
                  borderRadius: BorderRadius.circular(5.w),
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: 'send',
                    color: AppTheme.surfaceWhite,
                    size: 6.w,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}