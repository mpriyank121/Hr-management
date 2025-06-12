import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtpTextField extends StatefulWidget {
  final Function(String) onOtpComplete;

  const OtpTextField({Key? key, required this.onOtpComplete}) : super(key: key);

  @override
  _OtpTextFieldState createState() => _OtpTextFieldState();
}

class _OtpTextFieldState extends State<OtpTextField> with SingleTickerProviderStateMixin {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;
  late AnimationController _animationController;
  late List<Animation<double>> _animations;
  final int otpLength = 4;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(otpLength, (_) => TextEditingController());
    _focusNodes = List.generate(otpLength, (_) => FocusNode());
    
    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    // Create animations for each field
    _animations = List.generate(
      otpLength,
      (index) => Tween<double>(begin: 1.0, end: 1.2).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(index * 0.1, (index + 1) * 0.1, curve: Curves.easeInOut),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _onOtpChanged(int index, String value) {
    if (value.isNotEmpty) {
      // Animate when entering a digit
      _animationController.forward(from: 0.0);
      
      if (index < otpLength - 1) {
        _focusNodes[index + 1].requestFocus();
      }
    }

    // Check if all OTP fields are filled
    String otp = _controllers.map((controller) => controller.text).join();
    if (otp.length == otpLength) {
      widget.onOtpComplete(otp);
    }
  }

  void _handleKeyEvent(int index, RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.backspace) {
        if (_controllers[index].text.isEmpty && index > 0) {
          // If current field is empty and backspace is pressed, move to previous field
          _focusNodes[index - 1].requestFocus();
          _controllers[index - 1].clear();
          // Animate when removing a digit
          _animationController.forward(from: 0.0);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double fieldSize = MediaQuery.of(context).size.width * 0.12;
    double fieldHeight = fieldSize * 1.5;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(otpLength, (index) {
        return AnimatedBuilder(
          animation: _animations[index],
          builder: (context, child) {
            return Transform.scale(
              scale: _animations[index].value,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 5),
                width: fieldSize,
                height: fieldHeight,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _focusNodes[index].hasFocus 
                        ? Color(0xFFF25822)
                        .withOpacity(0.5)
                        : Colors.white.withOpacity(0.3),
                    width: 1.5,
                  ),
                  boxShadow: _focusNodes[index].hasFocus
                      ? [
                          BoxShadow(
                            color: (Color(0xFFF25822)
                            ).withOpacity(0.2),
                            blurRadius: 8,
                            spreadRadius: 1,
                          )
                        ]
                      : null,
                ),
                child: RawKeyboardListener(
                  focusNode: FocusNode(),
                  onKey: (event) => _handleKeyEvent(index, event),
                  child: Center(
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      style: TextStyle(
                        fontSize: fieldSize * 0.5,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        isDense: true,
                      ),
                      onChanged: (value) => _onOtpChanged(index, value),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
