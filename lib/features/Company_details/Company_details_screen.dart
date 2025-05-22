import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/app_spacing.dart';
import '../../core/widgets/App_bar.dart';
import '../../core/widgets/Company_logo_picker.dart';
import '../../core/widgets/primary_button.dart';
import 'Widgets/custom_text_field.dart';
import 'Widgets/otp_input_boxes.dart';
import 'Widgets/dropdown_field.dart';
import 'Widgets/upload_card.dart';
import 'Widgets/section_title.dart';
import 'controller/company_details_controller.dart';
import 'controller/industry_controller.dart';

class CompanyDetailsScreen extends StatefulWidget {
  const CompanyDetailsScreen({super.key});

  @override
  State<CompanyDetailsScreen> createState() => _CompanyDetailsScreenState();
}

class _CompanyDetailsScreenState extends State<CompanyDetailsScreen> {
  final IndustryController controller = Get.put(IndustryController());
  final CompanyDetailsController detailsController = Get.put(CompanyDetailsController());

  File? panImage;
  File? orgLogo;
  String? selectedIndustryId;

  @override
  void initState() {
    super.initState();
    controller.fetchIndustries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Fill Company Details",
        leading: const BackButton(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CompanyLogoPicker(
              onImageSelected: (file) => detailsController.orgLogo = file,
            ),

            AppSpacing.small(context),

            const SectionTitle(title: "Company Name*"),
            CustomTextField(
              hint: "A to Z",
              controller: detailsController.orgNameController,
            ),

            AppSpacing.small(context),
            const SectionTitle(title: "Business Field*"),

            Obx(() {
              return DropdownField(
                items: controller.industries.map((industry) {
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
                    detailsController.industryTypeController.text = value ?? '';
                  });
                },
              );
            }),

            AppSpacing.small(context),
            const SectionTitle(title: "Address*"),
            CustomTextField(
              hint: "A to Z",
              controller: detailsController.addressController,
            ),

            AppSpacing.small(context),
            const SectionTitle(title: "Pin Code*"),
            CustomTextField(
              hint: "6-digit PIN",
              keyboardType: TextInputType.number,
              controller: detailsController.pincodeController,
              onChanged: detailsController.onPincodeChanged,
            ),

            AppSpacing.small(context),
            const SectionTitle(title: "State"),
            CustomTextField(
              hint: "Enter State",
              controller: detailsController.stateController,
            ),

            AppSpacing.small(context),
            const SectionTitle(title: "City"),
            CustomTextField(
              hint: "Enter City",
              controller: detailsController.cityController,
            ),

            AppSpacing.small(context),
            const SectionTitle(title: "Email*"),
            CustomTextField(
              hint: "example@gmail.com",
              controller: detailsController.emailController,
            ),

            AppSpacing.small(context),
            const SectionTitle(title: "Phone Number*"),
            Obx(() {
              // Button text logic
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
                      controller: detailsController.phoneController,
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

                      detailsController.sendOtpToUser(); // handles send & resend internally
                    },
                  ),
                ],
              );
            }),


            AppSpacing.small(context),
            Obx(() {
              if (!detailsController.isOtpSent.value) return SizedBox.shrink();

              return OtpInputBoxes(
                enabled: !detailsController.isPhoneVerified.value,
                onOtpChanged: (otp) {
                  detailsController.otpController.text = otp;

                  // Auto-verify when 4 digits are entered
                  if (otp.length == 4 && !detailsController.isPhoneVerified.value) {
                    detailsController.verifyUserOtp();
                  }
                },
              );
            }),



            AppSpacing.small(context),
            const SectionTitle(title: "Website"),
            CustomTextField(
              hint: "www.example.com",
              controller: detailsController.websiteController,
            ),

            AppSpacing.small(context),
            const SectionTitle(title: "GST Number"),
            CustomTextField(
              hint: "Optional",
              controller: detailsController.gstNoController,
            ),

            AppSpacing.small(context),
            const SectionTitle(title: "PAN Number*"),
            CustomTextField(
              hint: "A to Z",
              controller: detailsController.panNumberController,
            ),

            AppSpacing.small(context),
            const SectionTitle(title: "Upload PAN"),
            UploadCard(
              title: "Upload your PAN card",
              onImageSelected: (file) => detailsController.panImage = file,
            ),

            AppSpacing.small(context),
            PrimaryButton(
              text: "Register Now",
              onPressed: () {
                detailsController.registerCompany();
              },
            ),

            AppSpacing.small(context),
            const Text.rich(
              TextSpan(
                text: "By continuing, you agree to Bookchor’s ",
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
        ),
      ),
    );
  }
}
