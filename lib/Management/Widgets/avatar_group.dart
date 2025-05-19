import 'package:flutter/material.dart';

class AvatarGroup extends StatelessWidget {
  final int count;
  const AvatarGroup({required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(count, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.0),
          child: CircleAvatar(radius: 12, backgroundColor: Colors.grey[400]),
        );
      }),
    );
  }
}
