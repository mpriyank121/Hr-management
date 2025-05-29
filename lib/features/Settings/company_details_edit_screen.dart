import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
import '../Company_details/data/city_state_api_service.dart';

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
        });
        if (org.pincode.isNotEmpty && org.pincode.length == 6) {
          final result = await LocationService.fetchCityStateFromPincode(org.pincode);
          if (result != null) {
            setState(() {
              // Only overwrite if the fields are empty
              if ((org.state ?? '').isEmpty) {
                stateController!.text = result.state ?? '';
              }
              if ((org.city ?? '').isEmpty) {
                cityController!.text = result.city ?? '';
              }
            });
          }
        }

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

  void onSavePressed() {
    final updatedOrg = {
      'orgName': orgNameController.text.trim(),
      'industryType': selectedIndustryId,
      'address': addressController.text.trim(),
      'pincode': pincodeController.text.trim(),
      'state': stateController?.text.trim(),
      'city': cityController?.text.trim(),
      'email': emailController.text.trim(),
      'phone': phoneController.text.trim(),
      'website': websiteController.text.trim(),
      'gstNo': gstNoController.text.trim(),
      'panNumber': panNumberController.text.trim(),
    };

    print('Updated Organization Data: $updatedOrg');

    // TODO: Call update API or method here
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
