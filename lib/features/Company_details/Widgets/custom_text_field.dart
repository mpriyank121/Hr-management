import 'package:flutter/material.dart';
import '../../../config/font_style.dart';
import '../../../core/widgets/Leave_Container.dart';

class CustomTextField extends StatelessWidget {
  final String hint;
  final String? initialValue;
  final IconData? icon;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final bool obscureText;
  final bool enabled;

  const CustomTextField({
    Key? key,
    required this.hint,
    this.icon,
    this.keyboardType,
    this.controller,
    this.onChanged,
    this.obscureText = false,
    this.initialValue,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LeaveContainer(
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        onChanged: onChanged,
        enabled: enabled,
        decoration: InputDecoration(
          prefixIcon: icon != null ? Icon(icon, size: 20) : null,
          hintText: hint,
          hintStyle: FontStyles.subTextStyle(),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}
