import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_management/core/widgets/App_bar.dart';

import 'Widgets/leave_request.dart';
import 'controllers/leave_request_controller.dart';

class LeaveApprovalScreen extends StatelessWidget {
  final LeaveRequestController leaveController = Get.put(LeaveRequestController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Leave Approval"),
      body: Obx(() {
        if (leaveController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (leaveController.errorMessage.isNotEmpty) {
          return Center(child: Text(leaveController.errorMessage.value));
        }

        if (leaveController.leaveList.isEmpty) {
          return const Center(child: Text("No leave requests found."));
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: leaveController.leaveList.length,
          itemBuilder: (context, index) {
            final leave = leaveController.leaveList[index];
            final currentStatus = leave.status ?? "Requested";

            // Normalize status
            String mappedStatus;
            if (currentStatus.toLowerCase() == 'approved') {
              mappedStatus = 'approved';
            } else if (currentStatus.toLowerCase() == 'rejected' || currentStatus.toLowerCase() == 'declined') {
              mappedStatus = 'declined';
            } else {
              mappedStatus = 'requested';
            }

            String leaveDays = _calculateLeaveDays(leave.leaveStartDate, leave.leaveEndDate);

            return LeaveRequestCard(
              name: leave.empName ?? "Unknown Employee",
              department: leave.Department ?? "Unknown Department",
              leaveDate: "${leave.leaveStartDate ?? ''} - ${leave.leaveEndDate ?? ''}",
              leaveDays: leaveDays,
              leaveType: leave.leaveId ?? "General Leave",
              notes: leave.reason ?? "No reason provided",
              appliedDate: leave.applyDate ?? "",
              status: mappedStatus,
              leaveid: leave.leaveId,
              profileImageUrl: leave.profileImageUrl,

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
