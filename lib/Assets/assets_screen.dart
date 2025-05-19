import 'package:flutter/material.dart';

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
            child: Image.asset("assets/images/assets_icon.png", fit: BoxFit.contain),
          ),
          title: Text(item.assetName, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text("Assigned on ${item.assignedDate}", style: const TextStyle(color: Colors.grey)),
          trailing: Text('10,000'),
          onTap: () {
            // Optional: Navigate to asset detail screen
          },
        );
      },
    );
  }
}
