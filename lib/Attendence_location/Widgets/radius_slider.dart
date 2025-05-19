import 'package:flutter/material.dart';

class RadiusSliderCard extends StatefulWidget {
  const RadiusSliderCard({super.key});

  @override
  State<RadiusSliderCard> createState() => _RadiusSliderCardState();
}

class _RadiusSliderCardState extends State<RadiusSliderCard> {
  double _radius = 300;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.red[50],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("📍 Maximum Attendance Radius", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text("Staff can make attendance within this radius only"),
            const SizedBox(height: 16),
            Slider(
              value: _radius,
              min: 200,
              max: 500,
              divisions: 3,
              label: "${_radius.toInt()} m",
              onChanged: (value) {
                setState(() {
                  _radius = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
