import 'package:flutter/material.dart';

import '../../../config/font_style.dart';
import '../../Management/Widgets/bordered_container.dart';


class ShiftTimePicker extends StatelessWidget {
  const ShiftTimePicker({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: Text(
            'Shift Timing',
            style: FontStyles.subTextStyle(),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: BorderedContainer(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: TextField(
                    readOnly: true,
                    controller: TextEditingController(text: '10:00 AM'),
                    decoration: const InputDecoration.collapsed(hintText: ''),
                  ),
                ),
              ),
            ),
             Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text('To',style: FontStyles.subTextStyle(),),
            ),
            Expanded(
              child: BorderedContainer(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: TextField(
                    readOnly: true,
                    controller: TextEditingController(text: '07:00 PM'),
                    decoration: const InputDecoration.collapsed(hintText: ''),
                  ),
                ),
              ),
            ),
          ],
        ),
        Divider(thickness: 1, color: Colors.grey.shade300),

      ],
    );
  }
}
