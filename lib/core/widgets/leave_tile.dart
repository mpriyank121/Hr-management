import 'package:flutter/material.dart';
import 'package:hr_management/config/App_margin.dart';
import 'package:hr_management/config/app_spacing.dart';
import 'package:hr_management/features/Management/Widgets/bordered_container.dart';
import '../../features/Attendence/Models/leave_model.dart';

class LeaveListWidget extends StatelessWidget {
  final List<LeaveModel> leaveList;

  const LeaveListWidget({super.key, required this.leaveList});

  @override
  Widget build(BuildContext context) {
    if (leaveList.isEmpty) {
      return const Center(
        child: Text("No leaves found"),
      );
    }

    return Column(
      children: leaveList.map((leave) {
        return BorderedContainer(
          child:  ExpansionTile(
              tilePadding: EdgeInsets.zero,
              childrenPadding: EdgeInsets.zero,
              title: AppMargin(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            leave.leaveName ?? 'Sick Leave',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          AppSpacing.small(context),
                          Text(
                            _formatDate(leave.startDate, leave.endDate) ?? '8 Jan, 2024',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(leave.status),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _getStatusText(leave.status),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          AppSpacing.small(context),
                          const Icon(
                            Icons.check_circle,
                            color: Colors.white,
                            size: 14,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Divider
                    Divider(
                      color: Colors.grey[300],
                      thickness: 1,
                      height: 1,
                    ),

                    AppSpacing.medium(context),

                    // Leave details container
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Leave Date : ${leave.startDate} - ${leave.endDate}  (${leave.leaveName})',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    AppSpacing.medium(context),

                    // Notes section
                    AppMargin(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Notes:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          AppSpacing.small(context),
                          Text(
                            leave.resson ??
                                "Hello, I'm Not Feeling well and need to request days off sick leave. I've included my doctor's note for your review. Thank you for your understanding.",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),

                    AppSpacing.medium(context),

                    // Attachment section (commented out in original)
                    // if (leave.hasAttachment ?? false)
                    //   AppMargin(
                    //     child: Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         const Text(
                    //           'Attachment:',
                    //           style: TextStyle(
                    //             fontSize: 16,
                    //             fontWeight: FontWeight.w600,
                    //             color: Colors.black87,
                    //           ),
                    //         ),
                    //         AppSpacing.small(context),
                    //         Container(
                    //           padding: const EdgeInsets.all(12),
                    //           decoration: BoxDecoration(
                    //             color: Colors.grey[50],
                    //             borderRadius: BorderRadius.circular(8),
                    //             border: Border.all(color: Colors.grey[300]!),
                    //           ),
                    //           child: Row(
                    //             children: [
                    //               Container(
                    //                 padding: const EdgeInsets.all(8),
                    //                 decoration: BoxDecoration(
                    //                   color: Colors.green[100],
                    //                   borderRadius: BorderRadius.circular(6),
                    //                 ),
                    //                 child: Icon(
                    //                   Icons.description,
                    //                   color: Colors.green[600],
                    //                   size: 20,
                    //                 ),
                    //               ),
                    //               AppSpacing.small(context),
                    //               Expanded(
                    //                 child: Text(
                    //                   leave.notes ?? 'Sick Leave Document.pdf',
                    //                   style: const TextStyle(
                    //                     fontSize: 14,
                    //                     fontWeight: FontWeight.w500,
                    //                     color: Colors.black87,
                    //                   ),
                    //                 ),
                    //               ),
                    //               Icon(
                    //                 Icons.share,
                    //                 color: Colors.grey[600],
                    //                 size: 20,
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //         AppSpacing.medium(context),
                    //       ],
                    //     ),
                    //   ),
                  ],
                ),
              ],
            ));
      }).toList(),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'requested':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.green;
    }
  }

  String _getStatusText(String? status) {
    return status?.capitalize() ?? 'Approved';
  }

  String? _formatDate(String? date, String? endDate) {
    // You can implement proper date formatting here
    // For now, returning a sample format
    return date ?? '8 Jan, 2024';
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}