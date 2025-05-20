import 'package:flutter/material.dart';
import '../../../core/widgets/Leave_Container.dart';

class DropdownField extends StatelessWidget {
  final List<DropdownMenuItem<String>>? items;
  final void Function(String?)? onChanged;
  final String? hintText;
  final String? value;


  const DropdownField({
    super.key,
    this.items,
    this.onChanged,
    this.hintText,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return LeaveContainer(
      child: DropdownButtonFormField<String>(
        value: value,
        items: items,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText ?? 'Select Option',
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        ),
      ),
    );
  }
}
