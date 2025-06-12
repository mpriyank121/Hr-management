import 'package:flutter/material.dart';
import 'dart:async';

import '../../features/login/login_screen.dart';

void showRegistrationCompletedDialog(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierDismissible: false,
    barrierLabel: "Registration Complete",
    pageBuilder: (_, __, ___) => const SizedBox(),
    transitionBuilder: (context, anim1, anim2, child) {
      return Transform.scale(
        scale: anim1.value,
        child: Opacity(
          opacity: anim1.value,
          child: _RegistrationDialog(),
        ),
      );
    },
    transitionDuration: const Duration(milliseconds: 400),
  );
}

class _RegistrationDialog extends StatefulWidget {
  const _RegistrationDialog({Key? key}) : super(key: key);

  @override
  State<_RegistrationDialog> createState() => _RegistrationDialogState();
}

class _RegistrationDialogState extends State<_RegistrationDialog> {
  @override
  void initState() {
    super.initState();
    // Auto navigate after 3 seconds

  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 32),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Green Check Icon
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                child:  Image.asset(
                  'assets/images/register_icon.png', // 👈 Replace with your actual asset path
                  height: 48,
                ),
              ),
              const SizedBox(height: 24),

              // Title
              const Text(
                'Your registration is completed',
                style: TextStyle(
                  color: Colors.deepOrange,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // Replace emoji with image
              Image.asset(
                'assets/images/emoji.png', // 👈 Replace with your actual asset path
                height: 35,
              ),

              const SizedBox(height: 8),
              const Text(
                'Have a Nice day, Thank you',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Done Button (manual close if needed)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );

                  },
                  child: const Text(
                    'Done',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
