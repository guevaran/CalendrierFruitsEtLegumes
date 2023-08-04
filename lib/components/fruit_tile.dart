import 'package:flutter/material.dart';

class FruitTile extends StatefulWidget {
  dynamic fruit;

  FruitTile({super.key, required this.fruit});

  @override
  State<FruitTile> createState() => _FruitTileState();
}

class _FruitTileState extends State<FruitTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: [
            Container(
              constraints: const BoxConstraints(
                maxHeight: 100,
                maxWidth: 100,
                minHeight: 50,
                minWidth: 50,
              ),
              child: Image(
                image: AssetImage((widget.fruit['img_path'] != null) ? 'assets/imgs/${widget.fruit['img_path']}' : 'assets/imgs/pomme.png'),
                // height: 70,
                fit: BoxFit.contain,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: Text(widget.fruit['label']),
            ),
          ],
        ),
      ),
    );
  }
}
