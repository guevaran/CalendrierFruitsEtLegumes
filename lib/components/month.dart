import 'package:flutter/material.dart';

class Month extends StatefulWidget {
  dynamic month;
  int selected;
  Function() onTap;
  late bool _isSelected;

  Month({super.key, required this.month, required this.selected, required this.onTap}) {
    _isSelected = (selected == int.parse(month['id']));
  }

  @override
  State<Month> createState() => _MonthState();
}

class _MonthState extends State<Month> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        decoration: BoxDecoration(
          color: (widget._isSelected) ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.background, //TODO: change with theme color
          //border: Border.all(),
        ),
        child: Text(widget.month['shortLbl'], style: TextStyle(color: (widget._isSelected) ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.onBackground,),),
      ),
    );
  }
}
