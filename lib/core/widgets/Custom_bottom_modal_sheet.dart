import 'package:flutter/material.dart';
import 'package:hr_management/config/App_margin.dart';
import 'package:hr_management/config/app_spacing.dart';
import 'package:hr_management/config/font_style.dart';
import 'package:hr_management/core/widgets/Leave_Container.dart';
import 'package:hr_management/core/widgets/custom_dropdown.dart';
import 'package:hr_management/core/widgets/custom_toast.dart';
import 'package:hr_management/core/widgets/primary_button.dart';
import 'package:hr_management/features/Company_details/Widgets/custom_text_field.dart';
import 'package:intl/intl.dart';

class HolidayBottomSheet extends StatefulWidget {
  final Function(DateTime date, int year, String holidayName) onSubmit;
  final DateTime? initialDate;
  final int? initialYear;
  final String? initialName;
  final String? id;

  const HolidayBottomSheet({Key? key, required this.onSubmit,
    this.initialDate,
    this.initialName,
    this.initialYear,
  this.id}) : super(key: key);

  @override
  State<HolidayBottomSheet> createState() => _HolidayBottomSheetState();
}

class _HolidayBottomSheetState extends State<HolidayBottomSheet> {
  DateTime? selectedDate;
  late int selectedYear;
  final TextEditingController nameController = TextEditingController();
  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate ?? DateTime.now();
    selectedYear = widget.initialYear ?? DateTime.now().year;
    nameController.text = widget.initialName ?? '';
  }

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
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: AppMargin(
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppSpacing.small(context),
              Text(
                widget.initialName != null ? "Edit Holiday" : "Add Holiday",
                style: FontStyles.headingStyle(),
              ),
              AppSpacing.small(context),

              /// Holiday Date Picker
              GestureDetector(
                onTap: _pickDate,
                child: LeaveContainer(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
                  width: double.infinity,
                  child: Text(
                    selectedDate != null
                        ? DateFormat('yyyy-MM-dd').format(selectedDate!)
                        : 'Select Holiday Date',
                    style: FontStyles.subHeadingStyle(),
                  ),
                ),
              ),
              AppSpacing.small(context),

              /// Year Dropdown
              LeaveContainer(
                child: CustomDropdown<int>(
                  value: selectedYear,
                  decoration: const InputDecoration(
                    hintText: "Select Year",
                    border: InputBorder.none,
                  ),
                  items: getYearsList()
                      .map((year) => DropdownMenuItem<int>(
                    value: year,
                    child: Text(year.toString()),
                  ))
                      .toList(),
                  onChanged: (year) => setState(() => selectedYear = year ?? selectedYear),
                ),
              ),

              AppSpacing.small(context),

              /// Holiday Name Input
              CustomTextField(
                controller: nameController,
                hint: 'Holiday Name',
              ),

              AppSpacing.small(context),

              /// Submit Button
              PrimaryButton(
                text: isSubmitting
                    ? (widget.initialName != null ? "Updating..." : "Adding...")
                    : (widget.initialName != null ? "Update" : "Add"),
                onPressed: isSubmitting
                    ? null
                    : () async {
                  if (selectedDate != null && nameController.text.isNotEmpty) {
                    setState(() => isSubmitting = true);

                    try {
                      widget.onSubmit(selectedDate!, selectedYear, nameController.text);
                      Navigator.pop(context);
                    } catch (e) {
                      setState(() => isSubmitting = false);
                      CustomToast.show(
                        context: context,
                        message: "Error: $e",
                        isError: true,
                      );
                    }
                  } else {
                    CustomToast.show(
                      context: context,
                      message: "Please fill all fields",
                      isError: true,
                    );
                  }
                },
              ),

              AppSpacing.small(context),
            ],
          ),
        ),
      ),
    );
  }
}
