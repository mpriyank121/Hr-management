import 'package:flutter/material.dart';
import 'package:hr_management/widgets/Leave_Container.dart';

class UploadCard extends StatelessWidget {
  const UploadCard({super.key});

  @override
  Widget build(BuildContext context) {
    return LeaveContainer(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24),

      child: const Column(
        children: [
          Icon(Icons.cloud_upload, size: 40, color: Colors.grey),
          SizedBox(height: 8),
          Text("Upload your PAN card"),
        ],
      ),
    );
  }
}
