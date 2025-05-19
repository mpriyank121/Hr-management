import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Configuration/app_buttons.dart';
import '../Configuration/app_spacing.dart';
import '../Widgets/App_bar.dart';

import 'Widgets/holiday_list.dart';
import 'Widgets/year_selector.dart';

class holidaypage extends StatefulWidget {
  final String title;

  const holidaypage({Key? key, required this.title}) : super(key: key);

  @override
  _holidaypageState createState() => _holidaypageState();
}

class _holidaypageState extends State<holidaypage> {

  @override
  void initState() {
    super.initState();
    // 🔁 Optionally fetch or filter on load
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(child: Scaffold(
      appBar: CustomAppBar(title: "Holiday List"),
      body: Column(
        children: [
          AppSpacing.small(context),
          /// ✅ Year Selector
          YearMonthSelector(
            initialYear: DateTime.now().year,
            initialMonth: DateTime.now().month,
            showMonth: false,
            onDateChanged: (year, _) {
            },
          ),
          AppSpacing.small(context),
          /// ✅ Holiday List
          Expanded(
            child:  HolidayList(),
          ),

      GestureDetector(
        child: Container(
          width: screenWidth*0.9,
          padding: ResendButtonConfig.padding,
          decoration: BoxDecoration(
            border: Border.all(color: PrimaryButtonConfig.color),
            borderRadius: BorderRadius.circular(ResendButtonConfig.borderRadius),
          ),
          child:Center(child: RichText(
            text: TextSpan(
              text: "Add new Holiday",
              style: TextStyle(fontSize: 16, color:PrimaryButtonConfig.color),
            ),
          ),)
        ),
      )
        ],
      ),

    )) ;
  }
}
