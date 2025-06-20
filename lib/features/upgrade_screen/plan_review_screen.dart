import 'package:flutter/material.dart';
import 'package:hr_management/config/App_margin.dart';
import 'package:hr_management/config/style.dart';
import 'package:hr_management/config/app_spacing.dart';
import 'package:hr_management/core/widgets/App_bar.dart';
import 'package:hr_management/core/widgets/primary_button.dart';
import 'package:hr_management/features/upgrade_screen/Widgets/plan_card.dart';
import 'model/plan_model.dart';

class PlanReviewScreen extends StatelessWidget {
  final Plan plan;
  final int employeeCount;
  final bool isMonthly;

  const PlanReviewScreen({
    Key? key,
    required this.plan,
    required this.employeeCount,
    required this.isMonthly,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int perEmployeeCost = int.tryParse(isMonthly ? plan.monthlyPrice : plan.yearlyPrice) ?? 0;
    final int totalAmount = perEmployeeCost * employeeCount;
    final int visibleServices = 4;
    final int moreCount = plan.services.length > visibleServices ? plan.services.length - visibleServices : 0;

    return Scaffold(
      appBar: CustomAppBar(
        title: "Plan Review",
      ),
      body: SingleChildScrollView(
        child:  AppMargin(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSpacing.small(context),
              // Plan Card
              PlanCard(plan: plan, isMonthly: isMonthly, showPrimaryButton: false),
              AppSpacing.medium(context),
              // Plan Summary
              Text('Plan Summery', style: fontStyles.headingStyle.copyWith(fontSize: 18)),
              AppSpacing.small(context),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Selected Plan', style: TextStyle(color: Colors.deepOrange)),
                        Text(plan.name, style: fontStyles.headingStyle),
                      ],
                    ),
                    AppSpacing.small(context),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Selected Employee Count', style: fontStyles.subTextStyle),
                        Text('$employeeCount', style: fontStyles.headingStyle),
                      ],
                    ),
                    AppSpacing.small(context),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Per Employee Cost', style: fontStyles.subTextStyle),
                        Text('₹$perEmployeeCost', style: fontStyles.headingStyle),
                      ],
                    ),
                    AppSpacing.small(context),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total Amount', style: fontStyles.headingStyle.copyWith(fontWeight: FontWeight.bold)),
                        Text('₹$totalAmount', style: fontStyles.headingStyle.copyWith(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
              AppSpacing.small(context),
              Center(
                child: Text.rich(
                  TextSpan(
                    text: 'By continuing, you agree to Bookchor ',
                    style: fontStyles.subTextStyle.copyWith(fontSize: 12),
                    children: [
                      TextSpan(
                        text: 'Terms of Use & Policy',
                        style: TextStyle(color: Colors.deepOrange, decoration: TextDecoration.underline),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ])
        )),
      bottomNavigationBar: PrimaryButton(text: 'Pay Now'),
    );
      
  }
} 