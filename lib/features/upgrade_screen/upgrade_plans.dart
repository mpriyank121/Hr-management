import 'package:flutter/material.dart';
import '../../config/App_margin.dart';
import '../../config/app_spacing.dart';
import '../../core/widgets/App_bar.dart';
import 'Widgets/plan_card.dart';

class UpgradePlanScreen extends StatelessWidget {
  const UpgradePlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Upgrade Plan",
        leading: const BackButton(),
      ),
      body:AppMargin(child: ListView(
        children:  [
          AppSpacing.small(context),
          PlanCard(
            title: 'Basic Plan',
            price: '299',
            features: [
              'Worked days',
              'Worked days',
              'You can add 10 employees',
              'Worked days',
            ],
            buttonText: 'Free for 1 Month',
          ),
          AppSpacing.small(context),
          PlanCard(
            title: 'Pro Plan',
            price: '599',
            features: [
              'Worked days',
              'Worked days',
              'Worked days',
              'Worked days',
            ],
            buttonText: 'Continue',
            highlight: true,
            badgeText: 'Most Popular',
          ),
          AppSpacing.small(context),
          PlanCard(
            title: 'Premium Plan',
            price: '1999',
            features: [
              'Worked days',
              'Worked days',
              'Worked days',
              'Worked days',
            ],
            buttonText: 'Continue',
          ),
        ],
      ),)
    );
  }
}
