import 'package:flutter/material.dart';
import '../../../config/app_buttons.dart';

class NotificationIconWidget extends StatelessWidget {
  final bool isActive;
  final Widget child;
  final VoidCallback onTap;

  const NotificationIconWidget({
    Key? key,
    required this.isActive,
    required this.child,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 40,
            height: 50,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isActive ?  Color(0xFFFEE7E1) : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isActive ? PrimaryButtonConfig.color : Colors.transparent,
              ),
            ),
            child: child,
          ),
          if (isActive)
            Positioned(
              top: -4,
              right: -4,
              child: Container(
                width: 16,
                height: 16,
                decoration: const BoxDecoration(
                  color:PrimaryButtonConfig.color,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, size: 10, color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}
