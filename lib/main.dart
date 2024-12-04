import 'package:flutter/material.dart';
import 'package:balancemate/home_page.dart';
import 'package:balancemate/setup_page.dart';
import 'package:balancemate/details_page.dart';
import 'package:balancemate/database_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var db = DatabaseManager();
  await db.init();
  var counterweightSetups = await db.getCounterweightSetups();
  for (var i in counterweightSetups) {
    print(i.toString());
  }
  runApp(const BalanceMateApp());
}

class BalanceMateApp extends StatelessWidget {
  const BalanceMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    
    return const MaterialApp(
      home: NavigationPage(),
    );
  }
}

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int _selectedIndex = 1;

  final List<Widget> _pages = [
    const DetailsPage(),
    const HomePage(),
    const SetupPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Details'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Setup'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.red[700],
        onTap: _onItemTapped,
      ),
    );
  }
}