import 'package:flutter/material.dart';
import '../widgets/primary_button.dart';
import 'Widgets/location_input_field.dart';
import 'Widgets/location_map_view.dart';
import 'Widgets/radius_slider.dart';

class AttendanceLocationSetupScreen extends StatelessWidget {
  const AttendanceLocationSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setup Attendance Location'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const LocationMapView(),
            const SizedBox(height: 16),
            const Text(
              "Tell us your company address!\n& set geofence radius",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            const LocationInputField(),
            const SizedBox(height: 16),
            const RadiusSliderCard(),
            const SizedBox(height: 24),
            PrimaryButton(
              text: "Continue",
              onPressed: () {
                // Handle continue action
              },
            )
          ],
        ),
      ),
    );
  }
}
