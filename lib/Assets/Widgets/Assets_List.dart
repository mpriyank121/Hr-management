import 'package:flutter/material.dart';
import '../models/asset_list_model.dart';

class AssetsList extends StatelessWidget {
  final List<AssetModel> assetHistory;

  const AssetsList({super.key, required this.assetHistory});

  @override
  Widget build(BuildContext context) {
    if (assetHistory.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text("No assets assigned.", style: TextStyle(color: Colors.grey)),
        ),
      );
    }

    return ListView.builder(
      itemCount: assetHistory.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final asset = assetHistory[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.grey.shade200,
            child: Image.asset(asset.iconPath, width: 24, height: 24),
          ),
          title: Text(asset.assetName, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text("Assigned on ${asset.assignedDate}", style: const TextStyle(color: Colors.grey)),
        );
      },
    );
  }
}
