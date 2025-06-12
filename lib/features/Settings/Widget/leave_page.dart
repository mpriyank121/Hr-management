import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_management/config/App_margin.dart';
import 'package:hr_management/config/app_spacing.dart';
import 'package:hr_management/core/widgets/App_bar.dart';
import 'package:hr_management/core/widgets/primary_button.dart';
import '../../../core/widgets/Custom_list_tile.dart';
import '../../Holiday_List_Page/Widgets/year_selector.dart';
import '../controllers/fetch_org_leaves_controller.dart';
import '../controllers/leave_controller.dart';
import '../models/fetch_org_leave.dart';

class LeaveConfigScreen extends StatelessWidget {
  final LeaveController controller = Get.put(LeaveController());
  final LeaveTypeController leaveController = Get.put(LeaveTypeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Leave Configuration'),
      body: Obx(() {
        if (leaveController.isLoading.value && leaveController.availableLeaveTypes.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return AppMargin(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Obx(() => YearMonthSelector(
                  initialYear: leaveController.selectedYear.value,
                  initialMonth: DateTime.now().month,
                  showMonth: false,
                  onDateChanged: (year, _) {
                    leaveController.changeYear(year); // 🔄 Update leave list based on selected year
                  },
                )),
              ),
              AppSpacing.small(context),

              // Leave List
              Expanded(
                child: Obx(() {
                  if (leaveController.availableLeaveTypes.isEmpty) {
                    return const Center(child: Text('No leave types available'));
                  }
                  return ListView.builder(
                    itemCount: leaveController.availableLeaveTypes.length,
                    itemBuilder: (context, index) {
                      final leave = leaveController.availableLeaveTypes[index];

                      return CustomListTile(
                        title: Text('${leave.leaveName ?? 'Unknown'} (${leave.totalAnnualLeaves ?? 'N/A'})'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.red),
                              onPressed: () {
                                controller.addLeaveRowModal(context, leave: leave);
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
                                      content: Text("Are you sure you want to delete '${leave.leaveName}'?"),
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
                                            await controller.deleteLeave(
                                              id: (leave.id ?? ''),
                                              type: '110a97a105a107a114a97a72a97a93a114a97a80a117a108a97a102',
                                            );
                                            // Optional: Reload leave types if needed
                                            await leaveController.loadLeaveTypes(year: leaveController.selectedYear.value);
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

              AppSpacing.medium(context),

              // Add Leave Type Button
              PrimaryButton(
                onPressed: () => controller.addLeaveRowModal(context),
                text: 'Add Leave Type',
              ),
            ],
          ),
        );
      }),
    );
  }
}
