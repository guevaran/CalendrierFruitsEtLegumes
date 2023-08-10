import 'package:flutter/material.dart';

class FruitDetailPage extends StatelessWidget {
  final dynamic fruit;

  FruitDetailPage({Key? key, required this.fruit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(fruit['label'])),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Center(
              child: Hero(
                tag: (fruit['img_path'] != null) ? fruit['img_path'] : 'f${fruit['id']}',
                child: Image(
                  image: AssetImage((fruit['img_path'] != null) ? 'assets/imgs/${fruit['img_path']}' : 'assets/imgs/default_fruit.png'),
                  height: 300,
                  alignment: Alignment.center,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          const Text('test description'),
        ],
      ),
    );
  }
}
