import 'dart:async';
import 'package:flutter/material.dart';

import '../../config/app_buttons.dart';
class ResendButton extends StatefulWidget {
  final VoidCallback onResend; // Function callback when button is clicked

  const ResendButton({super.key, required this.onResend});

  @override
  State<ResendButton> createState() => _ResendButtonState();
}

class _ResendButtonState extends State<ResendButton> {
  int _seconds = ResendButtonConfig.timerDuration;
  bool _isButtonEnabled = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    setState(() {
      _isButtonEnabled = false;
      _seconds = ResendButtonConfig.timerDuration;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds > 0) {
        setState(() {
          _seconds--;
        });
      } else {
        _timer?.cancel();
        setState(() {
          _isButtonEnabled = true;
        });
      }
    });
  }

  void _handleResend() {
    widget.onResend(); // Call function passed from the main file
    _startTimer(); // Restart timer
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _isButtonEnabled ? _handleResend : null,
      child: Container(
        padding: ResendButtonConfig.padding,
        decoration: BoxDecoration(
          border: Border.all(color: ResendButtonConfig.borderColor),
          borderRadius: BorderRadius.circular(ResendButtonConfig.borderRadius),
        ),
        child: RichText(
          text: TextSpan(
            style: TextStyle(fontSize: 16, color: ResendButtonConfig.textColor),
            children: [
              const TextSpan(text: "Resend code "),
              TextSpan(
                text: _isButtonEnabled ? "" : " : 0:$_seconds",
                style: TextStyle(
                  color: ResendButtonConfig.timerColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
