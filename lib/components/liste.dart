import 'package:calendrier_fruits_et_legumes/components/fruit_list_tile.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';

class Liste extends StatefulWidget {
  final ValueNotifier<bool> showCereales;
  final ValueNotifier<bool> showFruits;
  final ValueNotifier<bool> showLegumes;

  const Liste({super.key, required this.showFruits, required this.showLegumes, required this.showCereales});

  @override
  State<Liste> createState() => _ListeState();
}

class _ListeState extends State<Liste> {
  late Future<Map<String, dynamic>> _months;
  late Future<Map<String, dynamic>> _fruitsById;
  List<dynamic>? _filteredFruits;
  final LinkedScrollControllerGroup _monthsScrollControllers = LinkedScrollControllerGroup();

  @override
  void initState() {
    super.initState();

    _months = _getDataFromJsonFile('months');
    _fruitsById = _getDataFromJsonFile('fruits');

    _filterFruits();
    widget.showCereales.addListener(() {
      _filterFruits();
      setState(() => _filteredFruits);
    });
    widget.showFruits.addListener(() {
      _filterFruits();
      setState(() => _filteredFruits);
    });
    widget.showLegumes.addListener(() {
      _filterFruits();
      setState(() => _filteredFruits);
    });

    //After layout built, scroll to the current month
    // WidgetsBinding.instance.addPostFrameCallback((_) => _monthScrollController.jumpTo(index: DateTime.now().month, alignment: 0.5));
  }

  Future<Map<String, dynamic>> _getDataFromJsonFile(String fileName) async {
    return json.decode(await rootBundle.loadString('assets/json/$fileName.json'));
  }

  void _filterFruits() {
    _filteredFruits = [];
    _fruitsById.then((fruitsById) {
      for (var k in fruitsById.keys) {
        if (_checkFruitType(fruitsById[k]['type'])) {
          _filteredFruits!.add(fruitsById[k]);
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
          child: FutureBuilder(
            future: _months,
            builder: (context1, smonths) => FutureBuilder(
              future: _fruitsById,
              builder: (context, snapshot) => ListView.separated(
                itemBuilder: (context, i) {
                  if (snapshot.connectionState == ConnectionState.waiting || smonths.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError || smonths.hasError) {
                    debugPrint(snapshot.error.toString());
                    debugPrint(smonths.error.toString());
                    return Center(child: Text('An error has occured', style: TextStyle(color: Theme.of(context).colorScheme.error)));
                  } else if (snapshot.hasData || smonths.hasData) {
                    return FruitListTile(fruit: _filteredFruits![i], months: smonths.data!, monthsScrollControllerGroup: _monthsScrollControllers);
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
                separatorBuilder: (context, snapshot) => const Divider(),
                itemCount: _filteredFruits!.length,
              ),
            ),
          ),
        ),
        Container(
          // height: 100,
          padding: EdgeInsets.all(10),
          width: double.infinity,
          decoration: BoxDecoration(
            boxShadow: <BoxShadow>[BoxShadow(color: Theme.of(context).colorScheme.secondary, blurRadius: 4.0, offset: const Offset(0.0, -0.60))],
            color: Theme.of(context).colorScheme.background,
            border: Border(
              bottom: BorderSide(
                width: 2,
                color: Colors.grey.shade400,
              ),
            ),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Icon(Icons.search, color: Theme.of(context).colorScheme.secondary),
              ),
              Expanded(child: TextField()),
            ],
          ),
        ),
      ],
    );
  }
}
