import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_management/config/App_margin.dart';
import 'package:hr_management/config/app_spacing.dart';
import 'package:hr_management/core/widgets/App_bar.dart';
import '../../core/widgets/Custom_tab_widget.dart';
import 'Widgets/leave_request.dart';
import 'controllers/leave_request_controller.dart';

class LeaveApprovalScreen extends StatelessWidget {
  final LeaveRequestController leaveController = Get.put(LeaveRequestController());
  final TabControllerX tabController = Get.put(TabControllerX());

  @override
  Widget build(BuildContext context) {
    tabController.selectedIndex.value = 0;
    return Scaffold(
      appBar: CustomAppBar(title: "Leave Approval"),
      body: AppMargin(child: Column(
        children: [
          AppSpacing.small(context),
          CustomTabWidget(
            tabTitles: ["Requested", "Approved", "Rejected"],
            controller: tabController,
          ),
          AppSpacing.small(context),
          Expanded(
            child: Obx(() {
              if (leaveController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (leaveController.errorMessage.isNotEmpty) {
                return Center(child: Text(leaveController.errorMessage.value));
              }

              final String selectedStatus;
              switch (tabController.selectedIndex.value) {
                case 1:
                  selectedStatus = 'approved';
                  break;
                case 2:
                  selectedStatus = 'rejected';
                  break;
                default:
                  selectedStatus = 'requested';
              }

              final filteredList = leaveController.leaveList.where((leave) {
                final currentStatus = (leave.status ?? 'requested').toLowerCase();
                if (selectedStatus == 'approved') {
                  return currentStatus == 'approved';
                }
                if (selectedStatus == 'rejected') {
                  return currentStatus == 'rejected' || currentStatus == 'declined';
                }
                return currentStatus != 'approved' &&
                    currentStatus != 'rejected' &&
                    currentStatus != 'declined';
              }).toList();

              if (filteredList.isEmpty) {
                return Center(
                    child: Text("No leave requests found in this category."));
              }

              return ListView.builder(
                itemCount: filteredList.length,
                itemBuilder: (context, index) {
                  final leave = filteredList[index];
                  final currentStatus = leave.status ?? "Requested";

                  // Normalize status
                  String mappedStatus;
                  if (currentStatus.toLowerCase() == 'approved') {
                    mappedStatus = 'approved';
                  } else if (currentStatus.toLowerCase() == 'rejected' ||
                      currentStatus.toLowerCase() == 'declined') {
                    mappedStatus = 'declined';
                  } else {
                    mappedStatus = 'requested';
                  }

                  String leaveDays =
                  _calculateLeaveDays(leave.leaveStartDate, leave.leaveEndDate);

                  return LeaveRequestCard(
                    name: leave.empName ?? "Unknown Employee",
                    department: leave.Department ?? "Unknown Department",
                    leaveDate:
                    "${leave.leaveStartDate ?? ''} - ${leave.leaveEndDate ?? ''}",
                    leaveDays: leaveDays,
                    leaveType: leave.leaveId ?? "General Leave",
                    notes: leave.reason ?? "No reason provided",
                    appliedDate: leave.applyDate ?? "",
                    status: mappedStatus,
                    leaveid: leave.leaveId,
                    profileImageUrl: leave.profileImageUrl,
                    empCode: leave.empCode,
                    leaveName: leave.leaveName,
                    onApprove: mappedStatus == 'requested'
                        ? () => _showConfirmationDialog(
                      context: context,
                      title: "Approve Leave",
                      message: "Approve ${leave.empName}'s leave request?",
                      onConfirmed: () async {
                        leave.status = "Approved";
                        leaveController.leaveList.refresh();

                        await leaveController.updateLeaveStatus(
                          leaveId: leave.leaveId,
                          action: 2,
                          reason: "Approved by manager",
                        );
                      },
                    )
                        : null,
                    onDecline: mappedStatus == 'requested'
                        ? () => _showConfirmationDialog(
                      context: context,
                      title: "Decline Leave",
                      message: "Decline ${leave.empName}'s leave request?",
                      onConfirmed: () async {
                        leave.status = "Rejected";
                        leaveController.leaveList.refresh();

                        await leaveController.updateLeaveStatus(
                          leaveId: leave.leaveId,
                          action: 3,
                          reason: "Rejected by manager",
                        );
                      },
                    )
                        : null,
                  );
                },
              );
            }),
          ),
        ],
      ),)
    );
  }

  String _calculateLeaveDays(String? startDate, String? endDate) {
    if (startDate == null || endDate == null) return "Unknown Duration";

    try {
      DateTime start = DateTime.parse(startDate);
      DateTime end = DateTime.parse(endDate);
      int days = end.difference(start).inDays + 1;
      return "$days Day${days > 1 ? 's' : ''}";
    } catch (_) {
      return "Unknown Duration";
    }
  }

  // ✅ Use Future<void> and async in onConfirmed
  void _showConfirmationDialog({
    required BuildContext context,
    required String title,
    required String message,
    required Future<void> Function() onConfirmed,
  }) {
    Get.dialog(
      CupertinoAlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.back(); // Close the dialog first
              await onConfirmed(); // Now await the async function
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            child: const Text("Confirm", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
