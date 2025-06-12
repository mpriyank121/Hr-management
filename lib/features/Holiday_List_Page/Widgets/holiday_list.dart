import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_management/features/Holiday_List_Page/Widgets/year_selector.dart';
import '../../../core/widgets/Custom_bottom_modal_sheet.dart';
import '../../../core/widgets/Custom_list_tile.dart';
import '../../../core/widgets/Holiday_Date_Icon.dart';
import 'package:hr_management/features/Holiday_List_Page/controller/holiday_controller.dart';



class HolidayList extends StatefulWidget {
  const HolidayList({Key? key}) : super(key: key);

  @override
  State<HolidayList> createState() => _HolidayListState();
}


class _HolidayListState extends State<HolidayList> {
  final HolidayController controller = Get.find<HolidayController>();

  List<int> getYearsList() {
    final currentYear = DateTime.now().year;
    return List.generate(10, (index) => currentYear - 5 + index);
  }

  @override
  void initState() {
    super.initState();
    controller.loadHolidays(); // Load holidays once
  }

  void showHolidayBottomSheet(BuildContext context, {
    DateTime? date,
    int? year,
    String? name,
    String? id, // ✅ Add id parameter
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => HolidayBottomSheet(
        initialDate: date,
        initialYear: year,
        initialName: name,
        id: id, // ✅ Pass id to HolidayBottomSheet
        onSubmit: (DateTime date, int year, String name) {
          controller.editHoliday(
            id: id ?? '',
            // ✅ Use the id here
            holiday: name,
            holidayDate: date.toIso8601String().split("T").first,
            year: year.toString(),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Obx(() =>
              YearMonthSelector(
                initialYear: controller.selectedYear.value,
                initialMonth: DateTime.now().month,
                showMonth: false,
                onDateChanged: (year, _) {
                  controller.changeYear(year);
                },
              ),
          ),
        ),
        Expanded(
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.holidayList.isEmpty) {
              return const Center(child: Text('No holidays found.'));
            }

            return ListView.builder(
              itemCount: controller.holidayList.length,
              itemBuilder: (context, index) {
                final holiday = controller.holidayList[index];
                return CustomListTile(
                  item: {
                    "title": holiday.holiday,
                    "subtitle": holiday.holiday_date,
                  },
                  leading: HolidayDateIcon(holidayDate: holiday.holiday_date),
                  trailing: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.red),
                        onPressed: () {
                          final holidayDate = DateTime.parse(holiday.holiday_date);
                          final holidayName = holiday.holiday;
                          final year = holidayDate.year;
                          final id = holiday.id; // ✅ Extract ID

                          showHolidayBottomSheet(
                            context,
                            date: holidayDate,
                            year: year,
                            name: holidayName,
                            id: id, // ✅ Pass ID
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          showCupertinoDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CupertinoAlertDialog(
                                title: const Text("Confirm Delete"),
                                content: Text("Are you sure you want to delete '${holiday.holiday}'?"),
                                actions: [
                                  CupertinoDialogAction(
                                    child: const Text("No"),
                                    onPressed: () => Navigator.of(context).pop(),
                                  ),
                                  CupertinoDialogAction(
                                    isDestructiveAction: true,
                                    child: const Text("Yes"),
                                    onPressed: () async {
                                      Navigator.of(context).pop();
                                      await controller.deleteHoliday(
                                        id: (holiday.id ?? ''),
                                      );
                                      // Optional: Reload leave types if needed

                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }
}

