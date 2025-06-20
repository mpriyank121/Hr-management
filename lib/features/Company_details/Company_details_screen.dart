import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import '../Add_depart_and_employee/widgets/form_section.dart';
import '../Add_depart_and_employee/widgets/required_text_field.dart';
import '../Add_depart_and_employee/widgets/required_dropdown.dart';
import '../Add_depart_and_employee/utils/validation_utils.dart';
import 'models/industry_model.dart';
import 'package:hr_management/core/widgets/custom_toast.dart';

class CompanyDetailsScreen extends StatefulWidget {
  final String? phone;
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

  final _formKey = GlobalKey<FormState>();
  final RxBool showRequired = false.obs;

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
    showRequired.value = true;
    // Validate form fields
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // For registration mode, check phone verification
    if (!widget.isEditMode && !detailsController.isPhoneVerified.value) {
      CustomToast.showMessage(
        context: context,
        title: "Verification Required",
        message: "Please verify your phone number",
        isError: true,
      );
      return;
    }

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
      'gst_no': _getController('gstNo').text.trim().toUpperCase(),
      'pan_number': _getController('panNumber').text.trim().toUpperCase(),
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

    CustomToast.showMessage(
      context: context,
      title: "Success",
      message: "Company details updated successfully",
      isError: false,
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
        if (widget.isEditMode && orgController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (industryController.industries.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (widget.isEditMode && orgController.organization.value == null && !orgController.isLoading.value) {
          return const Center(child: Text("Failed to load organization data"));
        }

        return AppMargin(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AppSpacing.small(context),
                  FormSection(
                    child: CompanyLogoPicker(
                      title: "Company Logo",
                      initialImage: widget.isEditMode
                          ? orgController.organization.value?.logoUrl
                          : null,
                      onImageSelected: (file) => detailsController.orgLogo = file,
                    ),
                  ),

                  FormSection(
                    title: "Company Name",
                    child: Obx(() => RequiredTextField(
                      hint: "Enter company name",
                      controller: _getController('orgName'),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                      ],
                      validator: ValidationUtils.validateName,
                      showRequired: showRequired.value,
                      fieldName: "company name",
                    )),
                  ),

                  FormSection(
                    title: "Business Field",
                    child: Obx(() => RequiredDropdown<Industry>(
                      value: industryController.industries.firstWhereOrNull((i) => i.id == selectedIndustryId),
                      items: industryController.industries,
                      onChanged: (val) {
                        setState(() {
                          selectedIndustryId = val?.id;
                          if (!widget.isEditMode) {
                            detailsController.industryTypeController.text = val?.id ?? '';
                          }
                        });
                      },
                      hint: "Select Business Field",
                      itemBuilder: (Industry industry) => Text(industry.industry),
                      showRequired: showRequired.value,
                      fieldName: "business field",
                    )),
                  ),

                  FormSection(
                    title: "Address",
                    child: Obx(() => RequiredTextField(
                      hint: "Enter complete address",
                      controller: _getController('address'),
                      validator: ValidationUtils.validateName,
                      showRequired: showRequired.value,
                      fieldName: "address",
                    )),
                  ),

                  FormSection(
                    title: "PIN Code",
                    child: Obx(() => RequiredTextField(
                      hint: "Enter 6-digit PIN code",
                      keyboardType: TextInputType.number,
                      controller: _getController('pincode'),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(6),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'PIN code is required';
                        }
                        if (value.length != 6) {
                          return 'Please enter a valid 6-digit PIN code';
                        }
                        return null;
                      },
                      showRequired: showRequired.value,
                      fieldName: "PIN code",
                      onChanged: (pin) async {
                        // Set userManuallyChangedPincode to true for both edit and registration modes
                        detailsController.userManuallyChangedPincode.value = true;

                        if (pin.length == 6) {
                          await detailsController.onPincodeChanged(pin);
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
                    )),
                  ),

                  FormSection(
                    title: "State",
                    child: CustomTextField(
                      hint: "State will be auto-filled",
                      controller: _getController('state'),
                      enabled: false,
                    ),
                  ),

                  FormSection(
                    title: "City",
                    child: CustomTextField(
                      hint: "City will be auto-filled",
                      controller: _getController('city'),
                      enabled: false,
                    ),
                  ),

                  FormSection(
                    title: "Email",
                    child: Obx(() => RequiredTextField(
                      hint: "example@gmail.com",
                      controller: _getController('email'),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email is required';
                        }
                        final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                        if (!emailRegex.hasMatch(value.trim())) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                      showRequired: showRequired.value,
                      fieldName: "email",
                    )),
                  ),

                  FormSection(
                    title: "Phone Number",
                    child: widget.isEditMode
                        ? CustomTextField(
                            hint: "+91 | Phone",
                            enabled: false,
                            controller: _getController('phone'),
                          )
                        : _buildPhoneWithOTP(),
                  ),

                  if (!widget.isEditMode)
                    Obx(() {
                      if (!detailsController.isOtpSent.value) return const SizedBox.shrink();
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

                  FormSection(
                    title: "Website",
                    child: CustomTextField(
                      hint: "www.example.com",
                      controller: _getController('website'),
                      keyboardType: TextInputType.url,
                    ),
                  ),

                  FormSection(
                    title: "GST Number",
                    child: CustomTextField(
                      hint: "Enter GST number (optional)",
                      controller: _getController('gstNo'),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(15),
                        FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9]')),
                        TextInputFormatter.withFunction((oldValue, newValue) {
                          return newValue.copyWith(text: newValue.text.toUpperCase());
                        }),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) return null;
                        final gstRegex = RegExp(r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$');
                        if (!gstRegex.hasMatch(value.trim().toUpperCase())) {
                          return 'Please enter a valid GST number';
                        }
                        return null;
                      },
                    ),
                  ),

                  FormSection(
                    title: "PAN Number",
                    child: Obx(() => RequiredTextField(
                      hint: "ABCDE1234F",
                      controller: _getController('panNumber'),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(10),
                        FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9]')),
                        TextInputFormatter.withFunction((oldValue, newValue) {
                          return newValue.copyWith(text: newValue.text.toUpperCase());
                        }),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'PAN number is required';
                        }
                        final panRegex = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$');
                        if (!panRegex.hasMatch(value.trim().toUpperCase())) {
                          return 'Please enter a valid PAN number (e.g., ABCDE1234F)';
                        }
                        return null;
                      },
                      showRequired: showRequired.value,
                      fieldName: "PAN number",
                    )),
                  ),

                  FormSection(
                    title: "Upload PAN",
                    child: UploadCard(
                      title: "Upload your PAN card",
                      initialImage: widget.isEditMode
                          ? orgController.organization.value?.panImageUrl
                          : null,
                      onImageSelected: (file) => detailsController.panImage = file,
                    ),
                  ),

                  AppSpacing.small(context),
                  PrimaryButton(
                    text: widget.isEditMode ? "Update" : "Register Now",
                    onPressed: _onSavePressed,
                  ),

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
            child: RequiredTextField(
              hint: "+91 | 9876543210",
              keyboardType: TextInputType.phone,
              controller: _getController('phone'),
              enabled: !detailsController.isPhoneVerified.value,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              validator: ValidationUtils.validatePhone,
              showRequired: showRequired.value,
              fieldName: "phone number",
            ),
          ),
          const SizedBox(width: 8),
          PrimaryButton(
            heightFactor: 0.06,
            widthFactor: 0.3,
            text: buttonText,
            onPressed: () {
              if (detailsController.isPhoneVerified.value) return;

              final phoneValue = _getController('phone').text.trim();
              if (ValidationUtils.validatePhone(phoneValue) != null) {
                CustomToast.showMessage(
                  context: context,
                  title: "Invalid Phone",
                  message: "Please enter a valid 10-digit phone number",
                  isError: true,
                );
                return;
              }
              detailsController.sendOtpToUser();
            },
          ),
        ],
      );
    });
  }
}