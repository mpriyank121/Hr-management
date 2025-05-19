import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_management/Notification/notification_screen.dart';
import '../Configuration/app_borders.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? leading;
  final String? title;
  final Widget? trailing;
  final List<Widget>? actions;
  final bool showBackButton;
  final bool centerTitle;
  final bool showTrailing; // Set to true on screens that want it

  const CustomAppBar({
    Key? key,
    this.leading,
    this.title,
    this.actions,
    this.showBackButton = true,
    this.centerTitle = true,
    this.trailing,
    this.showTrailing = false, // Default false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppBorders.bottomBorder,
      child: AppBar(
        leading: leading ??
            (showBackButton
                ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Get.back(),
            )
                : null),
        title: Text(title ?? ""),
        centerTitle: centerTitle,
        actions: [
          if (showTrailing && trailing != null) trailing!,
          if (showTrailing)
            IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const NotificationScreen(title: ''),
                  ),
                );
              },
            ),
          if (actions != null) ...actions!,
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
