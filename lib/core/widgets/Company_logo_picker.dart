import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CompanyLogoPicker extends StatefulWidget {
  final void Function(File?) onImageSelected;
  final String? initialImage; // This is a URL or local path string

  const CompanyLogoPicker({
    Key? key,
    required this.onImageSelected,
    this.initialImage,
  }) : super(key: key);

  @override
  State<CompanyLogoPicker> createState() => _CompanyLogoPickerState();
}

class _CompanyLogoPickerState extends State<CompanyLogoPicker> {
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
    ImageProvider displayImage;

    if (_selectedImage != null) {
      // User picked new image
      displayImage = FileImage(_selectedImage!);
    } else if (widget.initialImage != null && widget.initialImage!.isNotEmpty) {
      if (widget.initialImage!.startsWith('http')) {
        // initialImage is a URL
        displayImage = NetworkImage(widget.initialImage!);
      } else {
        // initialImage is a local file path
        displayImage = FileImage(File(widget.initialImage!));
      }
    } else {
      // Fallback default asset image
      displayImage = const AssetImage("assets/logo.png");
    }

    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.grey.shade200,
              backgroundImage: displayImage,
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.edit, size: 16, color: Colors.orange),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          "Company Logo",
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
