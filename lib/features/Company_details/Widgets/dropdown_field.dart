import 'package:flutter/material.dart';
import '../../../core/widgets/custom_dropdown.dart'; // Your custom dropdown widget import

class CustomDropdownFormField<T> extends FormField<T> {
  final List<DropdownMenuItem<T>> items;
  final InputDecoration decoration;

  CustomDropdownFormField({
    Key? key,
    required T? initialValue,
    required this.items,
    required void Function(T?)? onChanged,
    String? Function(T?)? validator,
    this.decoration = const InputDecoration(),
    AutovalidateMode autovalidateMode = AutovalidateMode.disabled,
    bool enabled = true,
  }) : super(
    key: key,
    initialValue: initialValue,
    validator: validator,
    autovalidateMode: autovalidateMode,
    enabled: enabled,
    builder: (FormFieldState<T> field) {
      void onChangedHandler(T? newValue) {
        field.didChange(newValue);
        if (onChanged != null) onChanged(newValue);
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IgnorePointer(
            ignoring: !enabled,
            child: CustomDropdown<T>(
              value: field.value,
              items: items,
              onChanged: onChangedHandler,
              decoration: decoration.copyWith(
                errorText: field.errorText,
              ),
            ),
          ),
        ],
      );
    },
  );
}
