import 'package:calendrier_fruits_et_legumes/components/fruit_list_tile.dart';
import 'package:calendrier_fruits_et_legumes/utils.dart';
import 'package:flutter/material.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';

class Liste extends StatefulWidget {
  final ValueNotifier<bool> showCereales;
  final ValueNotifier<bool> showFruits;
  final ValueNotifier<bool> showLegumes;
  final ValueNotifier<String> sortBy;

  const Liste({super.key, required this.showFruits, required this.showLegumes, required this.showCereales, required this.sortBy});

  @override
  State<Liste> createState() => _ListeState();
}

class _ListeState extends State<Liste> {
  late Future<Map<String, dynamic>> _months;
  late Future<Map<String, dynamic>> _fruitsById;
  List<dynamic>? _filteredFruits;
  final LinkedScrollControllerGroup _monthsScrollControllers = LinkedScrollControllerGroup();
  final _searchController = TextEditingController();
  FocusNode _searchFocus = FocusNode();

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();

    _months = getDataFromJsonFile('months');
    _fruitsById = getDataFromJsonFile('fruits');

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
    widget.sortBy.addListener(() {
      _filterFruits();
      setState(() => _filteredFruits);
    });
  }

  void _filterFruits([String? searchValue]) {
    _filteredFruits = [];
    _fruitsById.then((fruitsById) {
      for (var k in fruitsById.keys) {
        if (_checkFruitType(fruitsById[k]['type']) && _checkSearchBar(fruitsById[k]['label'], searchValue)) {
          _filteredFruits!.add(fruitsById[k]);
        }
      }

      // sorting
      switch (widget.sortBy.value) {
        case 'alphabet':
          _filteredFruits!.sort((e1, e2) => e1['label'].compareTo(e2['label']));
          break;
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

  bool _checkSearchBar(String fruitLabel, String? searchValue) {
    if (searchValue == null) {
      // Search bar empty
      return true;
    } else {
      if (formatForSearch(fruitLabel).startsWith(formatForSearch(searchValue))) {
        return true;
      } else {
        return false;
      }
    }
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
          padding: const EdgeInsets.all(10),
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
              Expanded(
                child: TextField(
                  controller: _searchController,
                  focusNode: _searchFocus,
                  onChanged: (value) {
                    _filterFruits(value);
                    setState(() => _filteredFruits);
                  },
                  decoration: InputDecoration(
                    hintText: 'Tapez un nom...',
                    suffixIcon: IconButton(
                      onPressed: () {
                        _searchController.clear();
                        _filterFruits();
                        setState(() => _filteredFruits);
                        _searchFocus.unfocus();
                      },
                      icon: const Icon(Icons.clear),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
