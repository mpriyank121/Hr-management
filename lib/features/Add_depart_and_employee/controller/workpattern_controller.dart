import 'package:get/get.dart';
import '../models/work_pattern_model.dart';
import '../services/work_pattern_service.dart'; // adjust path as needed

class WorkPatternController extends GetxController {
  var workPatterns = <WorkPattern>[].obs;
  var selectedPattern = Rxn<WorkPattern>();
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchWorkPatterns();
  }

  Future<void> fetchWorkPatterns() async {
    try {
      isLoading.value = true;
      final patterns = await WorkPatternService.fetchWorkPatterns();
      workPatterns.value = patterns;
      if (patterns.isNotEmpty) {
        selectedPattern.value = patterns.first; // default select first
      }
    } catch (e) {
      print('Error fetching work patterns: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void changeSelectedPattern(WorkPattern? pattern) {
    selectedPattern.value = pattern;
  }
}
