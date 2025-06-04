import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_management/features/Holiday_List_Page/Widgets/year_selector.dart';
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
    controller.loadHolidays(); // Only runs once
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

          )),

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
                  trailing: Image.asset('assets/images/trash_icon.png', width: 24, height: 24),
                );
              },
            );
          }),
        ),
      ],
    );
  }
}
