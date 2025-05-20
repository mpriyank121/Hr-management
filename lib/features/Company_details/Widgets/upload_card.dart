import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/widgets/Leave_Container.dart';

class UploadCard extends StatefulWidget {
  final String title;
  final void Function(File?) onImageSelected;
  final File? initialImage;

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
    _selectedImage = widget.initialImage;
  }

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
    return LeaveContainer(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: InkWell(
        onTap: _pickImage,
        child: Column(
          children: [
            if (_selectedImage != null)
              Image.file(_selectedImage!, height: 80)
            else
              const Icon(Icons.cloud_upload, size: 40, color: Colors.grey),
            const SizedBox(height: 8),
            Text(widget.title),
          ],
        ),
      ),
    );
  }
}
