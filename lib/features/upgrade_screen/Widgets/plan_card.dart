import 'package:flutter/material.dart';
import '../../../config/font_style.dart';
import '../../../core/widgets/primary_button.dart';
import '../../Company_details/Company_details_screen.dart';


class PlanCard extends StatelessWidget {
  final String title;
  final String price;
  final List<String> features;
  final String buttonText;
  final bool highlight;
  final String? badgeText;

  const PlanCard({
    super.key,
    required this.title,
    required this.price,
    required this.features,
    required this.buttonText,
    this.highlight = false,
    this.badgeText,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(top: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFEEEEEE),
            border: Border.all(
              color: highlight ? const Color(0xFFF25822) : Colors.grey.shade300,
              width: highlight ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// Title
              Text(
                title,
                style: FontStyles.headingStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),

              /// Price
              RichText(
                text: TextSpan(
                  text: price,
                  style: FontStyles.headingStyle(fontSize: 28),
                  children: [
                    TextSpan(
                      text: '/Month',
                      style: FontStyles.subTextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),

              Divider(thickness: 1, color: Colors.grey.shade300),

              /// Features
              ...features.map(
                    (feature) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      const Icon(Icons.check_box, color: Color(0xFFF25822), size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          feature,
                          style: FontStyles.subTextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Divider(thickness: 1, color: Colors.grey.shade300),

              /// Button
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  text: buttonText,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CompanyDetailsScreen(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),

        /// Badge Ribbon
        if (badgeText != null)
          Positioned(
            right: 0,
            top: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: const BoxDecoration(
                color: Color(0xFFF25822),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  topRight: Radius.circular(8),
                ),
              ),
              child: Text(
                badgeText!,
                style: FontStyles.subTextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
