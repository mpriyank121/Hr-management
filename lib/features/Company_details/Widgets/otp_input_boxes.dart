import 'package:flutter/material.dart';

import '../../../core/widgets/Leave_Container.dart';

class OtpInputBoxes extends StatelessWidget {
  const OtpInputBoxes({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        6,
            (index) => LeaveContainer(
          width: 45,
          height: 55,
          padding: const EdgeInsets.all(0), // Optional
          child: TextField(
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            decoration: const InputDecoration(
              counterText: '', // Hides maxLength counter
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }
}
