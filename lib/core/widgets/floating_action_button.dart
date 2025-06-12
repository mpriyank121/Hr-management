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
  OverlayEntry? _overlayEntry;

  void _showCustomMenu() {
    final RenderBox renderBox =
    _fabKey.currentContext!.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final Size size = renderBox.size;

    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double menuHeight = 100; // Approximate total height of the menu
    final double menuWidth = 150; // Approximate width of the menu

    // Determine if we have enough space above the FAB
    bool showAbove = offset.dy > menuHeight + 20;

    // Calculate horizontal position to prevent cropping
    double leftPosition = offset.dx;

    // If menu would go off the right edge, align it to the right edge of FAB
    if (leftPosition + menuWidth > screenWidth) {
      leftPosition = offset.dx + size.width - menuWidth;
    }

    // Ensure it doesn't go off the left edge
    if (leftPosition < 16) {
      leftPosition = 16;
    }

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Dark transparent background
          GestureDetector(
            onTap: _removeOverlay,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.black54,
            ),
          ),
          Positioned(
            left: leftPosition,
            top: showAbove ? offset.dy - menuHeight - 8 : offset.dy + size.height + 8,
            child: Material(
              elevation: 8,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: menuWidth,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildMenuItem(
                      icon: Icons.apartment,
                      text: 'Department',
                      value: 'department',
                    ),
                    _buildMenuItem(
                      icon: Icons.person,
                      text: 'Employee',
                      value: 'employee',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String text,
    required String value,
  }) {
    return InkWell(
      onTap: () {
        widget.onMenuItemSelected(value);
        _removeOverlay();
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18),
            const SizedBox(width: 8),
            Text(text),
          ],
        ),
      ),
    );
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      key: _fabKey,
      onPressed: _showCustomMenu,
      child: const Icon(Icons.add),
      backgroundColor: Colors.deepOrange,
    );
  }
}