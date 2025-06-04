import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_management/core/encryption/encryption_helper.dart';
import 'package:hr_management/features/Company_details/data/organization_service.dart';
import '../../config/app_spacing.dart';
import '../../core/widgets/App_bar.dart';
import '../../core/widgets/Company_logo_picker.dart';
import '../../core/widgets/primary_button.dart';
import '../Company_details/Widgets/custom_text_field.dart';
import '../Company_details/Widgets/dropdown_field.dart';
import '../Company_details/Widgets/section_title.dart';
import '../Company_details/Widgets/upload_card.dart';
import '../Company_details/controller/company_details_controller.dart';
import '../Company_details/controller/industry_controller.dart';
import '../Company_details/controller/organization_controller.dart';


class CompanyDetailsEditScreen extends StatefulWidget {
  final String Phone;

  const CompanyDetailsEditScreen({super.key, required this.Phone});

  @override
  State<CompanyDetailsEditScreen> createState() => _CompanyDetailsEditScreenState();
}

class _CompanyDetailsEditScreenState extends State<CompanyDetailsEditScreen> {
  IndustryController industryController = Get.put(IndustryController());
  OrganizationController orgController = Get.put(OrganizationController());
  CompanyDetailsController detailsController = Get.put(CompanyDetailsController());

  String? selectedIndustryId;

  // TextEditingControllers for fields
  late TextEditingController orgNameController;
  late TextEditingController addressController;
  late TextEditingController pincodeController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController websiteController;
  late TextEditingController gstNoController;
  late TextEditingController panNumberController;
  late Map<String, dynamic> _originalOrgData;
  File? _initialLogoFile;
  File? _initialPanFile;
  String? selectedStateId;
  String? selectedCityId;



  TextEditingController? stateController;
  TextEditingController? cityController;

  @override
  void initState() {
    super.initState();
    industryController.fetchIndustries();
    stateController = TextEditingController(); // <-- Add this
    cityController = TextEditingController();

    // Initialize controllers
    orgNameController = TextEditingController();
    addressController = TextEditingController();
    pincodeController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    websiteController = TextEditingController();
    gstNoController = TextEditingController();
    panNumberController = TextEditingController();


    // Load data and prefill
    orgController.loadOrganization(widget.Phone).then((_) async {
      final org = orgController.organization.value;
      if (org != null) {
        setState(() {
          selectedIndustryId = org.industryType;
          orgNameController.text = org.orgName;
          addressController.text = org.address;
          pincodeController.text = org.pincode;
          stateController?.text = org.state;
          cityController?.text = org.city;
          emailController.text = org.email;
          phoneController.text = org.phone;
          websiteController.text = org.website;
          gstNoController.text = org.gstNo;
          panNumberController.text = org.panNumber;
          selectedStateId = org.stateId;
          selectedCityId = org.cityId;
        });

        // Save original values for comparison
        _originalOrgData = {
          'orgName': org.orgName,
          'industryType': org.industryType,
          'address': org.address,
          'pincode': org.pincode,
          'state': org.stateId,
          'city': org.cityId,
          'email': org.email,
          'phone': org.phone,
          'website': org.website,
          'gstNo': org.gstNo,
          'panNumber': org.panNumber,
        };

        // Save original image URLs
        _initialLogoFile = null; // Because initial is a URL
        _initialPanFile = null;
      }

    });
  }

  @override
  void dispose() {
    orgNameController.dispose();
    addressController.dispose();
    pincodeController.dispose();
    emailController.dispose();
    phoneController.dispose();
    websiteController.dispose();
    gstNoController.dispose();
    panNumberController.dispose();
    super.dispose();
  }

  Future<void> onSavePressed() async {
    final updatedOrg = {
      'org_name': orgNameController.text.trim(),
      'industry_type': selectedIndustryId,
      'address': addressController.text.trim(),
      'pincode': pincodeController.text.trim(),
      'state': selectedStateId ?? '',
      'city': selectedCityId ?? '',
      'email': emailController.text.trim(),
      'phone': phoneController.text.trim(),
      'website': websiteController.text.trim(),
      'gst_no': gstNoController.text.trim(),
      'pan_number': panNumberController.text.trim(),
      'pan_image': detailsController.panImageUrl,
      'org_logo': detailsController.orgLogoUrl,
    };

    // Check if any profile field has changed

    bool isProfileChanged = detailsController.orgLogo != null &&
        (detailsController.orgLogoUrl != _originalOrgData['org_logo']);

    bool isPanCardChanged = detailsController.panImage != null &&
        (detailsController.panImageUrl != _originalOrgData['pan_image']);

    final payload = {
      ...updatedOrg,
      'islogochange': isProfileChanged ? true : false,
      'ispanchange': isPanCardChanged ? true : false,
      'org_logo': isProfileChanged ? detailsController.orgLogoUrl : '',
      'pan_image': isPanCardChanged ? detailsController.panImageUrl : '',
    };
    print('Final Payload: $payload');
    await OrganizationService.updateOrganization(
      data: {
        ...updatedOrg,
        'mob': EncryptionHelper.encryptString(phoneController.text.trim()),
      },
      isProfileChanged: isProfileChanged,
      isPanCardChanged: isPanCardChanged,
      orgLogo: isProfileChanged ? detailsController.orgLogo : null,
      panImage: isPanCardChanged ? detailsController.panImage : null,
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Edit Company Details",
        leading: const BackButton(),
      ),
      body: Obx(() {
        if (orgController.isLoading.value || industryController.industries.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        final org = orgController.organization.value;
        if (org == null) {
          return const Center(child: Text("Failed to load organization data"));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              CompanyLogoPicker(
                initialImage: org.logoUrl,  // or the field that contains logo URL
                  onImageSelected: (file) => detailsController.orgLogo = file,
              ),
              AppSpacing.small(context),
              const SectionTitle(title: "Company Name*"),
              CustomTextField(
                hint: "A to Z",
                controller: orgNameController,
              ),

              AppSpacing.small(context),
              const SectionTitle(title: "Business Field*"),
              DropdownField(
                items: industryController.industries.map((industry) {
                  return DropdownMenuItem<String>(
                    value: industry.id,
                    child: Text(industry.industry),
                  );
                }).toList(),
                value: selectedIndustryId,
                hintText: 'Select Industry',
                onChanged: (value) {
                  setState(() {
                    selectedIndustryId = value;
                  });
                },
              ),

              AppSpacing.small(context),
              const SectionTitle(title: "Address*"),
              CustomTextField(
                hint: "A to Z",
                controller: addressController,
              ),

              AppSpacing.small(context),
              const SectionTitle(title: "Pin Code*"),
              CustomTextField(
                hint: "6-digit PIN",
                keyboardType: TextInputType.number,
                controller: pincodeController,
                onChanged: (pin) async {
                  detailsController.userManuallyChangedPincode.value = true;

                  if (pin.length == 6) {
                    await detailsController.onPincodeChanged(pin);

                    // Only update if city and state are not empty/null
                    final fetchedState = detailsController.stateController.text;
                    final fetchedCity = detailsController.cityController.text;

                    if (fetchedState.isNotEmpty && fetchedCity.isNotEmpty) {
                      setState(() {
                        stateController?.text = fetchedState;
                        cityController?.text = fetchedCity;

                        selectedStateId = detailsController.stateId;  // <-- Make sure this is set
                        selectedCityId = detailsController.cityId;    // <-- Make sure this is set
                      });
                    }

                  }
                },
              ),


              AppSpacing.small(context),
              const SectionTitle(title: "State"),
              CustomTextField(
                hint: "Enter State",
                controller: stateController,
              ),

              AppSpacing.small(context),
              const SectionTitle(title: "City"),
              CustomTextField(
                hint: "Enter City",
              controller: cityController,
              ),

              AppSpacing.small(context),
              const SectionTitle(title: "Email*"),
              CustomTextField(
                hint: "example@gmail.com",
                controller: emailController,
              ),

              AppSpacing.small(context),
              const SectionTitle(title: "Phone Number*"),
              CustomTextField(
                hint: "+91 | Phone",
                enabled: false,
                controller: phoneController,
              ),

              AppSpacing.small(context),
              const SectionTitle(title: "Website"),
              CustomTextField(
                hint: "www.example.com",
                controller: websiteController,
              ),

              AppSpacing.small(context),
              const SectionTitle(title: "GST Number"),
              CustomTextField(
                hint: "Optional",
                controller: gstNoController,
              ),

              AppSpacing.small(context),
              const SectionTitle(title: "PAN Number*"),
              CustomTextField(
                hint: "ABCDE1234F",
                controller: panNumberController,
              ),
              const SectionTitle(title: "Upload PAN"),
              UploadCard(
                title: "Upload your PAN card",
                initialImage: org.panImageUrl,
                onImageSelected: (file) => detailsController.panImage = file,
              ),
              AppSpacing.small(context),
              PrimaryButton(
                text: "Save",
                onPressed: onSavePressed,
              ),
            ],
          ),
        );
      }),
    );
  }
}
