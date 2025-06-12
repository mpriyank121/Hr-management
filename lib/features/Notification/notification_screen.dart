import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/app_spacing.dart';
import '../../core/widgets/App_bar.dart';
import '../../core/widgets/Custom_tab_widget.dart';
import '../Assets/assets_screen.dart';
import '../Assets/models/asset_list_model.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key, required this.title});
  final String title;

  @override
  State<NotificationScreen> createState() =>_NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final TabControllerX tabController = Get.put(TabControllerX());



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Notifications",
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [


            AppSpacing.small(context),
          ],
        ),
      ),
    );
  }
}
