import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hr_management/features/Company_details/Widgets/custom_text_field.dart';

class RequiredTextField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool isRequired;
  final bool showRequired;
  final String fieldName;
  final Function(String)? onChanged;
  final bool enabled;
  final TextCapitalization? textCapitalization;
  const RequiredTextField({
    super.key,
    required this.hint,
    required this.controller,
    required this.fieldName,
    this.validator,
    this.keyboardType,
    this.inputFormatters,
    this.isRequired = true,
    this.showRequired = false,
    this.onChanged,
    this.enabled = true,
    this.textCapitalization
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          hint: hint,
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          onChanged: onChanged,
          enabled: enabled,
        ),
        if (isRequired && showRequired && controller.text.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4.0, left: 12.0),
            child: Text(
              'Please enter $fieldName',
              style: TextStyle(
                color: Colors.red.withOpacity(0.8),
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }
} 