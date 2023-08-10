import 'package:calendrier_fruits_et_legumes/components/month.dart';
import 'package:calendrier_fruits_et_legumes/pages/fruit_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';

class FruitListTile extends StatefulWidget {
  final dynamic fruit;
  final Map<String, dynamic> months;
  final LinkedScrollControllerGroup monthsScrollControllerGroup;

  const FruitListTile({super.key, required this.fruit, required this.months, required this.monthsScrollControllerGroup});

  @override
  State<FruitListTile> createState() => _FruitListTileState();
}

class _FruitListTileState extends State<FruitListTile> {
  late ScrollController _monthsScrollController;

  @override
  void initState() {
    super.initState();
    _monthsScrollController = widget.monthsScrollControllerGroup.addAndGet();
  }

  @override
  void dispose() {
    _monthsScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => FruitDetailPage(fruit: widget.fruit)));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          children: [
            SizedBox(
              width: 120,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    height: 100,
                    child: Hero(
                      tag: (widget.fruit['img_path'] != null) ? widget.fruit['img_path'] : 'f${widget.fruit['id']}',
                      child: Image(
                        image: AssetImage((widget.fruit['img_path'] != null) ? 'assets/imgs/${widget.fruit['img_path']}' : 'assets/imgs/default_fruit.png'),
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
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                controller: _monthsScrollController,
                child: Row(
                  children: [
                    for (dynamic month in widget.months.values) Month(month: month, fruit: widget.fruit),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
