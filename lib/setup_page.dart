import 'package:flutter/material.dart';

class SetupPage extends StatefulWidget {
  const SetupPage({super.key});
  @override
  State<SetupPage> createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {

  //I list the options here so they can be modified for database connection
  List<DropdownMenuEntry> telescopeOptions = [
    const DropdownMenuEntry(value: "RC51", label: "RedCat 51"),
    const DropdownMenuEntry(value: "SW10Q", label: "Sky-Watcher 10” Quattro")
  ];
  List<DropdownMenuEntry> mountOptions = [
    // DropdownMenuEntry(value: 0, label: "                                "), //If wanted or needed making a blank entry with lots of spaces can increase the size of the text box
    const DropdownMenuEntry(value: "ZA5", label: "ZWO - AM5"),
    const DropdownMenuEntry(value: "JCM", label: "Custom - Rehm")
  ];
  List<DropdownMenuEntry> counterweightOptions = [
    const DropdownMenuEntry(value: "110", label: "10 lbs - 1"),
    const DropdownMenuEntry(value: "210", label: "10 lbs - 2"),
    const DropdownMenuEntry(value: "310", label: "10 lbs - 3"),
    const DropdownMenuEntry(value: "120", label: "20 lbs - 1"),
    const DropdownMenuEntry(value: "220", label: "20 lbs - 2"),
    const DropdownMenuEntry(value: "130", label: "30 lbs - 1"),
    const DropdownMenuEntry(value: "230", label: "30 lbs - 2")
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: 
        Padding(padding: const EdgeInsets.all(16), child:
          Center(child: Column(children: [
            const Text("Telescope Selection", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            DropdownMenu(dropdownMenuEntries: telescopeOptions),
            const SizedBox(height: 64),
            const Text("Mount Selection", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            DropdownMenu(dropdownMenuEntries: mountOptions),
            const SizedBox(height: 64),
            const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text("Counterweight Setup", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              // const SizedBox(width: 32),
              // ElevatedButton(onPressed: (){}, child: const Text("+")) //Will open a page to input custom counterweight information
            ]),
            const SizedBox(height: 16),
            DropdownMenu(dropdownMenuEntries: counterweightOptions),
            //TODO: Consider adding a button to initiate the calculations here
            ]),
          )
        )
      )
    );
  }
}