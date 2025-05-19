import 'package:flutter/material.dart';
import '../../Configuration/app_cards.dart';
import '../../Configuration/font_style.dart';
import '../../widgets/Leave_Container.dart';

class CustomTextField extends StatelessWidget {
  final String hint;
  final IconData? icon;
  final TextInputType? keyboardType;

  const CustomTextField({
    Key? key,
    required this.hint,
    this.icon,
    this.keyboardType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LeaveContainer(
      child: TextField(
        keyboardType: keyboardType,
        decoration: InputDecoration(
          prefixIcon: icon != null ? Icon(icon, size: 20) : null,
          hintText: hint,
          hintStyle: FontStyles.subTextStyle(), // Applied custom font style
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}
