import 'package:flutter/material.dart';

import '../../config/app_buttons.dart';
import '../../config/app_text_styles.dart';


class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double? widthFactor;
  final double? heightFactor;
  final Color? buttonColor;
  final Color? textColor;
  final Widget? icon;

  const PrimaryButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.widthFactor,
    this.heightFactor,
    this.buttonColor,
    this.textColor,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(PrimaryButtonConfig.borderRadius),
      splashColor: Colors.white.withOpacity(0.3),
      child: Padding(
        padding: PrimaryButtonConfig.padding,
        child: AnimatedContainer(
          duration: PrimaryButtonConfig.animationDuration,
          width: screenWidth * (widthFactor ?? PrimaryButtonConfig.widthFactor),
          height: screenHeight * (heightFactor ?? PrimaryButtonConfig.heightFactor),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: buttonColor ?? PrimaryButtonConfig.color,
            borderRadius: BorderRadius.circular(PrimaryButtonConfig.borderRadius),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                icon!,
                const SizedBox(width: 8),
              ],
              Text(
                text,
                style: AppTextStyles.buttonText.copyWith(
                  color: textColor ?? Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
