import 'package:calendrier_fruits_et_legumes/components/calendrier.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final ValueNotifier<bool> _showFruits = ValueNotifier(true);
  final ValueNotifier<bool>  _showLegumes = ValueNotifier(true);
  final ValueNotifier<bool>  _showCereales = ValueNotifier(true);
  // late String _title;

  static late final List<Widget> _navBarWidgets;
  

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    // _title = 'Calendrier ${(_showFruits.value) ? 'Fruits,' : ''} ${(_showLegumes.value) ? 'Légumes,' : ''} ${(_showCereales.value) ? 'Céréales,' : ''}';
    // _title = _title.substring(0, _title.length - 1);
    _navBarWidgets = <Widget>[
      Calendrier(showFruits: _showFruits, showLegumes: _showLegumes, showCereales: _showCereales),
      const Text(
        'Liste',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendrier Fruits et Légumes'),
        actions: [
          PopupMenuButton(
            color: Theme.of(context).colorScheme.background,
            icon: const Icon(Icons.filter_alt),
            itemBuilder: (context) {
              return [
                // CheckedPopupMenuItem(value: _showFruits, child: const Text('Fruits'),),
                PopupMenuItem(
                  value: 'fruits',
                  child: StatefulBuilder(
                    builder: (context, setState) => CheckboxListTile(
                      title: const Text('Fruits'),
                      value: _showFruits.value,
                      onChanged: (value) => setState(() => _showFruits.value = value!),
                    ),
                  ),
                ),
                PopupMenuItem(
                  value: 'legumes',
                  child: StatefulBuilder(
                    builder: (context, _setState) => CheckboxListTile(
                      title: const Text('Légumes'),
                      value: _showLegumes.value,
                      onChanged: (value) => _setState(() => _showLegumes.value = value!),
                    ),
                  ),
                ),
                PopupMenuItem(
                  value: 'cereales',
                  child: StatefulBuilder(
                    builder: (context, _setState) => CheckboxListTile(
                      title: const Text('Céréales'),
                      value: _showCereales.value,
                      onChanged: (value) => _setState(() => _showCereales.value = value!),
                    ),
                  ),
                ),
              ];
            },
            // onSelected: (value) {
            //   switch (value) {
            //     case 'settings':
            //       break;
            //   }
            // },
          ),
        ],
      ),
      body: _navBarWidgets.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Calendrier',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Liste',
          ),
        ],
        currentIndex: _selectedIndex,
        //selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
