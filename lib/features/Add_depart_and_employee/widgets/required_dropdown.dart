import 'package:flutter/material.dart';
import 'package:hr_management/core/widgets/Leave_Container.dart';
import 'package:hr_management/core/widgets/custom_dropdown.dart';

class RequiredDropdown<T> extends StatelessWidget {
  final T? value;
  final List<T> items;
  final void Function(T?) onChanged;
  final String hint;
  final Widget Function(T) itemBuilder;
  final bool isRequired;
  final bool showRequired;
  final String fieldName;

  const RequiredDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.hint,
    required this.itemBuilder,
    required this.fieldName,
    this.isRequired = true,
    this.showRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LeaveContainer(
          child: CustomDropdown<T>(
            value: value,
            items: items.map((item) => DropdownMenuItem<T>(
              value: item,
              child: itemBuilder(item),
            )).toList(),
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: hint,
              border: InputBorder.none,
            ),
          ),
        ),
        if (isRequired && showRequired && value == null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0, left: 12.0),
            child: Text(
              'Please select $fieldName',
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