import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class CompanyDetailsController extends GetxController {
  // Form fields
  var orgName = ''.obs;
  var industryType = ''.obs;
  var phone = ''.obs;
  var email = ''.obs;
  var pincode = ''.obs;
  var state = ''.obs;
  var city = ''.obs;
  var address = ''.obs;
  var website = ''.obs;
  var gstNo = ''.obs;
  var panNumber = ''.obs;

  // File pickers
  File? orgLogo;
  File? panImage;

  // API call
  Future<void> registerCompany() async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://apis-stg.bookchor.com/webservices/hrms/v1/apis.php'),
    );

    request.fields.addAll({
      'type': '109a96a98a100a110a111a109a92a111a100a106a105a103',
      'org_name': orgName.value,
      'industry_type': industryType.value,
      'phone': phone.value,
      'email': email.value,
      'pincode': pincode.value,
      'state': state.value,
      'city': city.value,
      'address': address.value,
      'website': website.value,
      'gst_no': gstNo.value,
      'pan_number': panNumber.value,
    });

    if (panImage != null) {
      request.files.add(await http.MultipartFile.fromPath('pan_image', panImage!.path));
    }

    if (orgLogo != null) {
      request.files.add(await http.MultipartFile.fromPath('org_logo', orgLogo!.path));
    }

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      print('✅ Registration successful: $responseBody');
    } else {
      print('❌ Registration failed: ${response.reasonPhrase}');
    }
  }
}
