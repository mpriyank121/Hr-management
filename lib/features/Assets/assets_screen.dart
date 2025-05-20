import 'package:flutter/material.dart';
import '../../config/font_style.dart';
import 'models/asset_list_model.dart';

class AssetsList extends StatelessWidget {
  final List<AssetModel> assetHistory;

  const AssetsList({super.key, required this.assetHistory});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: assetHistory.length,
      shrinkWrap: true, // ✅ Allows embedding in scroll views
      physics: const NeverScrollableScrollPhysics(), // ✅ Prevent nested scroll conflict
      itemBuilder: (context, index) {
        final item = assetHistory[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.white,
            child: Image.asset(
              "assets/images/assets_icon.png",
              fit: BoxFit.contain,
            ),
          ),
          title: Text(
            item.assetName,
            style: FontStyles.subHeadingStyle(),
          ),
          subtitle: Text(
            "Assigned on ${item.assignedDate}",
            style: FontStyles.subTextStyle(),
          ),
          trailing: Text(
            '10,000',
            style: FontStyles.subHeadingStyle(fontWeight: FontWeight.bold),
          ),
          onTap: () {
            // Optional: Navigate to asset detail screen
          },
        );
      },
    );
  }
}
