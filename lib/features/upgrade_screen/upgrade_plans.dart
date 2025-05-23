import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/App_margin.dart';
import '../../config/app_spacing.dart';
import '../../core/widgets/App_bar.dart';
import '../../core/widgets/custom_tab_widget.dart';
import 'Widgets/plan_card.dart';
import 'controllers/plan_controller.dart';
import 'data/plan_api_service.dart';


class UpgradePlanScreen extends StatelessWidget {
  const UpgradePlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final PlanController planController = Get.put(PlanController(apiService: PlanService()));
    final TabControllerX tabController = Get.put(TabControllerX());

    // Fetch plans on init
    planController.fetchPlans();

    return Scaffold(
      appBar: CustomAppBar(
        title: "Upgrade Plan",
        leading:  BackButton(),
      ),
      body: AppMargin(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppSpacing.small(context),
            CustomTabWidget(
              tabTitles: ["Monthly", "Yearly"],
              controller: tabController,
            ),
            AppSpacing.small(context),
            Expanded(
              child: Obx(() {
                if (planController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (planController.errorMessage.isNotEmpty) {
                  return Center(child: Text(planController.errorMessage.value));
                }

                if (planController.plans.isEmpty) {
                  return const Center(child: Text("No plans available."));
                }

                bool isMonthly = tabController.selectedIndex.value == 0;

                return ListView.separated(
                  itemCount: planController.plans.length,
                  separatorBuilder: (_, __) => AppSpacing.small(context),
                  itemBuilder: (context, index) {
                    final plan = planController.plans[index];
                    return PlanCard(
                      plan: plan,
                      isMonthly: isMonthly,
                      highlight: index == 1,
                      badgeText: index == 1 ? 'Most Popular' : null,
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
