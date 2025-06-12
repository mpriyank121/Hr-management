import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_management/core/widgets/custom_toast.dart';

import '../models/position_model.dart';
import '../services/position_service.dart';

class PositionController extends GetxController {
  var positions = <Position>[].obs;
  var selectedPosition = Rxn<Position>();
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadPositions();
  }

  void loadPositions() async {
    try {
      isLoading.value = true;
      final data = await PositionService.fetchPositions();
      positions.value = data.map((e) => Position.fromJson(e)).toList();
    } catch (e) {
      CustomToast.showMessage(
        context: Get.context!,
        title: "Error",
        message: e.toString(),
        isError: true,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void selectPosition(Position? pos) {
    selectedPosition.value = pos;
  }
}
