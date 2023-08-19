import 'package:calendrier_fruits_et_legumes/components/month.dart';
import 'package:calendrier_fruits_et_legumes/utils.dart';
import 'package:flutter/material.dart';

class FruitDetailPage extends StatefulWidget {
  final dynamic fruit;

  const FruitDetailPage({Key? key, required this.fruit}) : super(key: key);

  @override
  State<FruitDetailPage> createState() => _FruitDetailPageState();
}

class _FruitDetailPageState extends State<FruitDetailPage> {
  late Future<Map<String, dynamic>> _months;

  @override
  void initState() {
    super.initState();
    _months = getDataFromJsonFile('months');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.fruit['label'])),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Center(
              child: Hero(
                tag: (widget.fruit['img_path'] != null) ? widget.fruit['img_path'] : 'f${widget.fruit['id']}',
                child: Image(
                  image: AssetImage((widget.fruit['img_path'] != null) ? 'assets/imgs/${widget.fruit['img_path']}' : 'assets/imgs/default_fruit.png'),
                  height: 300,
                  alignment: Alignment.center,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: const Text('test description'),
          ),
          const Text('Saison :'),
          Container(
            height: 80,
            padding: EdgeInsets.symmetric(horizontal: 50),
            child: FutureBuilder(
              future: _months,
              builder: (context, smonths) {
                if (smonths.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (smonths.hasError) {
                  debugPrint(smonths.error.toString());
                  return Center(child: Text('An error has occured', style: TextStyle(color: Theme.of(context).colorScheme.error)));
                } else if (smonths.hasData) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (dynamic month in smonths.data!.values) Month(month: month, fruit: widget.fruit),
                      ],
                    ),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
