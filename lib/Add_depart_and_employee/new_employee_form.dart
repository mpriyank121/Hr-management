import 'package:flutter/material.dart';
import 'package:hr_management/Configuration/app_spacing.dart';
import 'package:hr_management/widgets/App_bar.dart';
import '../Attendence_location/attendence_location.dart';
import '../Company_details/Widgets/custom_text_field.dart';
import '../Company_details/Widgets/dropdown_field.dart';
import '../Company_details/Widgets/otp_input_boxes.dart';
import '../Company_details/Widgets/section_title.dart';
import '../Company_details/Widgets/upload_card.dart';
import '../staff_attendance_settings/staff_attendance_settings_screen.dart';
import '../widgets/primary_button.dart';

class NewEmployeeForm extends StatelessWidget {
  const NewEmployeeForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Add New Employee",
        leading: const BackButton(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const CircleAvatar(radius: 40, backgroundImage: AssetImage('assets/logo.png')),
            const Text("Profile Picture", style: TextStyle(fontSize: 16)),
            const SectionTitle(title: "Full Name"),
            const CustomTextField(hint: "Department Name"),

            const SectionTitle(title: "Position"),
            const DropdownField(),
            const SectionTitle(title: "Employment Status"),
            const DropdownField(),
            const SectionTitle(title: "Department"),
            const DropdownField(),
            const SectionTitle(title: "Gender"),
            const DropdownField(),

            const SectionTitle(title: "Phonenumber"),
            const CustomTextField(hint: "Enter Number", keyboardType: TextInputType.number),

            const SectionTitle(title: "Email*"),
            const CustomTextField(hint: "example@gmail.com", icon: Icons.email),


            const SectionTitle(title: "Website"),
            const CustomTextField(hint: "www.example.com"),


            const SectionTitle(title: "Employee Identification Document"),
            const UploadCard(),
            const SectionTitle(title: "Start Date of Employment"),
            const CustomTextField(hint: "Passport"),
            AppSpacing.medium(context),
            Row(
              children: [
                Expanded(
                  child: PrimaryButton(
                    textColor: const Color(0xFFF25922),
                    buttonColor: const Color(0x19CD0909),
                    text: "Cancel",
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                    child: PrimaryButton(text: "Save")
                ),
              ],
            ),


          ],
        ),
      ),
    );
  }
}
