import 'package:flutter/material.dart';
import 'package:hr_management/core/widgets/custom_expansion_tile.dart';

import '../../../config/font_style.dart';

class DepartmentWidget extends StatefulWidget {
  final String title;
  final Widget child;
  final String? departmentId;
  final VoidCallback? onEdit;

  const DepartmentWidget({
    Key? key,
    required this.title,
    required this.child,
    this.departmentId,
    this.onEdit,
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
      child: CustomExpansionTile(
        title: Row(
          children: [
            Expanded(
              child: Text(
                widget.title,
                style: FontStyles.subHeadingStyle(),
              ),
            ),
            if (widget.onEdit != null)
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: widget.onEdit,
              ),
          ],
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
