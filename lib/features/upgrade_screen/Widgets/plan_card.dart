import 'package:flutter/material.dart';
import 'package:hr_management/config/app_spacing.dart';
import 'package:hr_management/config/style.dart';
import 'package:hr_management/core/widgets/primary_button.dart';
import 'package:hr_management/features/Company_details/Widgets/custom_text_field.dart';
import '../model/plan_model.dart';
import '../plan_review_screen.dart'; // Adjust path as needed


class PlanCard extends StatefulWidget {
  final Plan plan;
  final bool isMonthly;
  final bool highlight;
  final String? badgeText;
  final bool showPrimaryButton;

  const PlanCard({
    super.key,
    required this.plan,
    required this.isMonthly,
    this.highlight = false,
    this.badgeText,
    this.showPrimaryButton = true,
  });

  @override
  State<PlanCard> createState() => _PlanCardState();
}

class _PlanCardState extends State<PlanCard> {
  int? selectedEmployeeCount;

  void _showEmployeeCountSelector(BuildContext context) async {
    final result = await showModalBottomSheet<int>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) => EmployeeCountSelector(),
    );
    if (result != null) {
      setState(() {
        selectedEmployeeCount = result;
      });
      // Proceed with navigation or logic after selection
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PlanReviewScreen(
            plan: widget.plan,
            employeeCount: result,
            isMonthly: widget.isMonthly,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: widget.highlight ? const Color(0xFFF25822) : Colors.grey.shade300,
              width: widget.highlight ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(widget.plan.name, style: fontStyles.headingStyle),
              AppSpacing.small(context),
              Text(
                '₹${widget.isMonthly ? widget.plan.monthlyPrice : widget.plan.yearlyPrice} / ${widget.isMonthly ? 'Month/Person' : 'Year/Person'}',
                style: fontStyles.subTextStyle,
              ),
              Divider(color: Colors.grey.shade300,),
              ...widget.plan.services.map((service) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Image.asset("assets/images/check_plan_icon.png",width: 20,height: 20,),
                    SizedBox(width: 8,),
                    Expanded(child: Text(service.description)),
                  ],
                ),
              )),
              Divider(color: Colors.grey.shade300),
              if (widget.showPrimaryButton)
                PrimaryButton(
                  onPressed: () => _showEmployeeCountSelector(context),
                  text: (widget.isMonthly ? 'Subscribe Monthly' : 'Subscribe Yearly'),
                ),
            ],
          ),
        ),
        if (widget.badgeText != null)
          Positioned(
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.deepOrange,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(widget.badgeText!, style: TextStyle(color: Colors.white)),
            ),
          ),
      ],
    );
  }
}

class EmployeeCountSelector extends StatefulWidget {
  @override
  _EmployeeCountSelectorState createState() => _EmployeeCountSelectorState();
}

class _EmployeeCountSelectorState extends State<EmployeeCountSelector> {
  int? selectedCount;
  final List<int> counts = List.generate(99, (index) => index + 2); // 2 to 100
  final TextEditingController manualController = TextEditingController();
  String? manualError;

  @override
  void dispose() {
    manualController.dispose();
    super.dispose();
  }

  void _onManualChanged(String value) {
    setState(() {
      manualError = null;
      if (value.isEmpty) {
        selectedCount = null;
        return;
      }
      final num = int.tryParse(value);
      if (num == null || num < 2 || num > 1000) {
        manualError = 'Enter a number between 2 and 100';
        selectedCount = null;
      } else {
        selectedCount = num;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Select Employee Count", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          AppSpacing.small(context),
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: counts.length,
              itemBuilder: (context, index) {
                final count = counts[index];
                final isSelected = selectedCount == count && manualController.text.isEmpty;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCount = count;
                      manualController.clear();
                      manualError = null;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 6),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.deepOrange : Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                      border: isSelected ? Border.all(color: Colors.deepOrange, width: 2) : null,
                    ),
                    child: Text(
                      '$count',
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          AppSpacing.small(context),

          Text(
            "Select Custom Employee count",
            style: fontStyles.subTextStyle,
            textAlign: TextAlign.start,
          ),
          AppSpacing.small(context),


          CustomTextField(
            controller: manualController,
            keyboardType: TextInputType.number,

            onChanged: _onManualChanged, hint: 'Enter employee count',
          ),
          AppSpacing.small(context),

          PrimaryButton(
            onPressed: selectedCount != null
                ? () => Navigator.pop(context, selectedCount)
                : null,
            text: "Next",
          ),
        ],
      ),
    );
  }
}


