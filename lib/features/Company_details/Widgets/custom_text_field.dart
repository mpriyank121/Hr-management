import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final InputDecoration? decoration;
  final VoidCallback? onTap;

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
    this.validator,
    this.inputFormatters,
    this.decoration,
    this.onTap
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LeaveContainer(
      child: TextField(
        inputFormatters: inputFormatters,
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        onChanged: onChanged,
        enabled: enabled,
        style: FontStyles.subHeadingStyle(),
        decoration: decoration ?? InputDecoration(
          prefixIcon: icon != null ? Icon(icon, size: 16) : null,
          hintText: hint,
          hintStyle: FontStyles.subTextStyle(),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
        ),
      ),
    );
  }
}
