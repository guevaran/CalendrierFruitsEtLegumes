import 'package:calendrier_fruits_et_legumes/components/checkbox_button.dart';
import 'package:calendrier_fruits_et_legumes/components/liste.dart';
import 'package:calendrier_fruits_et_legumes/components/calendrier.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  late ValueNotifier<bool> _showFruits;
  late ValueNotifier<bool> _showLegumes;
  late ValueNotifier<bool> _showCereales;
  late ValueNotifier<String> _sortBy;
  // Shared preferences (stored locally)
  late Future<SharedPreferences> _prefs;

  static late final List<Widget> _navBarWidgets;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<SharedPreferences> getSharedPreferences() async {
    return await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();

    _prefs = getSharedPreferences();
    _prefs.then((prefsValue) {
      // prefsValue.clear(); // CLEAR JUST FOR TESTING PURPOSE
      _showFruits = ValueNotifier((prefsValue.getBool('showFruits') != null) ? prefsValue.getBool('showFruits')! : true);
      _showLegumes = ValueNotifier((prefsValue.getBool('showLegumes') != null) ? prefsValue.getBool('showLegumes')! : true);
      _showCereales = ValueNotifier((prefsValue.getBool('showCereales') != null) ? prefsValue.getBool('showCereales')! : true);
      _sortBy = ValueNotifier((prefsValue.getString('sortBy') != null) ? prefsValue.getString('sortBy')! : 'pertinence');

      _navBarWidgets = <Widget>[
        Calendrier(showFruits: _showFruits, showLegumes: _showLegumes, showCereales: _showCereales, sortBy: _sortBy),
        Liste(showFruits: _showFruits, showLegumes: _showLegumes, showCereales: _showCereales, sortBy: _sortBy),
      ];

      WidgetsBinding.instance.addPostFrameCallback((_) {
        final bool? showHomeDialog = prefsValue.getBool('showHomeDialog');

        if (showHomeDialog == null || showHomeDialog == true) {
          showDialog<String>(
            context: context,
            builder: (context) {
              bool notShowInitDialog = false;
              return StatefulBuilder(
                builder: (context, setState) => AlertDialog(
                  backgroundColor: Theme.of(context).colorScheme.background,
                  contentPadding: const EdgeInsets.only(top: 20, right: 20, left: 20, bottom: 0),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Image.asset(
                          'assets/logo/logo.png',
                          height: 150,
                        ),
                      ),
                      const Text.rich(
                        TextSpan(
                          text: "Sur cette application vous trouverez des informations sur les fruits, légumes et céréales qui sont de saison en ",
                          children: <TextSpan>[
                            TextSpan(text: 'France', style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(
                                text:
                                    " 🇫🇷. Vous pourrez ainsi déguster des produits frais et locaux en toutes saisons !\n\nGardez à l'esprit que notre application est basé sur les données françaises, la rendant inutilisable en dehors du pays.\n\nBon appétit ! 🍓🥕"),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      CheckboxListTile(
                        title: const Text('Ne plus afficher'),
                        value: notShowInitDialog,
                        onChanged: (v) {
                          setState(() {
                            notShowInitDialog = v!;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        if (notShowInitDialog == true) {
                          prefsValue.setBool('showHomeDialog', false);
                        }
                        Navigator.pop(context, 'OK');
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _prefs,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          debugPrint(snapshot.error.toString());
          return Center(child: Text('An error has occured', style: TextStyle(color: Theme.of(context).colorScheme.error)));
        } else if (snapshot.hasData) {
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
                        snapshot.data!.setString('sortBy', 'pertinence');
                        break;
                      case 'alphabet':
                        _sortBy.value = 'alphabet';
                        snapshot.data!.setString('sortBy', 'alphabet');
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
                          snapshot.data!.setBool('showFruits', _showFruits.value);
                        },
                      ),
                      CheckboxButton(
                        text: "Légumes",
                        value: _showLegumes.value,
                        onTap: () {
                          setState(() {
                            _showLegumes.value = !_showLegumes.value;
                          });
                          snapshot.data!.setBool('showLegumes', _showLegumes.value);
                        },
                      ),
                      CheckboxButton(
                        text: "Céréales",
                        value: _showCereales.value,
                        onTap: () {
                          setState(() {
                            _showCereales.value = !_showCereales.value;
                          });
                          snapshot.data!.setBool('showCereales', _showCereales.value);
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
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
