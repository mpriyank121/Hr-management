import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_management/core/widgets/primary_button.dart';
import '../../core/widgets/App_bar.dart';
import '../../core/widgets/Custom_bottom_modal_sheet.dart';
import 'package:hr_management/features/Holiday_List_Page/controller/holiday_controller.dart';
import 'Widgets/holiday_list.dart';

class HolidayPage extends StatefulWidget {
  final String title;

  const HolidayPage({Key? key, required this.title}) : super(key: key);

  @override
  _HolidayPageState createState() => _HolidayPageState();
}

class _HolidayPageState extends State<HolidayPage> {
  final HolidayController controller = Get.find<HolidayController>();


  void showHolidayBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => HolidayBottomSheet(
        onSubmit: (DateTime date, int year, String name) {
          controller.addHoliday(
            holiday: name,
            holidayDate: date.toIso8601String().split("T").first,
            year: year.toString(),
          );
          Get.back(); // Close the sheet
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(title: widget.title),
        body: Column(
          children: [
            Expanded(child: HolidayList()),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: PrimaryButton(
                onPressed: () => showHolidayBottomSheet(context),
                text: "Add new Holiday",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
