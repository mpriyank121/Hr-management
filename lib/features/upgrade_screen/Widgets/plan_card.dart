import 'package:flutter/material.dart';
import 'package:hr_management/config/app_spacing.dart';
import 'package:hr_management/core/widgets/primary_button.dart';
import '../model/plan_model.dart'; // Adjust path as needed

class PlanCard extends StatelessWidget {
  final Plan plan;
  final bool isMonthly;
  final bool highlight;
  final String? badgeText;

  const PlanCard({
    super.key,
    required this.plan,
    required this.isMonthly,
    this.highlight = false,
    this.badgeText,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(16),

          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: highlight ? const Color(0xFFF25822) : Colors.grey.shade300,
              width: highlight ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(plan.name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
             AppSpacing.small(context),
              Text(
                '₹${isMonthly ? plan.monthlyPrice : plan.yearlyPrice} / ${isMonthly ? 'Month' : 'Year'}',
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
               Divider(color:  Colors.grey.shade300,),
              ...plan.services.map((service) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                     Image.asset("assets/images/check_plan_icon.png",width: 20,height: 20,),
                   SizedBox(width: 8,),
                    Expanded(child: Text(service.description)),
                  ],
                ),
              )),
               Divider( color:Colors.grey.shade300),
              PrimaryButton(
                onPressed: () {
                  // Navigate or handle selection
                },
                text: (isMonthly ? 'Subscribe Monthly' : 'Subscribe Yearly'),
              ),
            ],
          ),
        ),
        if (badgeText != null)
          Positioned(
            right: 0,

            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.deepOrange,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(badgeText!, style: TextStyle(color: Colors.white)),
            ),
          ),
      ],
    );
  }
}


