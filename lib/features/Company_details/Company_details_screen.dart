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
    controller.fetchIndustries(); // Fetch industries on screen load
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
              onImageSelected: (file) => orgLogo = file,
            ),

            AppSpacing.small(context),

            const SectionTitle(title: "Company Name*"),
            AppSpacing.small(context),
            CustomTextField(hint: "A to Z",
              onChanged: (value) => detailsController.orgName.value = value,),
            AppSpacing.small(context),

            const SectionTitle(title: "Business Field*"),
            AppSpacing.small(context),

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
                  });
                },
              );
            }),

            AppSpacing.small(context),
            const SectionTitle(title: "Address*"),
            AppSpacing.small(context),
             CustomTextField(hint: "A to Z",
              onChanged: (value) => detailsController.address.value = value,),
            AppSpacing.small(context),

            const SectionTitle(title: "Pin Code*"),
            AppSpacing.small(context),
             CustomTextField(hint: "A to Z", keyboardType: TextInputType.number,
              onChanged: (value) => detailsController.pincode.value = value,),
            AppSpacing.small(context),
            const SectionTitle(title: "State"),
            AppSpacing.small(context),
            CustomTextField(hint: "Enter State", keyboardType: TextInputType.number,
              onChanged: (value) => detailsController.state.value = value,),
            AppSpacing.small(context),
            const SectionTitle(title: "City"),
            AppSpacing.small(context),
            CustomTextField(hint: "Enter City", keyboardType: TextInputType.number,
              onChanged: (value) => detailsController.city.value = value,),
            AppSpacing.small(context),

            const SectionTitle(title: "Email*"),
            AppSpacing.small(context),
             CustomTextField(hint: "example@gmail.com", icon: Icons.email,
              onChanged: (value) => detailsController.email.value = value,),
            AppSpacing.small(context),

             SectionTitle(title: "Phone Number*",
              onChanged: (value) => detailsController.address.value = value,),
            AppSpacing.small(context),
            Row(
              children: [
                 Expanded(
                  child: CustomTextField(hint: "+91 | 9876543210", keyboardType: TextInputType.phone,
                    onChanged: (value) => detailsController.phone.value = value,),
                ),
                const SizedBox(width: 8),
                PrimaryButton(
                  heightFactor: 0.06,
                  widthFactor: 0.2,
                  text: "Verify",
                  onPressed: () {},
                ),
              ],
            ),
            AppSpacing.small(context),
            const OtpInputBoxes(),
            AppSpacing.small(context),

            const SectionTitle(title: "Website",
            ),
            AppSpacing.small(context),
             CustomTextField(hint: "www.example.com",
              onChanged: (value) => detailsController.website.value = value,),
            AppSpacing.small(context),

            const SectionTitle(title: "GST Number"),
            AppSpacing.small(context),
             CustomTextField(hint: "Optional",
              onChanged: (value) => detailsController.gstNo.value = value,),
            AppSpacing.small(context),

            const SectionTitle(title: "PAN Number*"),
            AppSpacing.small(context),
             CustomTextField(hint: "A to Z",
               onChanged: (value) => detailsController.panNumber.value = value,),
            AppSpacing.small(context),

            const SectionTitle(title: "Upload PAN"),
            AppSpacing.small(context),

            UploadCard(
              title: "Upload your PAN card",
              onImageSelected: (file) => panImage = file,
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
