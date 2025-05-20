import 'package:flutter/material.dart';

import '../../../config/font_style.dart';

class DepartmentWidget extends StatefulWidget {
  final String title;
  final Widget child;

  const DepartmentWidget({
    Key? key,
    required this.title,
    required this.child,
  }) : super(key: key);

  @override
  _DepartmentWidgetState createState() => _DepartmentWidgetState();
}

class _DepartmentWidgetState extends State<DepartmentWidget> {
  bool expanded = true;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        title: Text(
          widget.title,
          style: FontStyles.subHeadingStyle(), // Applied custom style
        ),
        initiallyExpanded: expanded,
        onExpansionChanged: (val) {
          setState(() {
            expanded = val;
          });
        },
        children: [
          Container(
            child: widget.child,
          ),
        ],
      ),
    );
  }
}
