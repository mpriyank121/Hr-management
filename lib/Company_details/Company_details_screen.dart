import 'package:flutter/material.dart';
import 'package:hr_management/Configuration/app_spacing.dart';
import 'package:hr_management/widgets/App_bar.dart';
import '../staff_attendance_settings/staff_attendance_settings_screen.dart';
import 'Widgets/custom_text_field.dart';
import 'Widgets/otp_input_boxes.dart';
import 'Widgets/dropdown_field.dart';
import 'Widgets/upload_card.dart';
import 'Widgets/section_title.dart';
import '../widgets/primary_button.dart';

class CompanyDetailsScreen extends StatelessWidget {
  const CompanyDetailsScreen({super.key});

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
            const CircleAvatar(radius: 40, backgroundImage: AssetImage('assets/logo.png')),
            AppSpacing.small(context),
            const Text("Company Logo", style: TextStyle(fontSize: 16)),
            AppSpacing.small(context),
            const SectionTitle(title: "Company Name*"),
            AppSpacing.small(context),
            const CustomTextField(hint: "A to Z"),
            AppSpacing.small(context),

            const SectionTitle(title: "Business Field*"),
            AppSpacing.small(context),
            const DropdownField(),
            AppSpacing.small(context),

            const SectionTitle(title: "Address*"),
            AppSpacing.small(context),
            const CustomTextField(hint: "A to Z"),
            AppSpacing.small(context),

            const SectionTitle(title: "Pin Code*"),
            AppSpacing.small(context),
            const CustomTextField(hint: "A to Z", keyboardType: TextInputType.number),
            AppSpacing.small(context),
            const SectionTitle(title: "Email*"),
            AppSpacing.small(context),
            const CustomTextField(hint: "example@gmail.com", icon: Icons.email),
            AppSpacing.small(context),
            const SectionTitle(title: "Phone Number*"),
            AppSpacing.small(context),
            Row(
              children: [
                const Expanded(
                  child: CustomTextField(hint: "+91 | 9876543210", keyboardType: TextInputType.phone),
                ),
                const SizedBox(width: 8),
                PrimaryButton(
                  heightFactor: 0.06,
                  widthFactor: 0.2,
                  text: "Verify",
                  onPressed: () {}, ),
              ],
            ),
            AppSpacing.small(context),
            const OtpInputBoxes(),
            AppSpacing.small(context),
            const SectionTitle(title: "Website"),
            AppSpacing.small(context),
            const CustomTextField(hint: "www.example.com"),
            AppSpacing.small(context),
            const SectionTitle(title: "GST Number"),
            AppSpacing.small(context),
            const CustomTextField(hint: "Optional"),
            AppSpacing.small(context),
            const SectionTitle(title: "PAN Number*"),
            AppSpacing.small(context),
            const CustomTextField(hint: "A to Z"),
            AppSpacing.small(context),
            const SectionTitle(title: "Upload PAN"),
            AppSpacing.small(context),
            const UploadCard(),
            AppSpacing.small(context),
            PrimaryButton(
              text: "Register Now",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StaffAttendanceSettingsScreen(),
                  ),
                );
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
