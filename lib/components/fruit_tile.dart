import 'package:calendrier_fruits_et_legumes/pages/fruit_detail_page.dart';
import 'package:flutter/material.dart';

class FruitTile extends StatefulWidget {
  final dynamic fruit;

  const FruitTile({super.key, required this.fruit});

  @override
  State<FruitTile> createState() => _FruitTileState();
}

class _FruitTileState extends State<FruitTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => FruitDetailPage(fruit: widget.fruit)));
      },
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
              child: Hero(
                tag: (widget.fruit['img_path'] != null) ? widget.fruit['img_path'] : 'f${widget.fruit['id']}',
                child: Image(
                  image: AssetImage((widget.fruit['img_path'] != null) ? 'assets/imgs/${widget.fruit['img_path']}' : 'assets/imgs/default_fruit.webp'),
                  // height: 70,
                  fit: BoxFit.contain,
                ),
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
