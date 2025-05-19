import 'package:flutter/material.dart';
import '../Configuration/app_cards.dart';

class CustomListTile extends StatefulWidget {
  final Map<String, dynamic> item;
  final Widget? leading;
  final Widget? trailing;
  final Widget? title;
  final Widget? subtitle;
  final VoidCallback? onFirstButtonPressed;
  final VoidCallback? onSecondButtonPressed;
  final double? widthFactor;

  const CustomListTile({
    Key? key,
    this.item = const {},
    this.leading,
    this.trailing,
    this.title,
    this.subtitle,
    this.onFirstButtonPressed,
    this.onSecondButtonPressed,
    this.widthFactor,
  }) : super(key: key);

  @override
  State<CustomListTile> createState() => _CustomListTileState();
}

class _CustomListTileState extends State<CustomListTile>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: Container(
        width: screenWidth * (widget.widthFactor ?? 0.9),
        margin: const EdgeInsets.only(left: 12, right: 12, bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: ShapeDecoration(
          color: TileConfig.backgroundColor,
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1, color: TileConfig.borderColor),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.title != null || widget.leading != null || widget.trailing != null)
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (widget.leading != null) ...[
                    widget.leading!,
                    const SizedBox(width: 8),
                  ],
                  Expanded(
                    child: widget.title ??
                        Text(
                          widget.item['title'] ?? '',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                  ),
                  if (widget.trailing != null) ...[
                    const SizedBox(width: 8),
                    widget.trailing!,
                  ],
                ],
              ),

            if (widget.subtitle != null) ...[
              if (widget.title != null || widget.leading != null || widget.trailing != null)
                const SizedBox(height: 8),
              widget.subtitle!,
            ],
          ],
        ),
      ),
    );
  }
}
