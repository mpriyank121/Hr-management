import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationMapView extends StatelessWidget {
  const LocationMapView({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          const GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(28.6272, 77.3640), // RDC Ghaziabad sample
              zoom: 15,
            ),
            zoomControlsEnabled: false,
          ),
          Positioned(
            top: 70,
            left: 100,
            child: Column(
              children: const [
                Icon(Icons.location_pin, size: 40, color: Colors.red),
                Text("Radius: 100 mtrs", style: TextStyle(fontSize: 12, color: Colors.green)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
