import 'package:flutter/material.dart';
import 'package:hr_management/core/widgets/primary_button.dart';
import 'package:intl/intl.dart';

class HolidayBottomSheet extends StatefulWidget {
  final Function(DateTime date, int year, String holidayName) onSubmit;

  const HolidayBottomSheet({Key? key, required this.onSubmit}) : super(key: key);

  @override
  State<HolidayBottomSheet> createState() => _HolidayBottomSheetState();
}

class _HolidayBottomSheetState extends State<HolidayBottomSheet> {
  DateTime? selectedDate;
  int selectedYear = DateTime.now().year;
  final TextEditingController nameController = TextEditingController();

  List<int> getYearsList() {
    final currentYear = DateTime.now().year;
    return List.generate(10, (index) => currentYear - 5 + index);
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Add Holiday", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

          const SizedBox(height: 16),

          /// Holiday Date Picker
          GestureDetector(
            onTap: _pickDate,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              width: double.infinity,
              child: Text(
                selectedDate != null
                    ? DateFormat('yyyy-MM-dd').format(selectedDate!)
                    : 'Select Holiday Date',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),

          const SizedBox(height: 12),

          /// Year Dropdown
          DropdownButtonFormField<int>(
            value: selectedYear,
            items: getYearsList()
                .map((year) => DropdownMenuItem(value: year, child: Text(year.toString())))
                .toList(),
            onChanged: (year) => setState(() => selectedYear = year ?? selectedYear),
            decoration: const InputDecoration(
              labelText: "Year",
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 12),

          /// Holiday Name Input
          TextFormField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Holiday Name',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 20),

          /// Submit Button
         PrimaryButton(text: "Add ",
           onPressed: () {
             if (selectedDate != null && nameController.text.isNotEmpty) {
               widget.onSubmit(
                   selectedDate!, selectedYear, nameController.text);
               Navigator.pop(context);
             } else {
               ScaffoldMessenger.of(context).showSnackBar(
                 const SnackBar(content: Text("Please fill all fields")),
               );
             }

           }
         )
        ],
      ),
    );
  }
}
