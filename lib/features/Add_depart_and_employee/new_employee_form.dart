import 'dart:io';

import 'package:flutter/material.dart';
import '../../config/app_spacing.dart';
import '../../core/widgets/App_bar.dart';
import '../../core/widgets/primary_button.dart';
import '../Company_details/Widgets/custom_text_field.dart';
import '../Company_details/Widgets/dropdown_field.dart';
import '../Company_details/Widgets/section_title.dart';
import '../Company_details/Widgets/upload_card.dart';

class NewEmployeeForm extends StatelessWidget {
   NewEmployeeForm({super.key});
  File? panImage;


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
            const CustomTextField(hint: "example@gmail.com", ),


            const SectionTitle(title: "Website"),
            const CustomTextField(hint: "www.example.com"),


            const SectionTitle(title: "Employee Identification Document"),
            UploadCard(
              title: "Upload your PAN card",
              onImageSelected: (file) => panImage = file,
            ),
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
