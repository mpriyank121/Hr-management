import 'package:flutter/material.dart';

import '../../../config/font_style.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final Function(dynamic value)? onChanged;

  const SectionTitle({super.key, required this.title, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return  Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: FontStyles.subHeadingStyle(), // Apply your custom style
        ),

    );
  }
}
