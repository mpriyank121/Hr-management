import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_management/config/app_spacing.dart';
import 'package:hr_management/core/encryption/encryption_helper.dart';
import 'package:hr_management/core/widgets/Leave_Container.dart';
import 'package:hr_management/core/widgets/primary_button.dart';
import '../../../core/widgets/custom_dropdown.dart';
import '../../Company_details/Widgets/custom_text_field.dart';
import '../models/apply_leave_model.dart';
import '../models/fetch_org_leave.dart';
import '../models/leave_type_model.dart';
import '../services/leave_fetch_service.dart';
import 'package:intl/intl.dart';

class LeaveController extends GetxController {
  final LeaveService _leaveService = LeaveService();

  var availableLeaveTypes = <LeaveTypeModel>[].obs;
  var selectedLeaves = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  /// API response
  var responseMessage = ''.obs;
  void selectLeaveType(int index, LeaveTypeModel? type) {
    if (index < 0 || index >= selectedLeaves.length) return; // bounds check

    final leaveEntry = selectedLeaves[index];
    leaveEntry['type'] = type;

    // Update the list to trigger observers
    selectedLeaves[index] = leaveEntry;
    selectedLeaves.refresh(); // force reactive update
  }

  @override
  void onInit() {
    super.onInit();
    fetchLeaveTypes();
  }

  // Fetch available leave types from API
  Future<void> fetchLeaveTypes() async {
    try {
      isLoading.value = true;
      availableLeaveTypes.value = await _leaveService.fetchLeaveTypes();
    } catch (e) {
      Get.snackbar("Error", "Failed to load leave types");
    } finally {
      isLoading.value = false;
    }
  }

  // Add a new row to select leave and count
  void addLeaveRowModal(BuildContext context) {
    final TextEditingController daysController = TextEditingController();
    LeaveTypeModel? selectedType;

    Get.bottomSheet(
      SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Add Leave Type",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  LeaveContainer(
                    child: CustomDropdown<LeaveTypeModel>(
                      value: selectedType,
                      isExpanded: true, // Add this line
                      decoration: const InputDecoration(
                        hintText: "Select Leave",
                        border: InputBorder.none,
                      ),
                      items: availableLeaveTypes.map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(type.leaveName),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedType = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: daysController,
                    keyboardType: TextInputType.number,
                    hint: 'Enter number of days',
                  ),
                  AppSpacing.small(context),
                  PrimaryButton(
                    onPressed: () async {
                      if (selectedType != null &&
                          daysController.text.isNotEmpty) {
                        selectedLeaves.add({
                          'type': selectedType,
                          'daysController': TextEditingController(
                            text: daysController.text,
                          ),
                        });

                        print(
                          'Leave added: ${selectedType?.leaveName}, Days: ${daysController.text}',
                        );

                        selectedLeaves.refresh();
                        Get.back(); // Close bottom sheet

                        /// ✅ Call submitLeaves right after adding
                        await submitLeaves();
                      } else {
                        Get.snackbar(
                          "Error",
                          "Please select leave type and enter days",
                        );
                      }
                    },
                    text: 'Add',
                  ),
                ],
              );
            },
          ),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
  }

  // Remove a row
  void removeLeaveRow(int index) {
    selectedLeaves.removeAt(index);
  }

  // Submit leave types with count
  Future<void> submitLeaves() async {
    final leaveTypes = <LeaveTypeModel>[];
    final leaveCounts = <String>[];

    for (var leave in selectedLeaves) {
      final type = leave['type'];
      final count = leave['daysController'].text.trim();

      if (type != null && count.isNotEmpty) {
        leaveTypes.add(type);
        leaveCounts.add(count);
      }
    }

    if (leaveTypes.isEmpty) {
      Get.snackbar(
        "Validation Error",
        "Please select at least one leave type with count.",
      );
      return;
    }

    try {
      isLoading.value = true;
      final res = await _leaveService.submitLeaves(
        mob: '',
        type: '', // already hardcoded in service
        leaveTypes: leaveTypes,
        leaveCounts: leaveCounts,
      );

      responseMessage.value = res;
      Get.snackbar("Success", "Leaves submitted successfully.");
    } catch (e) {
      Get.snackbar("Error", "Failed to submit leave configuration.");
    } finally {
      isLoading.value = false;
    }
  }

  // Add these variables to your LeaveController class
  var applyLeaveLoading = false.obs;
  var applyLeaveMessage = ''.obs;

  // Add this function to your LeaveController class
  Future<void> applyLeave({
    required String leaveTypeId,
    required String startDate,
    required String endDate,
    required String note,
    String? empMob,
  }) async {
    try {
      applyLeaveLoading.value = true;
      applyLeaveMessage.value = '';

      final request = ApplyLeaveRequest(
        type: '95a110a110a106a119a74a99a95a116a99a100', // your constant type
        empMob: EncryptionHelper.encryptString(
          empMob ?? '',
        ), // or get from session if needed
        leaveType: leaveTypeId,
        startDate: startDate,
        endDate: endDate,
        note: note,
      );

      final response = await LeaveService.applyLeave(request);

      if (response != null) {
        applyLeaveMessage.value = response['message'] ?? '';

        if (response['status'] == true) {
          Get.snackbar(
            "Success",
            "Leave application submitted successfully",
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        } else {
          Get.snackbar(
            "Error",
            response['message'] ?? 'Failed to apply leave',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        applyLeaveMessage.value = 'Failed to submit leave application';
        Get.snackbar(
          "Error",
          "Failed to submit leave application",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      applyLeaveMessage.value = 'Error: ${e.toString()}';
      Get.snackbar(
        "Error",
        "An error occurred while applying for leave",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      applyLeaveLoading.value = false;
    }
  }

  // Helper function to format date for API (if needed)
  String formatDateForApi(DateTime date) {
    return "${date.year.toString().padLeft(4, '0')}-"
        "${date.month.toString().padLeft(2, '0')}-"
        "${date.day.toString().padLeft(2, '0')}";
  }

  Future<void> submitLeaveApplication({
    required OrgLeave? selectedLeave,
    required DateTime? fromDate,
    required DateTime? toDate,
    required String note,
  }) async {
    if (selectedLeave == null) {
      Get.snackbar("Validation Error", "Please select a leave type");
      return;
    }

    if (fromDate == null) {
      Get.snackbar("Validation Error", "Please select start date");
      return;
    }

    if (toDate == null) {
      Get.snackbar("Validation Error", "Please select end date");
      return;
    }

    if (note.trim().isEmpty) {
      Get.snackbar("Validation Error", "Please enter a reason for leave");
      return;
    }

    await applyLeave(
      leaveTypeId: selectedLeave.leaveID,
      startDate: DateFormat('yyyy-MM-dd').format(fromDate),
      endDate: DateFormat('yyyy-MM-dd').format(toDate),
      note: note.trim(),
    );
  }

  void editLeaveRow(int index, BuildContext context) {
    final existingLeave = selectedLeaves[index];
    final TextEditingController controllerCopy = TextEditingController(
      text: existingLeave['daysController']?.text ?? '',
    );
    LeaveTypeModel? selectedType = existingLeave['type'];

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Wrap(
          runSpacing: 16,
          children: [
            const Text(
              "Edit Leave Type",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            CustomDropdown<LeaveTypeModel>(
              value: selectedType,
              decoration: const InputDecoration(
                hintText: "Select Leave",
                border: OutlineInputBorder(),
              ),
              items: availableLeaveTypes.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type.leaveName),
                );
              }).toList(),
              onChanged: (value) => selectedType = value,
            ),
            TextField(
              controller: controllerCopy,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Number of Days",
                border: OutlineInputBorder(),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  if (selectedType != null && controllerCopy.text.isNotEmpty) {
                    selectedLeaves[index] = {
                      'type': selectedType,
                      'daysController': controllerCopy,
                    };
                    selectedLeaves.refresh();
                    Get.back();
                  } else {
                    Get.snackbar("Error", "Please complete all fields");
                  }
                },
                child: const Text("Save"),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}
