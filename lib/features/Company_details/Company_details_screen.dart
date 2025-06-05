import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_management/core/encryption/encryption_helper.dart';
import 'package:hr_management/core/widgets/Leave_Container.dart';
import 'package:hr_management/core/widgets/custom_dropdown.dart';
import 'package:hr_management/features/Company_details/data/organization_service.dart';
import '../../config/app_spacing.dart';
import '../../config/App_margin.dart';
import '../../core/widgets/App_bar.dart';
import '../../core/widgets/Company_logo_picker.dart';
import '../../core/widgets/primary_button.dart';
import '../Company_details/Widgets/custom_text_field.dart';
import '../Company_details/Widgets/otp_input_boxes.dart';
import '../Company_details/Widgets/section_title.dart';
import '../Company_details/Widgets/upload_card.dart';
import '../Company_details/controller/company_details_controller.dart';
import '../Company_details/controller/industry_controller.dart';
import '../Company_details/controller/organization_controller.dart';

class CompanyDetailsScreen extends StatefulWidget {
  final String? phone; // null for registration, provided for editing
  final bool isEditMode;

  const CompanyDetailsScreen({
    super.key,
    this.phone,
    this.isEditMode = false,
  });

  @override
  State<CompanyDetailsScreen> createState() => _CompanyDetailsScreenState();
}

class _CompanyDetailsScreenState extends State<CompanyDetailsScreen> {
  IndustryController industryController = Get.put(IndustryController());
  OrganizationController orgController = Get.put(OrganizationController());
  CompanyDetailsController detailsController = Get.put(CompanyDetailsController());

  String? selectedIndustryId;
  Map<String, dynamic> _originalOrgData = {};
  String? selectedStateId;
  String? selectedCityId;

  // Local controllers for edit mode
  TextEditingController? orgNameController;
  TextEditingController? addressController;
  TextEditingController? pincodeController;
  TextEditingController? emailController;
  TextEditingController? phoneController;
  TextEditingController? websiteController;
  TextEditingController? gstNoController;
  TextEditingController? panNumberController;
  TextEditingController? stateController;
  TextEditingController? cityController;

  @override
  void initState() {
    super.initState();
    industryController.fetchIndustries();


    if (widget.isEditMode) {
      _initializeEditMode();
    }
  }

  void _initializeEditMode() {
    // Initialize controllers for edit mode
    orgNameController = TextEditingController();
    addressController = TextEditingController();
    pincodeController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    websiteController = TextEditingController();
    gstNoController = TextEditingController();
    panNumberController = TextEditingController();
    stateController = TextEditingController();
    cityController = TextEditingController();

    // Load existing data
    if (widget.phone != null) {
      orgController.loadOrganization(widget.phone!).then((_) {
        final org = orgController.organization.value;
        if (org != null) {
          setState(() {
            selectedIndustryId = org.industryType;
            orgNameController?.text = org.orgName ?? '';
            addressController?.text = org.address ?? '';
            pincodeController?.text = org.pincode ?? '';
            stateController?.text = org.state ?? '';
            cityController?.text = org.city ?? '';
            emailController?.text = org.email ?? '';
            phoneController?.text = org.phone ?? '';
            websiteController?.text = org.website ?? '';
            gstNoController?.text = org.gstNo ?? '';
            panNumberController?.text = org.panNumber ?? '';
            selectedStateId = org.stateId;
            selectedCityId = org.cityId;
          });

          // Save original values for comparison
          _originalOrgData = {
            'orgName': org.orgName ?? '',
            'industryType': org.industryType ?? '',
            'address': org.address ?? '',
            'pincode': org.pincode ?? '',
            'state': org.stateId ?? '',
            'city': org.cityId ?? '',
            'email': org.email ?? '',
            'phone': org.phone ?? '',
            'website': org.website ?? '',
            'gstNo': org.gstNo ?? '',
            'panNumber': org.panNumber ?? '',
            'org_logo': org.logoUrl ?? '',
            'pan_image': org.panImageUrl ?? '',
          };
        }
      });
    }
  }

  @override
  void dispose() {
    // Dispose edit mode controllers
    if (widget.isEditMode) {
      orgNameController?.dispose();
      addressController?.dispose();
      pincodeController?.dispose();
      emailController?.dispose();
      phoneController?.dispose();
      websiteController?.dispose();
      gstNoController?.dispose();
      panNumberController?.dispose();
      stateController?.dispose();
      cityController?.dispose();
    }
    super.dispose();
  }

  // Get the appropriate controller based on mode
  TextEditingController _getController(String field) {
    if (widget.isEditMode) {
      switch (field) {
        case 'orgName': return orgNameController!;
        case 'address': return addressController!;
        case 'pincode': return pincodeController!;
        case 'email': return emailController!;
        case 'phone': return phoneController!;
        case 'website': return websiteController!;
        case 'gstNo': return gstNoController!;
        case 'panNumber': return panNumberController!;
        case 'state': return stateController!;
        case 'city': return cityController!;
        default: return TextEditingController();
      }
    } else {
      // Use detailsController for registration mode
      switch (field) {
        case 'orgName': return detailsController.orgNameController;
        case 'address': return detailsController.addressController;
        case 'pincode': return detailsController.pincodeController;
        case 'email': return detailsController.emailController;
        case 'phone': return detailsController.phoneController;
        case 'website': return detailsController.websiteController;
        case 'gstNo': return detailsController.gstNoController;
        case 'panNumber': return detailsController.panNumberController;
        case 'state': return detailsController.stateController;
        case 'city': return detailsController.cityController;
        default: return TextEditingController();
      }
    }
  }

  Future<void> _onSavePressed() async {
    if (widget.isEditMode) {
      await _handleEditSave();
    } else {
      detailsController.registerCompany();
    }
  }

  Future<void> _handleEditSave() async {
    final updatedOrg = {
      'org_name': _getController('orgName').text.trim(),
      'industry_type': selectedIndustryId,
      'address': _getController('address').text.trim(),
      'pincode': _getController('pincode').text.trim(),
      'state': selectedStateId ?? '',
      'city': selectedCityId ?? '',
      'email': _getController('email').text.trim(),
      'phone': _getController('phone').text.trim(),
      'website': _getController('website').text.trim(),
      'gst_no': _getController('gstNo').text.trim(),
      'pan_number': _getController('panNumber').text.trim(),
      'pan_image': detailsController.panImageUrl,
      'org_logo': detailsController.orgLogoUrl,
    };

    bool isProfileChanged = detailsController.orgLogo != null &&
        (detailsController.orgLogoUrl != _originalOrgData['org_logo']);

    bool isPanCardChanged = detailsController.panImage != null &&
        (detailsController.panImageUrl != _originalOrgData['pan_image']);

    await OrganizationService.updateOrganization(
      data: {
        ...updatedOrg,
        'mob': EncryptionHelper.encryptString(_getController('phone').text.trim()),
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
        title: widget.isEditMode ? "Edit Company Details" : "Fill Company Details",
        leading: const BackButton(),
      ),
      body: Obx(() {
        // Show loading for edit mode
        if (widget.isEditMode && orgController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // Show loading for industries
        if (industryController.industries.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        // Show error for edit mode
        if (widget.isEditMode && orgController.organization.value == null && !orgController.isLoading.value) {
          return const Center(child: Text("Failed to load organization data"));
        }

        return AppMargin(
          child: SingleChildScrollView(
            child: Column(
              children: [
                AppSpacing.small(context),
                CompanyLogoPicker(
                  title: "Company Logo",
                  initialImage: widget.isEditMode
                      ? orgController.organization.value?.logoUrl
                      : null,
                  onImageSelected: (file) => detailsController.orgLogo = file,
                ),

                AppSpacing.small(context),
                const SectionTitle(title: "Company Name*"),
                AppSpacing.small(context),
                CustomTextField(
                  hint: "A to Z",
                  controller: _getController('orgName'),
                ),

                AppSpacing.small(context),
                const SectionTitle(title: "Business Field*"),
                AppSpacing.small(context),
                LeaveContainer(
                    child: CustomDropdown(
                  items: industryController.industries.map((industry) {
                    return DropdownMenuItem<String>(
                      value: industry.id,
                      child: Text(industry.industry),
                    );
                  }).toList(),
                  value: selectedIndustryId,
                  onChanged: (value) {
                    setState(() {
                      selectedIndustryId = value;
                      if (!widget.isEditMode) {
                        detailsController.industryTypeController.text = value ?? '';
                      }
                    });
                  },
                )) ,

                AppSpacing.small(context),
                const SectionTitle(title: "Address*"),
                AppSpacing.small(context),
                CustomTextField(
                  hint: "A to Z",
                  controller: _getController('address'),
                ),

                AppSpacing.small(context),
                const SectionTitle(title: "Pin Code*"),
                AppSpacing.small(context),
                CustomTextField(
                  hint: "6-digit PIN",
                  keyboardType: TextInputType.number,
                  controller: _getController('pincode'),
                  onChanged: (pin) async {
                    if (!widget.isEditMode) {
                      detailsController.userManuallyChangedPincode.value = true;
                    }

                    if (pin.length == 6) {
                      await detailsController.onPincodeChanged(pin);

                      // Update state and city for both modes
                      final fetchedState = detailsController.stateController.text;
                      final fetchedCity = detailsController.cityController.text;

                      if (fetchedState.isNotEmpty && fetchedCity.isNotEmpty) {
                        setState(() {
                          _getController('state').text = fetchedState;
                          _getController('city').text = fetchedCity;
                          selectedStateId = detailsController.stateId;
                          selectedCityId = detailsController.cityId;
                        });
                      }
                    }
                  },
                ),

                AppSpacing.small(context),
                const SectionTitle(title: "State"),
                AppSpacing.small(context),
                CustomTextField(
                  hint: "Enter State",
                  controller: _getController('state'),
                ),

                AppSpacing.small(context),
                const SectionTitle(title: "City"),
                AppSpacing.small(context),
                CustomTextField(
                  hint: "Enter City",
                  controller: _getController('city'),
                ),

                AppSpacing.small(context),
                const SectionTitle(title: "Email*"),
                AppSpacing.small(context),
                CustomTextField(
                  hint: "example@gmail.com",
                  controller: _getController('email'),
                ),

                AppSpacing.small(context),
                const SectionTitle(title: "Phone Number*"),
                AppSpacing.small(context),

                // Phone field with OTP for registration, disabled for edit
                if (widget.isEditMode)
                  CustomTextField(
                    hint: "+91 | Phone",
                    enabled: false,
                    controller: _getController('phone'),
                  )
                else
                  _buildPhoneWithOTP(),

                // OTP boxes for registration mode only
                if (!widget.isEditMode)
                  Obx(() {
                    if (!detailsController.isOtpSent.value) return SizedBox.shrink();
                    return Column(
                      children: [
                        AppSpacing.small(context),
                        OtpInputBoxes(
                          enabled: !detailsController.isPhoneVerified.value,
                          onOtpChanged: (otp) {
                            detailsController.otpController.text = otp;
                            if (otp.length == 4 && !detailsController.isPhoneVerified.value) {
                              detailsController.verifyUserOtp();
                            }
                          },
                        ),
                      ],
                    );
                  }),

                AppSpacing.small(context),
                const SectionTitle(title: "Website"),
                AppSpacing.small(context),
                CustomTextField(
                  hint: "www.example.com",
                  controller: _getController('website'),
                ),

                AppSpacing.small(context),
                const SectionTitle(title: "GST Number"),
                AppSpacing.small(context),
                CustomTextField(
                  hint: "Optional",
                  controller: _getController('gstNo'),
                ),

                AppSpacing.small(context),
                const SectionTitle(title: "PAN Number*"),
                AppSpacing.small(context),
                CustomTextField(
                  hint: widget.isEditMode ? "ABCDE1234F" : "A to Z",
                  controller: _getController('panNumber'),
                ),

                AppSpacing.small(context),
                const SectionTitle(title: "Upload PAN"),
                AppSpacing.small(context),
                UploadCard(
                  title: "Upload your PAN card",
                  initialImage: widget.isEditMode
                      ? orgController.organization.value?.panImageUrl
                      : null,
                  onImageSelected: (file) => detailsController.panImage = file,
                ),

                AppSpacing.small(context),
                PrimaryButton(
                  text: widget.isEditMode ? "Save" : "Register Now",
                  onPressed: _onSavePressed,
                ),

                // Terms text only for registration
                if (!widget.isEditMode) ...[
                  AppSpacing.small(context),
                  const Text.rich(
                    TextSpan(
                      text: "By continuing, you agree to Bookchor's ",
                      children: [
                        TextSpan(
                          text: "Terms of Use & Privacy",
                          style: TextStyle(color: Colors.orange),
                        )
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildPhoneWithOTP() {
    return Obx(() {
      String buttonText;
      if (detailsController.isPhoneVerified.value) {
        buttonText = "Verified";
      } else if (detailsController.isOtpSent.value) {
        buttonText = "Resend OTP";
      } else {
        buttonText = "Send OTP";
      }

      return Row(
        children: [
          Expanded(
            child: CustomTextField(
              hint: "+91 | 9876543210",
              keyboardType: TextInputType.phone,
              controller: _getController('phone'),
              enabled: !detailsController.isPhoneVerified.value,
            ),
          ),
          const SizedBox(width: 8),
          PrimaryButton(
            heightFactor: 0.06,
            widthFactor: 0.3,
            text: buttonText,
            onPressed: () {
              if (detailsController.isPhoneVerified.value) return;
              detailsController.sendOtpToUser();
            },
          ),
        ],
      );
    });
  }
}