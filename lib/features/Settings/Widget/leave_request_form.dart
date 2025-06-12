import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_management/core/widgets/custom_dropdown.dart';
import 'package:intl/intl.dart';
import '../../../config/app_spacing.dart';
import '../../../config/style.dart';
import '../../../core/widgets/App_bar.dart';
import '../../../core/widgets/Leave_Container.dart';
import '../../../core/widgets/primary_button.dart';
import '../controllers/fetch_org_leaves_controller.dart';
import '../controllers/leave_controller.dart';
import '../models/fetch_org_leave.dart';
import '../models/leave_type_model.dart';

class RequestLeavePage extends StatefulWidget {
  @override
  _RequestLeavePageState createState() => _RequestLeavePageState();
}

class _RequestLeavePageState extends State<RequestLeavePage> {
  DateTime? fromDate;
  DateTime? toDate;
  final TextEditingController aboutController = TextEditingController();
  String? selectedLeaveType;
  List<Map<String, String>> leaveTypes = [];
  bool isLoading = false;
  int selectedYear = DateTime.now().year;
  int selectedMonth = DateTime.now().month;
  final LeaveTypeController controller = Get.put(LeaveTypeController());
  final LeaveController controllers = Get.put(LeaveController());

  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    aboutController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isFromDate) async {
    final DateTime now = DateTime.now();

    final DateTime initialDate = isFromDate
        ? (fromDate ?? now)
        : (toDate ?? fromDate ?? now);

    final DateTime firstDate = isFromDate
        ? now
        : (fromDate ?? DateTime(2000));

    final DateTime lastDate = isFromDate
        ? (toDate ?? DateTime(2101))
        : DateTime(2101);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (picked != null) {
      setState(() {
        if (isFromDate) {
          fromDate = picked;
          // Reset toDate if it's before the new fromDate
          if (toDate != null && toDate!.isBefore(fromDate!)) {
            toDate = null;
          }
        } else {
          toDate = picked;
          // Reset fromDate if it's after the new toDate
          if (fromDate != null && fromDate!.isAfter(toDate!)) {
            fromDate = null;
          }
        }
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: CustomAppBar(
          title: "Request Leave",
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 12.0, right: 12.0),
          child: Column(
            children: [
              AppSpacing.small(context),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppSpacing.small(context),
                      Text('Leave Type', style: fontStyles.headingStyle),
                      AppSpacing.small(context),
                    LeaveContainer(child:  Obx(() {

                      return CustomDropdown<OrgLeave>(

                        decoration: const InputDecoration(
                          hintText: "Select Leave Type",
                          border: InputBorder.none,
                        ),
                        items: controller.availableLeaveTypes.map((leave) {
                          return DropdownMenuItem<OrgLeave>(
                            value: leave,
                            child: Text(leave.leaveName),
                          );
                        }).toList(),
                        value: controller.selectedLeave.value,
                        onChanged: (OrgLeave? newValue) {
                          controller.setSelectedLeave(newValue);
                        },
                      );
                    })),

                      AppSpacing.small(context),
                      Text('From', style: fontStyles.headingStyle),
                      AppSpacing.small(context),
                      GestureDetector(
                        onTap: () => _selectDate(context, true),
                        child: LeaveContainer(
                          height: screenHeight * 0.06,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                fromDate == null
                                    ? " Select Date"
                                    : DateFormat("MMMM dd, yyyy").format(fromDate!),
                                style: TextStyle(color: Colors.black54),
                              ),
                              Icon(Icons.calendar_today, color: Colors.black54),
                            ],
                          ),
                        ),
                      ),
                      AppSpacing.small(context),
                      Text('To', style: fontStyles.headingStyle),
                      AppSpacing.small(context),
                      GestureDetector(
                        onTap: () => _selectDate(context, false),
                        child: LeaveContainer(
                          height: screenHeight * 0.06,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                toDate == null
                                    ? " Select Date"
                                    : DateFormat("MMMM dd, yyyy").format(toDate!),
                                style: TextStyle(color: Colors.black54),
                              ),
                              Icon(Icons.calendar_today, color: Colors.black54),
                            ],
                          ),
                        ),
                      ),
                      AppSpacing.small(context),
                      Text('Reason', style: fontStyles.headingStyle),
                      AppSpacing.small(context),
                      LeaveContainer(
                        height: screenHeight * 0.2,
                        child: TextFormField(
                          controller: aboutController,
                          decoration: InputDecoration(
                            hintText: " Enter Reason",
                            border: InputBorder.none,
                          ),
                          maxLines: 7,
                        ),
                      ),
                      AppSpacing.small(context),

                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Obx(() => PrimaryButton(
                      text: controllers.applyLeaveLoading.value ? 'Applying...' : 'Apply Leave',
                      onPressed: controllers.applyLeaveLoading.value
                          ? null
                          : () {
                        controllers.submitLeaveApplication(
                            selectedLeave: controller.selectedLeave.value, fromDate: fromDate, toDate: toDate, note: aboutController.text);
                      },
                    )),

                  ),
                ],
              ),
              AppSpacing.small(context),
            ],
          ),
        ),
      ),
    );
  }
}