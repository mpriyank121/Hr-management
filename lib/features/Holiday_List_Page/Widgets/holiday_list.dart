import 'package:flutter/material.dart';
import '../../../core/widgets/Custom_list_tile.dart';
import '../../../core/widgets/Holiday_Date_Icon.dart';
import '../Models/holiday_list_model.dart';


class HolidayList extends StatelessWidget {


  const HolidayList({
    Key? key,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Holiday> dummyHolidays = [
      Holiday(holiday: 'New Year\'s Day', holiday_date: '2025-01-01'),
      Holiday(holiday: 'Republic Day', holiday_date: '2025-01-26'),
      Holiday(holiday: 'Independence Day', holiday_date: '2025-08-15'),
    ];


    return ListView.builder(
      itemCount: dummyHolidays.length,
      itemBuilder: (context, index) {
        final holiday = dummyHolidays[index];
        print("✅ Rendering holiday: ${holiday.holiday} on ${holiday.holiday_date}");

        return CustomListTile(
          item: {
            "title": holiday.holiday, // Holiday Name
            "subtitle": holiday.holiday_date, // Holiday Date
          },
          leading: HolidayDateIcon(holidayDate: holiday.holiday_date),
          trailing: Image.asset( 'assets/images/trash_icon.png',width: 24,height: 24,),
        );
      },
    );
  }
}
