import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/app_borders.dart';
import '../../features/Notification/notification_screen.dart';
import '../controllers/settings_controller.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? leading;
  final String? title;
  final Widget? trailing;
  final List<Widget>? actions;
  final bool showBackButton;
  final bool centerTitle;
  final bool showTrailing; // Set to true on screens that want it
  final bool showOrgLogo;

  const CustomAppBar({
    Key? key,
    this.leading,
    this.title,
    this.actions,
    this.showBackButton = true,
    this.centerTitle = true,
    this.trailing,
    this.showTrailing = false, // Default false
    this.showOrgLogo = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SettingsController settingsController = Get.put(SettingsController());
    return Container(
      decoration: AppBorders.bottomBorder,
      child: AppBar(
        leading: leading ?? _buildLeadingWidget(context, settingsController),
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
                    builder: (_) => const NotificationScreen(),
                  ),
                );
              },
            ),
          if (actions != null) ...actions!,
        ],
      ),
    );
  }

  Widget? _buildLeadingWidget(
      BuildContext context, SettingsController settingsController) {
    if (showBackButton) {
      return IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Get.back(),
      );
    }

    if (showOrgLogo) {
      return Obx(() {
        if (settingsController.orgLogoUrl.value.isNotEmpty) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.network(
              settingsController.orgLogoUrl.value,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.business),
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      });
    }

    return null;
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
