import 'package:flutter/material.dart';

class OtpTextField extends StatefulWidget {
  final Function(String) onOtpComplete;

  const OtpTextField({Key? key, required this.onOtpComplete}) : super(key: key);

  @override
  _OtpTextFieldState createState() => _OtpTextFieldState();
}

class _OtpTextFieldState extends State<OtpTextField> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;
  final int otpLength = 4;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(otpLength, (_) => TextEditingController());
    _focusNodes = List.generate(otpLength, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _onOtpChanged(int index, String value) {
    if (value.isNotEmpty && index < otpLength - 1) {
      _focusNodes[index + 1].requestFocus(); // Move to the next field
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus(); // Move back
    }

    // Check if all OTP fields are filled
    String otp = _controllers.map((controller) => controller.text).join();
    if (otp.length == otpLength) {
      widget.onOtpComplete(otp);
    }
  }

  @override
  Widget build(BuildContext context) {
    double fieldSize = MediaQuery.of(context).size.width * 0.12; // Adaptive width
    double fieldHeight = fieldSize * 1.5; // Maintain aspect ratio

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(otpLength, (index) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 5),
          width: fieldSize,
          height: fieldHeight,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white),
          ),
          child: TextField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            style: TextStyle(
                height: 2, // ✅ Ensures proper vertical alignment

                fontSize: fieldSize * 0.5, color: Colors.white),
            decoration: InputDecoration(
              counterText: '',
              border: InputBorder.none,
            ),
            onChanged: (value) => _onOtpChanged(index, value),
          ),
        );
      }),
    );
  }
}
