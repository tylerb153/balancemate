import 'package:balancemate/calculator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:balancemate/database_manager.dart';
import 'package:flutter/services.dart';

class SetupPage extends StatefulWidget {
  const SetupPage({super.key});
  @override
  State<SetupPage> createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  //I list the options here so they can be modified for database connection
  List<DropdownMenuEntry> telescopeOptions = [];
  List<DropdownMenuEntry> mountOptions = [];
  List<DropdownMenuEntry> counterweightOptions = [];
  Telescope? initialTelescope;
  Mount? initialMount;
  dynamic initialCounterweight; //is dynamic because it is either a Counterweight or a CounterweightSetup or null

  bool _dataLoaded = false;
  @override void initState() {
    super.initState();
    _loadData().then((_) {
      setState(() {
        _dataLoaded = true;
      });
    });
  }
  Future<void> _loadData() async {
    var db = DatabaseManager();
    await db.init();
    await _loadTelescopes(db);
    await _loadMounts(db);
    await _loadCounterweights(db);
  }
  Future<void> _loadTelescopes(DatabaseManager db) async {
    var telescopes = await db.getTelescopes();
    for (var telescope in telescopes) {
      setState(() {
        telescopeOptions.add(DropdownMenuEntry(value: telescope, label: telescope.toString()));
      });
    }
    if (Calculator.telescope != null) {
      for (var i in telescopeOptions) {
        if (i.value == Calculator.telescope) {
          setState(() {
            initialTelescope = i.value;
          });
          break;
        }
      }
    }
  }

  Future<void> _loadMounts(DatabaseManager db) async {
    var mounts = await db.getMounts();
    for (var mount in mounts) {
      mountOptions.add(DropdownMenuEntry(value: mount, label: mount.toString()));
    }
    if (Calculator.mount != null) {
      for (var i in mountOptions) {
        if (i.value == Calculator.mount) {
          setState(() {
            initialMount = i.value;
          });
          break;
        }
      }
    }
  }

  Future<void> _loadCounterweights(DatabaseManager db) async {
    List<Counterweight> counterweights = await db.getCounterweights();
    List<CounterweightSetup> counterweightSetups = await db.getCounterweightSetups();
    for (CounterweightSetup counterweightSetup in counterweightSetups) {
      counterweightOptions.add(DropdownMenuEntry(value: counterweightSetup, label: counterweightSetup.toString()));
    }
    for (Counterweight counterweight in counterweights) {
      counterweightOptions.add(DropdownMenuEntry(value: counterweight, label: counterweight.toString()));
    }
    if (Calculator.counterweight != null) {
      for (var i in counterweightOptions) {
        if (i.value == Calculator.counterweight) {
          setState(() {
            initialCounterweight = i.value;
          });
          break;
        }
      }
    }
  }

  void _setTelescope(dynamic telescope) {
    if (telescope is Telescope) {
      Calculator.telescope = telescope;
    }
  }
  void _setMount(dynamic mount) {
    if (mount is Mount) {
      Calculator.mount = mount;
    }
  }
  void _setCounterweightSetup(dynamic counterweightSetup) {
    if (counterweightSetup is Counterweight || counterweightSetup is CounterweightSetup) {
      Calculator.counterweight = counterweightSetup;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: _dataLoaded
              ? Center(
                  child: Column(
                    children: [
                      const Text("Telescope Selection", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 32),
                      DropdownMenu(initialSelection: initialTelescope, dropdownMenuEntries: telescopeOptions, onSelected: _setTelescope),
                      const SizedBox(height: 80),
                      const Text("Mount Selection", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 32),
                      DropdownMenu(initialSelection: initialMount, dropdownMenuEntries: mountOptions, onSelected: _setMount,),
                      const SizedBox(height: 80),
                      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        const Text("Counterweight Setup", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(width: 32),
                        ElevatedButton(onPressed: () {
                          showDialog(context: context,
                          builder: (BuildContext context) {
                            return const CounterweightDialogBox();
                          });
                        }, 
                          child: Text("+", style: TextStyle(color: Colors.red[700])))
                      ]),
                      const SizedBox(height: 32),
                      DropdownMenu(initialSelection: initialCounterweight, dropdownMenuEntries: counterweightOptions, onSelected: _setCounterweightSetup,),
                    ],
                  ),
                )
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        ),
      ),
    );
  }
}



class CounterweightDialogBox extends StatefulWidget {
  const CounterweightDialogBox({super.key});
  @override
  State<StatefulWidget> createState() => _CounterweightDialogBoxState();
}

class _CounterweightDialogBoxState extends State<CounterweightDialogBox> {
  String selectionChoice = "Single";
  String title = "";
  String namePlaceholder = "";
  bool _dataLoaded = false;
  List<dynamic> _isSelectedOptions = [];
  List<Counterweight> counterweightOptions = [];
  String? counterweightName;
  String? counterweightManufacturer;
  double? counterweightWeight;
  double? counterweightHeight;
  
  @override void initState() {
    super.initState();
    _setData();
    _loadData().then((_) {
      setState(() {
        _dataLoaded = true;
      });
    });
  }
  
  void _setData() {
    setState(() {
      if (selectionChoice == "Single") {
        title = "New Counterweight";
        namePlaceholder = "Name";
      }
      else {
        title = "New Counterweight Group";
        namePlaceholder = "Group Name";
        counterweightManufacturer = null;
        counterweightWeight = null;
        counterweightHeight = null;
      }
      // print(selectionChoice);
    });
  }

  Future<Counterweight?> _saveCounterweight(String? name, String? manufacturer, double? weight, double? height) async {
    var db = DatabaseManager();
    await db.init();
    if (name != null && manufacturer != null && weight != null && height != null) {
      return await db.addCounterweight(name, manufacturer, weight, height);
    }
    return null;
  }

  Future<CounterweightSetup?> _saveCounterweightSetup(String? name, List<dynamic> counterweights) async {
    var db = DatabaseManager();
    await db.init();
    if (name != null && counterweights.isNotEmpty) {
      return await db.addCounterweightSetup(name, counterweights.map((e) => e as Counterweight).toList());
    }
    return null;
  }

  Future<void> _loadData() async {
    var db = DatabaseManager();
    await db.init();
    counterweightOptions = await db.getCounterweights();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title),
            const SizedBox(height: 16),
            CupertinoSegmentedControl(
              onValueChanged: (String value) { setState((){selectionChoice = value; _setData(); _loadData();}); },
              children: const {
                'Single': Text("    Single    "),
                'Group': Text("    Group    ")
              }
            ),
            TextField(
              decoration: InputDecoration(
                labelText: namePlaceholder,
              ),
              onChanged: (value) => counterweightName = value,
            ),
            const SizedBox(height: 16),
            selectionChoice == "Single" ? 
              Column(children: [
                TextField(decoration: const InputDecoration(
                  labelText: "Manufacurer"
                  ), onChanged: (value) => counterweightManufacturer = value,
                ),
                const SizedBox(height: 16),
                TextField(
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
                  decoration: const InputDecoration(
                  labelText: "Weight"
                  ), onChanged: (value) => counterweightWeight = double.parse(value),
                ),
                const SizedBox(height: 16),
                TextField(
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
                  decoration: const InputDecoration(
                  labelText: "Height"
                  ), onChanged: (value) => counterweightHeight = double.parse(value),
                )
              ])
              : Column(children: [
                const Text("Select counterweights"),
                _dataLoaded ? Column(
                  children: [
                    ...counterweightOptions.map((e) {
                      return CheckboxListTile(
                        title: Text(e.toString(), style: const TextStyle(fontSize: 12)),
                        value: _isSelectedOptions.contains(e),
                        onChanged: (bool? value) {
                          setState(() {
                            if (value ?? false) {
                              _isSelectedOptions.add(e);
                            } else {
                              _isSelectedOptions.remove(e);
                            }
                          });
                        }
                      );
                    })
                  ]
                ):
                const Center (child: CircularProgressIndicator()),
              ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  child: const Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text("Save"),
                  onPressed: () async {
                    if (selectionChoice == "Single") {
                      Navigator.of(context).pop();
                      await _saveCounterweight(counterweightName, counterweightManufacturer, counterweightWeight, counterweightHeight);
                    } else if (selectionChoice == "Group") {
                      Navigator.of(context).pop();
                      await _saveCounterweightSetup(counterweightName, _isSelectedOptions);
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}