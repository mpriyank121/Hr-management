import 'package:flutter/material.dart';

import '../../../config/font_style.dart';

class StatTile extends StatelessWidget {
  final Widget icon;
  final String percent;
  final String title;
  final String subtitle;
  final Color percentColor;
  final Color borderColor;

  const StatTile({
    Key? key,
    required this.icon,
    required this.percent,
    required this.title,
    required this.subtitle,
    required this.percentColor,
    this.borderColor = const Color(0xFFE0E0E0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          border: Border.all(color: borderColor),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Icon/Image with border
            Container(
              width: 40,
              height: 40,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Center(child: icon),
            ),
            const SizedBox(width: 12),

            /// Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    percent,
                    style: FontStyles.subTextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: percentColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    style: FontStyles.subHeadingStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: FontStyles.subTextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
