import 'package:flutter/material.dart';
import 'package:hr_management/config/font_style.dart';

class CustomDropdown<T> extends StatefulWidget {
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final InputDecoration decoration;
  final int? menuMaxHeight;
  final bool? isExpanded;
  final String? hint;

  const CustomDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.hint,
    this.decoration = const InputDecoration(),
    this.menuMaxHeight,
    this.isExpanded,
  });

  @override
  State<CustomDropdown<T>> createState() => _CustomDropdownState<T>();
}

class _CustomDropdownState<T> extends State<CustomDropdown<T>>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _expandAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleDropdown() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedItem = widget.items.firstWhere(
          (item) => item.value == widget.value,
      orElse: () => DropdownMenuItem<T>(
        value: null,
        child: Text(
          widget.hint ?? widget.decoration.hintText ?? 'Select an option',
          style: TextStyle(color: Colors.grey.shade600),
        ),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Dropdown Header
        GestureDetector(
          onTap: _toggleDropdown,
          child: InputDecorator(
            decoration: widget.decoration.copyWith(
              suffixIcon: AnimatedRotation(
                turns: _isExpanded ? 0.5 : 0,
                duration: const Duration(milliseconds: 200),
                child: const Icon(Icons.arrow_drop_down, color: Colors.grey),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: DefaultTextStyle(
                    style: widget.value != null
                        ? FontStyles.subHeadingStyle()
                        : FontStyles.subHeadingStyle().copyWith(color: Colors.grey.shade600),
                    child: selectedItem.child,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Dropdown List
        AnimatedBuilder(
          animation: _expandAnimation,
          builder: (context, child) {
            return ClipRect(
              child: Align(
                alignment: Alignment.topCenter,
                heightFactor: _expandAnimation.value,
                child: child,
              ),
            );
          },
          child: Container(
            constraints: BoxConstraints(
              maxHeight: widget.menuMaxHeight?.toDouble() ?? 200,
            ),
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Scrollbar(
              thumbVisibility: widget.items.length > 5,
              child: ListView.separated(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemCount: widget.items.length,
                separatorBuilder: (context, index) => Divider(
                  height: 1,
                  color: Colors.grey.shade200,
                ),
                itemBuilder: (context, index) {
                  final item = widget.items[index];
                  final isSelected = item.value == widget.value;

                  return InkWell(
                    onTap: () {
                      widget.onChanged(item.value);
                      _toggleDropdown();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blue.shade50 : Colors.transparent,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: DefaultTextStyle(
                              style: FontStyles.subHeadingStyle().copyWith(
                                color: isSelected ? Colors.blue : Colors.black87,
                              ),
                              child: item.child,
                            ),
                          ),
                          if (isSelected)
                            Icon(
                              Icons.check,
                              color: Colors.blue,
                              size: 18,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}