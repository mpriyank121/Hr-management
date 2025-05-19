import 'package:flutter/material.dart';

class LocationInputField extends StatelessWidget {
  const LocationInputField({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Company Location", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                initialValue: "RDC Ghaziabad",
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 8),
            TextButton(
              onPressed: () {}, // Implement location change
              child: const Text("Change"),
            ),
          ],
        ),
      ],
    );
  }
}
