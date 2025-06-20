import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';

import '../../config/app_spacing.dart';
import '../../config/font_style.dart';

class CompanyLogoPicker extends StatefulWidget {
  final void Function(File?) onImageSelected;
  final String? initialImage;
  final String title;

  const CompanyLogoPicker({
    Key? key,
    required this.onImageSelected,
    this.initialImage,
    this.title = "Company Logo",
  }) : super(key: key);

  @override
  State<CompanyLogoPicker> createState() => _CompanyLogoPickerState();
}

class _CompanyLogoPickerState extends State<CompanyLogoPicker> {
  File? _selectedImage;

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source, imageQuality: 85);

    if (picked != null) {
      final bytes = await picked.readAsBytes();
      final decoded = img.decodeImage(bytes);
      if (decoded != null) {
        final resized = img.copyResize(decoded, width: 250, height: 250);
        final resizedBytes = Uint8List.fromList(img.encodeJpg(resized));

        final tempFile = await File(
          '${Directory.systemTemp.path}/resized_${DateTime.now().millisecondsSinceEpoch}.jpg',
        ).writeAsBytes(resizedBytes);

        setState(() => _selectedImage = tempFile);
        widget.onImageSelected(tempFile);
      }
    }
  }

  Future<void> _showImageSourceOptions() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );

    if (source != null) {
      await _pickImage(source);
    }
  }

  void _showPreview() {
    if (_selectedImage == null) return;
    showDialog(
      context: context,
      builder: (_) => Dialog(child: Image.file(_selectedImage!)),
    );
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider? displayImage;

    if (_selectedImage != null) {
      displayImage = FileImage(_selectedImage!);
    } else if (widget.initialImage != null && widget.initialImage!.isNotEmpty) {
      displayImage = widget.initialImage!.startsWith('http')
          ? NetworkImage(widget.initialImage!)
          : FileImage(File(widget.initialImage!));
    }

    return Column(
      children: [
        GestureDetector(
          onTap: _selectedImage != null ? _showPreview : null,
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.grey.shade200,
                backgroundImage: displayImage,
                child: displayImage == null
                    ? const Icon(Icons.camera_alt, color: Colors.grey, size: 40)
                    : null,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: _showImageSourceOptions,
                  child: const CircleAvatar(
                    radius: 12,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.add_a_photo, size: 16, color: Colors.deepOrange),
                  ),
                ),
              ),
            ],
          ),
        ),
        AppSpacing.small(context),
        Text(widget.title, style: FontStyles.subHeadingStyle()),
      ],
    );
  }
}
