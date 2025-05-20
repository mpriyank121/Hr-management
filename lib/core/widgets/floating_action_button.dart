import 'package:flutter/material.dart';

class FloatingActionButtonWithMenu extends StatefulWidget {
  final void Function(String) onMenuItemSelected;

  const FloatingActionButtonWithMenu({
    Key? key,
    required this.onMenuItemSelected,
  }) : super(key: key);

  @override
  _FloatingActionButtonWithMenuState createState() =>
      _FloatingActionButtonWithMenuState();
}

class _FloatingActionButtonWithMenuState
    extends State<FloatingActionButtonWithMenu> {
  final GlobalKey _fabKey = GlobalKey();

  void _showPopupMenu() {
    final RenderBox renderBox =
    _fabKey.currentContext!.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);

    showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy,
        offset.dx + renderBox.size.width,
        offset.dy + renderBox.size.height,
      ),
      items: [
        PopupMenuItem(
          value: 'department',
          child: Row(
            children: const [
              Icon(Icons.apartment, size: 18),
              SizedBox(width: 8),
              Text('Department'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'employee',
          child: Row(
            children: const [
              Icon(Icons.person, size: 18),
              SizedBox(width: 8),
              Text('Employee'),
            ],
          ),
        ),
      ],
      elevation: 8,
    ).then((selectedValue) {
      if (selectedValue != null) {
        widget.onMenuItemSelected(selectedValue);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      key: _fabKey,
      onPressed: _showPopupMenu,
      child: const Icon(Icons.add),
      backgroundColor: Colors.deepOrange,
    );
  }
}
