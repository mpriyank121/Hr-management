import 'package:flutter/material.dart';
import 'package:hr_management/Configuration/app_buttons.dart';

class CustomContainer extends StatelessWidget {
  final Widget child;
  final double? height;
  final double? width;
  final bool isSelected;


  const CustomContainer({
    Key? key,
    required this.child,
    this.height,
    this.width,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: screenHeight*0.07,
      width: width,
      padding: const EdgeInsets.only(left: 12,right: 0,), // 🔶 Default internal padding
      margin: const EdgeInsets.symmetric(vertical: 10), // 🔶 Space between other elements
      decoration: BoxDecoration(
        color:  Colors.white, // 🔶 Light orange transparent
        borderRadius: BorderRadius.circular(12), // 🔶 Rounded corners
        border: Border.all(color: Colors.grey), // 🔶 Optional subtle border

      ),
      child: child,
    );
  }
}
