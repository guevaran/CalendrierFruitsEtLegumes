import 'package:calendrier_fruits_et_legumes/components/checkbox_button.dart';
import 'package:calendrier_fruits_et_legumes/components/liste.dart';
import 'package:calendrier_fruits_et_legumes/components/calendrier.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final ValueNotifier<bool> _showFruits = ValueNotifier(true);
  final ValueNotifier<bool> _showLegumes = ValueNotifier(true);
  final ValueNotifier<bool> _showCereales = ValueNotifier(true);
  final ValueNotifier<String> _sortBy = ValueNotifier('pertinence');
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
      Calendrier(showFruits: _showFruits, showLegumes: _showLegumes, showCereales: _showCereales, sortBy: _sortBy),
      Liste(showFruits: _showFruits, showLegumes: _showLegumes, showCereales: _showCereales, sortBy: _sortBy),
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
            icon: const Icon(Icons.sort),
            itemBuilder: (context) {
              return [
                const PopupMenuItem(
                  value: 'pertinence',
                  child: Text('Pertinence'),
                ),
                const PopupMenuItem(
                  value: 'alphabet',
                  child: Text('Alphabet'),
                ),
              ];
            },
            onSelected: (value) {
              switch (value) {
                case 'pertinence':
                  _sortBy.value = 'pertinence';
                  break;
                case 'alphabet':
                  _sortBy.value = 'alphabet';
                  break;
              }
            },
          ),
          PopupMenuButton(
            color: Theme.of(context).colorScheme.background,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'donate',
                child: SizedBox(
                  width: 160,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Image(image: AssetImage("assets/imgs/kofi.png"), height: 25),
                      SizedBox(width: 10),
                      Text("Faire un don", style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ],
            onSelected: (value) {
              switch (value) {
                case 'donate':
                  () async {
                    try {
                      await launchUrlString("https://ko-fi.com/nicolasguevara");
                    } catch (e) {
                      debugPrint("Error: $e");
                    }
                  }();
                  break;
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              boxShadow: <BoxShadow>[BoxShadow(color: Theme.of(context).colorScheme.secondary, blurRadius: 4.0, offset: const Offset(0.0, 0.60))],
              color: Theme.of(context).colorScheme.background,
            ),
            // child: SingleChildScrollView(
            //   scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Icon(Icons.filter_alt, color: Theme.of(context).colorScheme.secondary),
                ),
                CheckboxButton(
                  text: "Fruits",
                  value: _showFruits.value,
                  onTap: () {
                    setState(() {
                      _showFruits.value = !_showFruits.value;
                    });
                  },
                ),
                CheckboxButton(
                  text: "Légumes",
                  value: _showLegumes.value,
                  onTap: () {
                    setState(() {
                      _showLegumes.value = !_showLegumes.value;
                    });
                  },
                ),
                CheckboxButton(
                  text: "Céréales",
                  value: _showCereales.value,
                  onTap: () {
                    setState(() {
                      _showCereales.value = !_showCereales.value;
                    });
                  },
                ),
              ],
            ),
            // ),
          ),
          Expanded(child: _navBarWidgets.elementAt(_selectedIndex)),
        ],
      ),
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
