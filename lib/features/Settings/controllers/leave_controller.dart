import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_management/config/app_spacing.dart';
import 'package:hr_management/core/encryption/encryption_helper.dart';
import 'package:hr_management/core/widgets/Leave_Container.dart';
import 'package:hr_management/core/widgets/primary_button.dart';
import '../../../core/shared_pref_helper_class.dart';
import '../../../core/widgets/custom_dropdown.dart';
import '../../Company_details/Widgets/custom_text_field.dart';
import '../models/apply_leave_model.dart';
import '../models/fetch_org_leave.dart';
import '../models/leave_type_model.dart';
import '../services/leave_delete_service.dart';
import '../services/leave_fetch_service.dart';
import 'package:intl/intl.dart';
import 'package:hr_management/core/widgets/custom_toast.dart';

import 'fetch_org_leaves_controller.dart';

class LeaveController extends GetxController {
  final LeaveService _leaveService = LeaveService();
  final LeaveTypeController leaveController = Get.put(LeaveTypeController());

  var availableLeaveTypes = <LeaveTypeModel>[].obs;
  var selectedLeaves = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;
  RxBool isDeleting = false.obs;
  RxString deleteMessage = ''.obs;
  var selectedYear = DateTime
      .now()
      .year
      .obs;

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
      CustomToast.showMessage(
        context: Get.context!,
        title: "Error",
        message: "Failed to load leave types",
        isError: true,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Add a new row to select leave and count
  void addLeaveRowModal(BuildContext context, {OrgLeave? leave}) {

    int selectedYear = DateTime.now().year;
    List<int> getYearsList() {
      final currentYear = DateTime.now().year;
      return List.generate(10, (index) => currentYear - 5 + index);
    }
    final TextEditingController daysController = TextEditingController(
      text: leave?.totalAnnualLeaves ?? '',
    );


    LeaveTypeModel? selectedType;

    // If editing, find and preselect the matching LeaveTypeModel
    if (leave != null) {
      try {
        selectedType = availableLeaveTypes.firstWhere(
              (type) => type.leaveName == leave.leaveName,
        );
      } catch (e) {
        selectedType = null;
      }
    }

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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    leave != null ? "Edit Leave Type" : "Add Leave Type",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  LeaveContainer(
                    child: CustomDropdown<LeaveTypeModel>(
                      value: selectedType,

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

                  Builder(
                    builder: (context) {
                      return LeaveContainer(
                        child: CustomDropdown<int>(
                          value: selectedYear,
                          decoration: const InputDecoration(
                            hintText: "Select Year",
                            border: InputBorder.none,
                          ),
                          items: getYearsList()
                              .map((year) => DropdownMenuItem<int>(
                              value: year,
                              child: Text(year.toString())
                          ))
                              .toList(),
                          onChanged: (year) => setState(() => selectedYear = year ?? selectedYear),

                        ),
                      );
                    },
                  ),

                  AppSpacing.small(context),
                  PrimaryButton(
                    onPressed: () async {
                      if (selectedType != null && daysController.text.isNotEmpty) {
                        final yearController = TextEditingController(
                          text: selectedYear.toString(),
                        );
                        selectedLeaves.add({
                          'type': selectedType,
                          'daysController': TextEditingController(text: daysController.text),
                          'yearController': yearController,
                        });
                        Get.back(); // ✅ Close modal immediately

                        try {
                          await submitLeaves();
                          await leaveController.loadLeaveTypes(year: DateTime.now().year);

                        } catch (e) {
                          CustomToast.showMessage(
                            context: Get.context!,
                            title: "Error",
                            message: "Failed to ${leave != null ? 'update' : 'add'} leave",
                            isError: true,
                          );
                          print("Leave error: $e");
                        }
                      } else {
                        CustomToast.showMessage(
                          context: Get.context!,
                          title: "Error",
                          message: "Please select leave type and enter days",
                          isError: true,
                        );
                      }
                    },
                    text: leave != null ? 'Update' : 'Add',
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


  // Submit leave types with count
  Future<void> submitLeaves() async {
    if (selectedLeaves.isEmpty) {
      CustomToast.showMessage(
        context: Get.context!,
        title: "Validation Error",
        message: "Please select at least one leave type with count.",
        isError: true,
      );
      return;
    }

    isLoading.value = true;

    try {
      for (var leave in selectedLeaves) {
        final type = leave['type'] as LeaveTypeModel?;
        final count = leave['daysController'].text.trim();
        final year = leave['yearController'].text.trim(); // ✅ Get year properly

        if (type == null || count.isEmpty || year.isEmpty) {
          // Skip invalid entries
          continue;
        }

        final res = await _leaveService.submitLeaves(
          mob: '', // still hardcoded
          type: '',
          leaveType: type,
          leaveCount: count,
          year: year, // ✅ Correct value
        );

        responseMessage.value = res;
        print('Leave submitted for type: ${type.id}, year: $year, count: $count');
      }

      CustomToast.showMessage(
        context: Get.context!,
        title: "Success",
        message: "Leaves submitted successfully.",
        isError: false,
      );
    } catch (e) {
      CustomToast.showMessage(
        context: Get.context!,
        title: "Error",
        message: "Failed to submit leave configuration.",
        isError: true,
      );
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

  }) async {

    final storedPhone = await SharedPrefHelper.getPhone();
    print('📞 Phone from SharedPreferences: $storedPhone');
    try {
      applyLeaveLoading.value = true;
      applyLeaveMessage.value = '';

      final request = ApplyLeaveRequest(
        type: '95a110a110a106a119a74a99a95a116a99a100', // your constant type
        empMob: EncryptionHelper.encryptString(
          storedPhone ?? '',
        ), // or get from session if needed
        leaveType: leaveTypeId,
        startDate: startDate,
        endDate: endDate,
        note: note,
      );

      final response = await LeaveService.applyLeave(request);
      debugPrint("ghj ${response}");

      if (response != null) {
        applyLeaveMessage.value = response['message'] ?? '';

        if (response['status'] == true) {
          Get.back();

        } else {
          CustomToast.showMessage(
            context: Get.context!,
            title: "Error",
            message: response['message'] ?? 'Failed to apply leave',
            isError: true,
          );
        }
      } else {
        applyLeaveMessage.value = 'Failed to submit leave application';
        CustomToast.showMessage(
          context: Get.context!,
          title: "Error",
          message: "Failed to submit leave application",
          isError: true,
        );
      }
    } catch (e) {
      applyLeaveMessage.value = 'Error: ${e.toString()}';
      CustomToast.showMessage(
        context: Get.context!,
        title: "Error",
        message: "An error occurred while applying for leave",
        isError: true,
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
      CustomToast.showMessage(
        context: Get.context!,
        title: "Validation Error",
        message: "Please select a leave type",
        isError: true,
      );
      return;
    }

    if (fromDate == null) {
      CustomToast.showMessage(
        context: Get.context!,
        title: "Validation Error",
        message: "Please select start date",
        isError: true,
      );
      return;
    }

    if (toDate == null) {
      CustomToast.showMessage(
        context: Get.context!,
        title: "Validation Error",
        message: "Please select end date",
        isError: true,
      );
      return;
    }

    if (note.trim().isEmpty) {
      CustomToast.showMessage(
        context: Get.context!,
        title: "Validation Error",
        message: "Please enter a reason for leave",
        isError: true,
      );
      return;
    }

    await applyLeave(
      leaveTypeId: selectedLeave.leaveID,
      startDate: DateFormat('yyyy-MM-dd').format(fromDate),
      endDate: DateFormat('yyyy-MM-dd').format(toDate),
      note: note.trim(),
    );
  }
  Future<void> deleteLeave({
    required String type,
    required String id,
  }) async {
    isDeleting.value = true;

    final result = await LeaveDeleteService.deleteLeave(type: type, id: id);
    if (result != null && result['status'] == true) {
      deleteMessage.value = result['message'] ?? 'Deleted successfully';
      CustomToast.showMessage(
        context: Get.context!,
        title: "Success",
        message: deleteMessage.value,
        isError: false,
      );
      //await leaveController.loadLeaveTypes(year: );
      Get.back(); // Close the loader dialog
    } else {
      deleteMessage.value = result?['message'] ?? 'Delete failed';
      CustomToast.showMessage(
        context: Get.context!,
        title: "Error",
        message: deleteMessage.value,
        isError: true,
      );
    }

    isDeleting.value = false;
  }

  void changeYear(int year) {
    selectedYear.value = year;
    fetchLeaveTypes();
  }

}
