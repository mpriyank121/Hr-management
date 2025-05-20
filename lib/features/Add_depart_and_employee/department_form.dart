import 'package:flutter/material.dart';
import '../../config/app_spacing.dart';
import '../../config/font_style.dart';
import '../../core/widgets/App_bar.dart';
import '../../core/widgets/Leave_Container.dart';
import '../../core/widgets/primary_button.dart';
import '../Company_details/Widgets/custom_text_field.dart';


class AddNewDepartmentScreen extends StatefulWidget {
  @override
  _AddNewDepartmentScreenState createState() => _AddNewDepartmentScreenState();
}

class _AddNewDepartmentScreenState extends State<AddNewDepartmentScreen> {
  final _departmentController = TextEditingController();
  String _workPattern = 'Mon - Sat';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        leading: BackButton(color: Colors.black),
        title:
          'Add New Department',

        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppSpacing.small(context) ,
            Text('Department Name', style: FontStyles.subHeadingStyle()),
            AppSpacing.small(context) ,
            CustomTextField(
              hint: 'Department Name',
            ),
            AppSpacing.small(context) ,
            // Work Pattern dropdown
            Text('Work Pattern', style: FontStyles.subHeadingStyle()),
            AppSpacing.small(context) ,
            LeaveContainer(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: DropdownButton<String>(
                value: _workPattern,
                isExpanded: true,
                underline: SizedBox(),
                items: <String>['Mon - Sat', 'Mon - Fri', 'Tue - Sat'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newVal) {
                  setState(() {
                    _workPattern = newVal!;
                  });
                },
              ),
            ),
            AppSpacing.small(context) ,
            // Supervisor (disabled)
            Text('Supervisor', style: FontStyles.subHeadingStyle()),
            AppSpacing.small(context) ,
            CustomTextField(
             hint: 'Priyank',
            ),

            Spacer(),

            // Buttons Cancel and Save
            Row(
              children: [
                Expanded(
                  child: PrimaryButton(
                    textColor: const Color(0xFFF25922),
                    buttonColor: const Color(0x19CD0909),
                    text: "Cancel",
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: PrimaryButton(text: "Save")
                ),
              ],
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
