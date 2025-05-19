import 'package:flutter/material.dart';
import '../../Configuration/font_style.dart';

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

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
