import 'package:get/get.dart';

class SettingsController extends GetxController {
  final RxString orgLogoUrl = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrgLogo();
  }

  // TODO: Replace with your actual API call to fetch the organization logo
  Future<void> fetchOrgLogo() async {
    // This is a placeholder. You should replace this with your actual API call.
    await Future.delayed(const Duration(seconds: 1));
    
    // Example URL - replace with the one from your API response
    orgLogoUrl.value = 'https://w7.pngwing.com/pngs/326/85/png-transparent-google-logo-google-text-trademark-logo.png'; 
  }
} 