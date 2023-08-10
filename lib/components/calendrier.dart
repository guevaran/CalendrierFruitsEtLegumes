import 'package:calendrier_fruits_et_legumes/components/fruit_tile.dart';
import 'package:calendrier_fruits_et_legumes/components/month.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class Calendrier extends StatefulWidget {
  final ValueNotifier<bool> showCereales;
  final ValueNotifier<bool> showFruits;
  final ValueNotifier<bool> showLegumes;

  const Calendrier({super.key, required this.showFruits, required this.showLegumes, required this.showCereales});

  @override
  State<Calendrier> createState() => _CalendrierState();
}

class _CalendrierState extends State<Calendrier> {
  late Future<Map<String, dynamic>> _months;
  late Future<Map<String, dynamic>> _fruitsById;
  Map<String, dynamic>? _fruitsByMonth;
  late int _selectedMonth;
  final _monthScrollController = ItemScrollController();

  @override
  void initState() {
    super.initState();

    _selectedMonth = DateTime.now().month;
    _months = _getDataFromJsonFile('months');
    _fruitsById = _getDataFromJsonFile('fruits');

    _generateFruitsByMonth();
    widget.showCereales.addListener(() {
      _generateFruitsByMonth();
      setState(() => _fruitsByMonth);
    });
    widget.showFruits.addListener(() {
      _generateFruitsByMonth();
      setState(() => _fruitsByMonth);
    });
    widget.showLegumes.addListener(() {
      _generateFruitsByMonth();
      setState(() => _fruitsByMonth);
    });

    //After layout built, scroll to the current month
    WidgetsBinding.instance.addPostFrameCallback((_) => _monthScrollController.jumpTo(index: _selectedMonth, alignment: 0.5));
  }

  Future<Map<String, dynamic>> _getDataFromJsonFile(String fileName) async {
    return json.decode(await rootBundle.loadString('assets/json/$fileName.json'));
  }

  void _generateFruitsByMonth() {
    _fruitsByMonth = {};
    _fruitsById.then((fruitsById) {
      for (var k in fruitsById.keys) {
        for (var i = 1; i <= 12; i++) {
          if (fruitsById[k]['months'].contains(i.toString()) && _checkFruitType(fruitsById[k]['type'])) {
            _fruitsByMonth!.putIfAbsent(i.toString(), () => []).add(fruitsById[k]);
          }
        }
      }
    });
  }

  bool _checkFruitType(String type) {
    switch (type) {
      case 'fruit':
        if (widget.showFruits.value) return true;
        break;
      case 'legume':
        if (widget.showLegumes.value) return true;
        break;
      case 'cereale':
        if (widget.showCereales.value) return true;
        break;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            alignment: Alignment.center,
            child: FutureBuilder(
              future: _fruitsById,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  debugPrint(snapshot.error.toString());
                  return Center(child: Text('An error has occured', style: TextStyle(color: Theme.of(context).colorScheme.error)));
                } else if (snapshot.hasData) {
                  return SingleChildScrollView(
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        if (_fruitsByMonth != null && _fruitsByMonth![_selectedMonth.toString()] != null) ...[
                          for (var fruit in _fruitsByMonth![_selectedMonth.toString()]) FruitTile(fruit: fruit),
                        ],
                      ],
                    ),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ),
        Container(
          height: 60,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: FutureBuilder(
            future: _months,
            builder: (context, snapshot) => ScrollablePositionedList.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(0),
              itemCount: 12,
              itemScrollController: _monthScrollController,
              itemBuilder: (context, i) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  debugPrint(snapshot.error.toString());
                  return Center(child: Text('An error has occured', style: TextStyle(color: Theme.of(context).colorScheme.error)));
                } else if (snapshot.hasData) {
                  dynamic month = snapshot.data![(i + 1).toString()];
                  return Month(
                    month: month,
                    selected: _selectedMonth,
                    onTap: () {
                      setState(() {
                        _selectedMonth = int.parse(month['id']);
                      });
                    },
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
              separatorBuilder: (context, i) => const VerticalDivider(
                width: 2,
                color: Colors.grey,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
