import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/widgets/Leave_Container.dart';

class UploadCard extends StatefulWidget {
  final String title;
  final void Function(File?) onImageSelected;
  final String? initialImage; // URL or file path

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

  @override
  void initState() {
    super.initState();

    // If initialImage is a local file path, convert it to a File object
    if (widget.initialImage != null &&
        widget.initialImage!.isNotEmpty &&
        !widget.initialImage!.startsWith('http')) {
      final file = File(widget.initialImage!);
      if (file.existsSync()) {
        _selectedImage = file;
      }
    }
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final file = File(picked.path);
      setState(() {
        _selectedImage = file;
      });
      widget.onImageSelected(file);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;

    if (_selectedImage != null) {
      imageWidget = Image.file(_selectedImage!, height: 100, fit: BoxFit.cover);
    } else if (widget.initialImage != null && widget.initialImage!.isNotEmpty) {
      if (widget.initialImage!.startsWith('http')) {
        imageWidget = Image.network(widget.initialImage!, height: 100, fit: BoxFit.cover);
      } else {
        final file = File(widget.initialImage!);
        imageWidget = file.existsSync()
            ? Image.file(file, height: 100, fit: BoxFit.cover)
            : const Icon(Icons.cloud_upload, size: 40, color: Colors.grey);
      }
    } else {
      imageWidget = const Icon(Icons.cloud_upload, size: 40, color: Colors.grey);
    }

    return LeaveContainer(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: InkWell(
        onTap: _pickImage,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: imageWidget,
            ),
            const SizedBox(height: 8),
            Text(
              widget.title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
