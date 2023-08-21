import 'package:flutter/material.dart';

class CheckboxButton extends StatelessWidget {
  final String text;
  final bool value;
  final Function() onTap;
  final double padding;
  final double marginHorizontal;
  final double marginVertical;

  const CheckboxButton({
    Key? key,
    required this.text,
    required this.value,
    required this.onTap,
    this.padding = 8,
    this.marginHorizontal = 2,
    this.marginVertical = 10,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(padding),
        margin: EdgeInsets.symmetric(horizontal: marginHorizontal, vertical: marginVertical),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: Border.all(
            width: 2,
            color: (value) ? Theme.of(context).colorScheme.primary : Colors.grey,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              height: 24,
              width: 24,
              child: Checkbox(
                value: value,
                onChanged: (val) => onTap(),
                shape: const CircleBorder(),
                activeColor: Theme.of(context).colorScheme.primary,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6),
              child: Text(text),
            ),
          ],
        ),
      ),
    );
  }
}
