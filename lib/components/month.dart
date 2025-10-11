import 'package:flutter/material.dart';

class Month extends StatefulWidget {
  final dynamic month;
  final int? selected;
  final dynamic fruit;
  final Function()? onTap;
  // late bool _isSelected;
  final double horizontalPadding;
  final double verticalPadding;

  Month({super.key, required this.month, this.selected, this.fruit, this.onTap, this.horizontalPadding = 15, this.verticalPadding = 20}) {
    // _isSelected = (selected == int.parse(month['id']));
  }

  @override
  State<Month> createState() => _MonthState();
}

class _MonthState extends State<Month> {
  bool _isSelected() => (widget.selected == int.parse(widget.month['id']));

  Color _bgColor(BuildContext context) {
    Color color = Theme.of(context).colorScheme.surface;
    if (widget.fruit != null && widget.fruit["months"] != null) {
      for (String mid in widget.fruit["months"]) {
        if (mid == widget.month["id"]) {
          color = Theme.of(context).colorScheme.secondary;
          break;
        }
      }
    } else if (_isSelected()) {
      color = Theme.of(context).colorScheme.primary;
    }
    return color;
  }

  Color _fontColor(BuildContext context) {
    Color color = Theme.of(context).colorScheme.onSurface;
    if (widget.fruit != null && widget.fruit["months"] != null) {
      for (String mid in widget.fruit["months"]) {
        if (mid == widget.month["id"]) {
          color = Theme.of(context).colorScheme.onSecondary;
          break;
        }
      }
    } else if (_isSelected()) {
      color = Theme.of(context).colorScheme.onPrimary;
    }
    return color;
  }

  BoxBorder? _border() {
    if (widget.fruit != null) {
      return Border(
        top: const BorderSide(color: Colors.grey),
        bottom: const BorderSide(color: Colors.grey),
        left: const BorderSide(color: Colors.grey),
        right: (widget.month["id"] == "12") ? const BorderSide(color: Colors.grey) : BorderSide.none,
      );
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: widget.horizontalPadding, vertical: widget.verticalPadding),
        decoration: BoxDecoration(
          color: _bgColor(context),
          border: _border(),
        ),
        child: Text(
          widget.month['shortLbl'],
          style: TextStyle(
            color: _fontColor(context),
          ),
        ),
      ),
    );
  }
}
