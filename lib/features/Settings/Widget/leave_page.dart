import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_management/config/App_margin.dart';
import 'package:hr_management/config/app_spacing.dart';
import 'package:hr_management/core/widgets/App_bar.dart';
import 'package:hr_management/core/widgets/custom_dropdown.dart';
import 'package:hr_management/core/widgets/primary_button.dart';
import '../../../core/widgets/Custom_list_tile.dart';
import '../../Company_details/Widgets/custom_text_field.dart';
import '../controllers/fetch_org_leaves_controller.dart';
import '../controllers/leave_controller.dart';
import '../models/leave_type_model.dart';

class LeaveConfigScreen extends StatelessWidget {
  final LeaveController controller = Get.put(LeaveController());
  final LeaveTypeController leaveController = Get.put(LeaveTypeController());



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Leave Configuration'),
      body: Obx(() {
        if (controller.isLoading.value && controller.availableLeaveTypes.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return AppMargin(
          child: Column(
            children: [
              AppSpacing.small(context),
              // Leaves list in Expanded with scroll
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
                        title: Text(leave.leaveName ?? 'Unknown'),
                        subtitle: Text('Allowed Days: ${leave.totalAnnualLeaves ?? 'N/A'}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                // You can add edit logic here
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                // Add delete logic here if needed
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }),
              ),


              // Spacing between list and button
              AppSpacing.medium(context),

              // Add Leave Type button at bottom
              PrimaryButton(
                textColor: const Color(0xFFF25922),
                buttonColor: const Color(0x19CD0909),
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