import 'package:flutter/material.dart';
import 'package:hr_management/widgets/Leave_Container.dart';

class DropdownField extends StatelessWidget {
  const DropdownField({super.key});

  @override
  Widget build(BuildContext context) {
    return LeaveContainer(child: DropdownButtonFormField<String>(
      items: const [
        DropdownMenuItem(value: "IT", child: Text("IT")),
        DropdownMenuItem(value: "Retail", child: Text("Retail")),
        DropdownMenuItem(value: "Finance", child: Text("Finance")),
      ],
      onChanged: (value) {},

        decoration: const InputDecoration(
          hintText: 'Select Field',
          border: InputBorder.none,
        ),
      ),
    );
  }
}
