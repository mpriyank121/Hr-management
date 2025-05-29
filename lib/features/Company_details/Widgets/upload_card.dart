import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/widgets/Leave_Container.dart';

class UploadCard extends StatefulWidget {
  final String title;
  final void Function(File?) onImageSelected;
  final String? initialImage; // URL or local path

  const UploadCard({
    super.key,
    required this.title,
    required this.onImageSelected,
    this.initialImage,
  });

  @override
  State<UploadCard> createState() => _UploadCardState();
}

class _UploadCardState extends State<UploadCard> {
  File? _selectedImage;

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
      });
      widget.onImageSelected(_selectedImage);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;

    if (_selectedImage != null) {
      // Show picked image
      imageWidget = Image.file(_selectedImage!, height: 80);
    } else if (widget.initialImage != null && widget.initialImage!.isNotEmpty) {
      if (widget.initialImage!.startsWith('http')) {
        // Show network image
        imageWidget = Image.network(widget.initialImage!, height: 80);
      } else {
        // Show local file image
        imageWidget = Image.file(File(widget.initialImage!), height: 80);
      }
    } else {
      // Show default upload icon
      imageWidget = const Icon(Icons.cloud_upload, size: 40, color: Colors.grey);
    }

    return LeaveContainer(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: InkWell(
        onTap: _pickImage,
        child: Column(
          children: [
            imageWidget,
            const SizedBox(height: 8),
            Text(widget.title),
          ],
        ),
      ),
    );
  }
}
