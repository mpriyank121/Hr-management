import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hr_management/config/App_margin.dart';
import 'package:hr_management/config/app_spacing.dart';
import 'package:hr_management/config/style.dart';

import '../../../core/widgets/custom_request_button.dart';
import '../controllers/leave_request_controller.dart';

class LeaveRequestCard extends StatelessWidget {
  final String name;
  final String department;
  final String leaveDate;
  final String leaveDays;
  final String leaveType;
  final String notes;
  final String appliedDate;
  final String status; // "approved", "declined", "requested"
  final String? profileImageUrl;
  final VoidCallback? onApprove;
  final VoidCallback? onDecline;
  final VoidCallback? onAttachmentTap;
  final String? leaveid;

   LeaveRequestCard({
    super.key,
    required this.name,
    required this.department,
    required this.leaveDate,
    required this.leaveDays,
    required this.leaveType,
    required this.notes,
    required this.appliedDate,
    required this.status,
    this.profileImageUrl,
    this.onApprove,
    this.onDecline,
    this.onAttachmentTap,
     this.leaveid
  });

  final LeaveRequestController leaveController = Get.put(LeaveRequestController());

  @override
  Widget build(BuildContext context) {
    final isRequested = status == 'requested';

    return AppMargin(
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: status == 'approved'
                ? Colors.green.withOpacity(0.3)
                : status == 'declined'
                    ? Colors.red.withOpacity(0.3)
                    : Colors.blue.withOpacity(0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: (status == 'approved'
                      ? Colors.green
                      : status == 'declined'
                          ? Colors.red
                          : Colors.blue)
                  .withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section with Gradient
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    status == 'approved' 
                        ? Colors.green.withOpacity(0.1)
                        : status == 'declined'
                            ? Colors.red.withOpacity(0.1)
                            : Colors.blue.withOpacity(0.1),
                    Colors.white
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Image with Border
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: status == 'approved'
                            ? Colors.green.withOpacity(0.3)
                            : status == 'declined'
                                ? Colors.red.withOpacity(0.3)
                                : Colors.blue.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.grey[100],
                      backgroundImage: profileImageUrl != null
                          ? NetworkImage('https://img.bookchor.com/$profileImageUrl')
                          : null,
                      child: profileImageUrl == null
                          ? Icon(Icons.person, color: Colors.grey[400], size: 28)
                          : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Name and Department
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: fontStyles.headingStyle.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: status == 'approved'
                                ? Colors.green.withOpacity(0.1)
                                : status == 'declined'
                                    ? Colors.red.withOpacity(0.1)
                                    : Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            department,
                            style: fontStyles.commonTextStyle.copyWith(
                              color: status == 'approved'
                                  ? Colors.green[700]
                                  : status == 'declined'
                                      ? Colors.red[700]
                                      : Colors.blue[700],
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Status or Action Buttons
                  if (isRequested && onApprove != null && onDecline != null)
                    Row(
                      children: [
                        _buildActionButton(
                          "Approve",
                          Colors.green,
                          () {
                            leaveController.updateLeaveStatus(
                              leaveId: leaveid ?? '',
                              action: 2,
                              reason: "Approved",
                            );
                          },
                        ),
                        const SizedBox(width: 8),
                        _buildActionButton(
                          "Decline",
                          Colors.red,
                          () {
                            leaveController.updateLeaveStatus(
                              leaveId: leaveid ?? '',
                              action: 3,
                              reason: "Declined",
                            );
                          },
                        ),
                      ],
                    )
                  else
                    CustomRequestButton(status: status),
                ],
              ),
            ),
            // Leave Details Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Leave Date Card
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: status == 'approved'
                              ? Colors.green[600]
                              : status == 'declined'
                                  ? Colors.red[600]
                                  : Colors.blue[600],
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Leave Date: $leaveDate ($leaveDays)',
                          style: fontStyles.subHeadingStyle.copyWith(
                            fontSize: 10,
                            color: Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Notes Section
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.note_alt_outlined,
                              size: 16,
                              color: status == 'approved'
                                  ? Colors.green[600]
                                  : status == 'declined'
                                      ? Colors.red[600]
                                      : Colors.blue[600],
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Notes',
                              style: fontStyles.headingStyle.copyWith(
                                fontSize: 14,
                                color: Colors.grey[800],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          notes,
                          style: fontStyles.subTextStyle.copyWith(
                            color: Colors.grey[700],
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Applied Date
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: status == 'approved'
                            ? Colors.green[500]
                            : status == 'declined'
                                ? Colors.red[500]
                                : Colors.blue[500],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Applied on: $appliedDate',
                        style: fontStyles.subHeadingStyle.copyWith(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(String text, Color color, VoidCallback onPressed) {
    return Container(
      height: 32, // Reduced height
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextButton(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0), // Reduced padding
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: fontStyles.commonTextStyle.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
            fontSize: 12, // Reduced font size
          ),
        ),
      ),
    );
  }
}
