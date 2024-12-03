import 'package:flutter/material.dart';

void main() {
  runApp(const BalanceMateApp());
}

class BalanceMateApp extends StatelessWidget {
  const BalanceMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: 
        SafeArea(child: 
          Padding(padding: const EdgeInsets.all(16), child:
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Center(child:
                  Text("Quick Information", style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold
                  ))
                ),
                const Align(alignment: Alignment.centerLeft, child: 
                  Text('Telescope: placeholder telescope name\n'
                  'Mount: placeholder mount name\n'
                  'Accessories: placeholder accessories\n'
                  'Counterweight: placeholder counterweight weight\n'
                  'Counterweight Distance: placeholder distance')
                ),
                Center(child: Image.asset("assets/Amazing and extremely cool telescope icon that's certainly not just dev art ;D.png")),
                // const Padding(padding: EdgeInsets.fromLTRB(0, 0, 32, 0), child: 
                //   Align(alignment: Alignment.centerRight, child:
                //     CircleAvatar(backgroundColor: Colors.red, child: Icon(Icons.search, color: Colors.white))
                //   )
                // )
                // Align(alignment: Alignment.bottomCenter, child:
                //   Container(height: 2, color: Colors.black)
                // )
              ])
            )
          ),
      bottomNavigationBar: BottomNavigationBar(items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Setup'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Details'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.red[700],
        onTap: _onItemTapped,
      ),
    );
  }
}

class SetupPage extends StatefulWidget {
  const SetupPage({super.key});
  @override
  State<SetupPage> createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(child: Text("Setup Page")),
      bottomNavigationBar: BottomNavigationBar(items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Setup'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Details'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.red[700],
        onTap: _onItemTapped,
      ),
    );
  }
}