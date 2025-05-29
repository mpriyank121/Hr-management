import 'package:get/get.dart';

import '../models/job_type_model.dart';
import '../services/job_type_service.dart';

class JobTypeController extends GetxController {
  var jobTypes = <JobType>[].obs;
  var selectedJobType = Rxn<JobType>();
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadJobTypes();
  }
  void loadJobTypes() async {
    try {
      isLoading.value = true;
      final response = await JobTypeService.fetchJobTypes();

      // Extract the list from the 'data' key
      final jobTypeList = response['data'] as List<dynamic>;

      jobTypes.value = jobTypeList
          .map((item) => JobType.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }




  void selectJobType(JobType? jobType) {
    selectedJobType.value = jobType;
  }
}
