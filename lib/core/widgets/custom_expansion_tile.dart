import 'package:flutter/material.dart';
import 'package:hr_management/config/app_spacing.dart';
import 'package:hr_management/features/Management/Widgets/bordered_container.dart';

class CustomExpansionTile extends StatefulWidget {
  final Widget title;
  final List<Widget> children;
  final bool initiallyExpanded;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? collapsedBackgroundColor;
  final BorderRadius? borderRadius;
  final BoxBorder? border;

  final Duration? animationDuration;
  final Widget? leading;
  final Widget? trailing;
  final Color? iconColor;
  final double? iconSize;
  final Function(bool)? onExpansionChanged;

  const CustomExpansionTile({
    Key? key,
    required this.title,
    required this.children,
    this.initiallyExpanded = false,
    this.margin,
    this.padding,
    this.width,
    this.height,
    this.backgroundColor,
    this.collapsedBackgroundColor,
    this.borderRadius,
    this.border,
    this.animationDuration,
    this.leading,
    this.trailing,
    this.iconColor,
    this.iconSize,
    this.onExpansionChanged,
  }) : super(key: key);

  @override
  State<CustomExpansionTile> createState() => _CustomExpansionTileState();
}

class _CustomExpansionTileState extends State<CustomExpansionTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _iconTurns;
  late Animation<double> _heightFactor;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration ?? const Duration(milliseconds: 200),
      vsync: this,
    );
    _iconTurns = _controller.drive(Tween<double>(begin: 0.0, end: 0.5)
        .chain(CurveTween(curve: Curves.fastOutSlowIn)));
    _heightFactor = _controller.drive(CurveTween(curve: Curves.easeInOut));
    _isExpanded = widget.initiallyExpanded;
    if (_isExpanded) _controller.value = 1.0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
      widget.onExpansionChanged?.call(_isExpanded);
    });
  }

  Widget _buildChildren(BuildContext context, Widget? child) {
    return BorderedContainer(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: _handleTap,
            child: Padding(
              padding: widget.padding ?? const EdgeInsets.all(2),
              child: Row(
                children: [
                  if (widget.leading != null) ...[
                    widget.leading!,
                    const SizedBox(width: 16),
                  ],
                  Expanded(child: widget.title),
                  if (widget.trailing != null)
                    widget.trailing!
                  else
                    RotationTransition(
                      turns: _iconTurns,
                      child: Icon(
                        Icons.expand_more,
                        color: widget.iconColor ?? Colors.grey,
                        size: widget.iconSize ?? 24,
                      ),
                    ),
                ],
              ),
            ),
          ),
          ClipRect(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (BuildContext context, Widget? child) {
                return Align(
                  alignment: Alignment.topCenter,
                  heightFactor: _heightFactor.value,
                  child: child,
                );
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_isExpanded)
                     Divider(thickness: 1, height: 1,color: Colors.grey.shade300,),
                  AppSpacing.small(context),
                  ...widget.children,
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: _buildChildren,
    );
  }
} 