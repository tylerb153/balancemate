import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class Telescope {
  final int _id;
  final String _name;
  final String _manufacturer; 
  final double _weight; 
  final double _diameter;

  Telescope(this._id, this._name, this._manufacturer, this._weight, this._diameter);

  static Telescope fromSQL(Map<String, dynamic> telescope) {
    return Telescope(telescope['id'], telescope['name'], telescope['manufacturer'], telescope['weight'], telescope['diameter']);
  }

  @override
  String toString() {
    return "$_manufacturer - $_name";
  }
  @override 
  bool operator == (Object other) {
    if (other is Telescope) { 
      return _id == other._id;
    }
    return false;
  }
  @override
  int get hashCode => _id;

  int? getId() {
    return _id;
  }

  double getWeight() {
    return _weight;
  }

  double getDiameter() {
    return _diameter;
  }  
}

class Mount {
  final int _id;
  final String _name;
  final String _manufacturer; 
  double? _distance; //This is the distance from the RA to the Telescope Saddle this is not a number that is given generally

  Mount(this._id,this._name, this._manufacturer, this._distance);
  Mount.withoutDistance(this._id, this._name, this._manufacturer);

  @override
  String toString() {
    return "$_manufacturer - $_name";
  }
  @override 
  bool operator == (Object other) {
    if (other is Mount) { 
      return _id == other._id;
    }
    return false;
  }
  @override
  int get hashCode => _id;

  double? getDistance() {
    return _distance;
  }

  int getId() {
    return _id;
  }

  static Mount fromSQL(Map<String, dynamic> mount) {
    return Mount(mount['id'], mount['name'], mount['manufacturer'], mount['distance']);
  }

}

class Counterweight {
  final int _id;
  final String _name;
  final String _manufacturer; 
  final double _weight;
  final double _height;

  Counterweight(this._id, this._name, this._manufacturer, this._weight, this._height);

  static Counterweight fromSQL(Map<String, dynamic> counterweight) {
    return Counterweight(counterweight['id'], counterweight['name'], counterweight['manufacturer'], counterweight['weight'], counterweight['height']);
  }

  @override
  String toString() {
    return "$_manufacturer - ${_weight}kg";
  }
  
  @override 
  bool operator == (Object other) {
    if (other is Counterweight) { 
      return _id == other._id;
    }
    return false;
  }
  @override 
  int get hashCode => _id;

  double getWeight() {
    return _weight;
  }
  double getHeight() {
    return _height;
  }
  String getName() {
    return _name;
  }

  int getId() {
    return _id;
  }
}

class CounterweightSetup {
  final int _id;
  final String _name;
  final List<Counterweight> _counterweights;

  CounterweightSetup(this._id, this._name, this._counterweights);

  static CounterweightSetup fromSQL(Map<String, dynamic> counterweightSetup, List<Counterweight> counterweights) {
    return CounterweightSetup(counterweightSetup['id'], counterweightSetup['name'], counterweights);
  }

  @override
  String toString() {
    return _name;
  }

  @override
  bool operator ==(Object other) {
    if (other is CounterweightSetup) { 
      return _id == other._id;
    }
    return false;
  }
  @override 
  int get hashCode => _id;

  List<Counterweight> getCounterweights() {
    return _counterweights;
  }

  int getId() {
    return _id;
  }
  String getName() {
    return "$_name - $_counterweights";
  }
  double getWeight() {
    double totalWeight = 0.0;
    for (Counterweight counterweight in _counterweights) {
      totalWeight += counterweight.getWeight();
    }
    return totalWeight;
  }
}

class DatabaseManager {
  DatabaseManager();
  late Database db;
  init() async {
    var databasesPath = await getDatabasesPath();
    // print(databasesPath); // left in here so I can find the database and delete it or view it
    String path = join(databasesPath, "database.db");
    db = await openDatabase(path, version: 1, onCreate: 
      (Database db, int version) async {
        await db.execute(
          "CREATE TABLE telescopes(id INTEGER PRIMARY KEY, name TEXT, manufacturer TEXT, weight REAL, diameter REAL)"
        );
        await db.execute(
          "CREATE TABLE mounts(id INTEGER PRIMARY KEY, name TEXT, manufacturer TEXT, distance REAL DEFAULT NULL)"
        );
        await db.execute(
          "CREATE TABLE counterweights(id INTEGER PRIMARY KEY, name TEXT, manufacturer TEXT, weight REAL, height REAL)"
        );
        await db.execute(
          "CREATE TABLE counterweight_setups(id INTEGER PRIMARY KEY, name TEXT, counterweights TEXT)"
        );
      });

    String jsonString = await rootBundle.loadString('assets/telescopes.json');
    Map<String, dynamic> decodedJson = jsonDecode(jsonString);

    var telescopesJson = decodedJson["telescopes"];

    for (var telescope in telescopesJson) {
      await db.execute('INSERT OR IGNORE INTO telescopes VALUES(?, ?, ?, ?, ?)', [telescope["ID"], telescope["Name"], telescope["Manufacturer"], telescope["Weight"] + 0.0, telescope["Diameter"] + 0.0]);
    }
    
    jsonString = await rootBundle.loadString('assets/mounts.json');
    decodedJson = jsonDecode(jsonString);
    var mountsJson = decodedJson["mounts"];
    for (var mount in mountsJson) {
      if (mount["Distance"] == null) {
        db.execute('INSERT OR IGNORE INTO mounts (id, name, manufacturer) VALUES(${mount["ID"]}, "${mount["Name"]}", "${mount["Manufacturer"]}")');
      }
      else {
        db.execute('INSERT OR IGNORE INTO mounts VALUES(${mount["ID"]}, "${mount["Name"]}", "${mount["Manufacturer"]}", ${mount["Distance"] + 0.0})');
      }
    }

    jsonString = await rootBundle.loadString('assets/counterweights.json');
    decodedJson = jsonDecode(jsonString);
    var counterweightsJson = decodedJson["counterweights"];
    for (var counterweight in counterweightsJson) {
      await db.execute('INSERT OR IGNORE INTO counterweights VALUES(${counterweight["ID"]}, "${counterweight["Name"]}", "${counterweight["Manufacturer"]}", ${counterweight["Weight"] + 0.0}, ${counterweight["Height"] + 0.0})');
    }

    jsonString = await rootBundle.loadString('assets/counterweight_setups.json');
    decodedJson = jsonDecode(jsonString);
    var counterweightSetupsJson = decodedJson["counterweight_setups"];
    for (var counterweightSetup in counterweightSetupsJson) {
      await db.execute('INSERT OR IGNORE INTO counterweight_setups VALUES(${counterweightSetup["ID"]}, "${counterweightSetup["Name"]}", "${counterweightSetup["Counterweights"]}")');
    }
  }

  Future<void> close() async {
    await db.close();
  }

  Future<List<Telescope>> getTelescopes() async {
    List<Telescope> telescopes = [];
    var dbTelescopes = await db.rawQuery('SELECT * FROM telescopes');
    for (var telescope in dbTelescopes) {
      telescopes.add(Telescope.fromSQL(telescope));
    }
    return telescopes;
  }

  Future<Telescope?> addTelescope(String name, String manufacturer, double weight, double diameter) async {
    await db.rawQuery('INSERT INTO telescopes (name, manufacturer, weight, diameter) VALUES(?, ?, ?, ?)', [name, manufacturer, weight, diameter]);
    var result = await db.rawQuery('SELECT * FROM telescopes WHERE rowid = last_insert_rowid()');
    if (result.isNotEmpty) {
      return Telescope.fromSQL(result.first);
    }
    return null;
  }

  Future<List<Mount>> getMounts() async {
    List<Mount> mounts = [];
    var dbMounts = await db.rawQuery('SELECT * FROM mounts');
    for (var mount in dbMounts) {
      mounts.add(Mount.fromSQL(mount));
    }
    return mounts;
  }

  Future<List<Counterweight>> getCounterweights() async {
    List<Counterweight> counterweights = [];
    var dbCounterweights = await db.rawQuery('SELECT * FROM counterweights');
    for (var counterweight in dbCounterweights) {
      counterweights.add(Counterweight.fromSQL(counterweight));
    }
    return counterweights;
  }

  Future<Counterweight?> addCounterweight(String name, String manufacturer, double weight, double height) async {
    await db.rawQuery('INSERT INTO counterweights (name, manufacturer, weight, height) VALUES(?, ?, ?, ?)', [name, manufacturer, weight, height]);
    var result = await db.rawQuery('SELECT * FROM counterweights WHERE rowid = last_insert_rowid()');
    if (result.isNotEmpty) {
      return Counterweight.fromSQL(result.first);
    }
    return null;
  }

  Future<List<CounterweightSetup>> getCounterweightSetups() async {
    List<CounterweightSetup> counterweightSetups = [];
    List<Counterweight> counterweights = await getCounterweights();
    var dbCounterweightSetups = await db.rawQuery('SELECT * FROM counterweight_setups');
    for (var counterweightSetup in dbCounterweightSetups) {
      List<Counterweight> counterweightsToAdd = [];
      for (Counterweight counterweight in counterweights) {
        if (counterweightSetup["counterweights"].toString().contains(counterweight.getId().toString())) {
          counterweightsToAdd.add(counterweight);
        }
      }
      counterweightSetups.add(CounterweightSetup.fromSQL(counterweightSetup, counterweightsToAdd));
    }
    return counterweightSetups;
  }

  Future<CounterweightSetup?> addCounterweightSetup(String name, List<Counterweight> counterweights) async {
  String counterweightIDs = "";
  for (var counterweight in counterweights) {
    counterweightIDs += "${counterweight.getId()}, ";
  }
  await db.rawQuery('INSERT INTO counterweight_setups (name, counterweights) VALUES(?, ?)', [name, counterweightIDs]);
  var result = await db.rawQuery('SELECT * FROM counterweight_setups WHERE rowid = last_insert_rowid()');
  if (result.isNotEmpty) {
    return CounterweightSetup.fromSQL(result.first, counterweights);
  }
  return null;
  }
}