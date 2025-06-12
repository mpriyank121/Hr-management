import 'package:flutter/material.dart';
import 'package:hr_management/config/app_spacing.dart';
import 'package:hr_management/features/Company_details/Widgets/section_title.dart';

class FormSection extends StatelessWidget {
  final String? title;
  final Widget child;

  const FormSection({
    super.key,
    this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (title != null) ...[
          AppSpacing.small(context),
          SectionTitle(title: title!),
          AppSpacing.small(context),
        ],
        child,
      ],
    );
  }
}
