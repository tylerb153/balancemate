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

  int getId() {
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

  double? getDistance() {
    return _distance;
  }

  int getId() {
    return _id;
  }

}

class Counterweight {
  final int _id;
  final String _name;
  final String _manufacturer; 
  final double _weight;
  final double _height;

  Counterweight(this._id, this._name, this._manufacturer, this._weight, this._height);

  @override
  String toString() {
    return "$_manufacturer - $_name";
  }

  double getWeight() {
    return _weight;
  }
  double getHeight() {
    return _height;
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

  @override
  String toString() {
    return _name;
  }

  List<Counterweight> getCounterweights() {
    return _counterweights;
  }

  int getId() {
    return _id;
  }
}

class DatabaseManager {
  DatabaseManager();
  late Database db;
  init() async {
    var databasesPath = await getDatabasesPath();
    print(databasesPath);
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
          "CREATE TABLE counterweightSetups(id INTEGER PRIMARY KEY, name TEXT, counterweights TEXT)"
        );
      });

    String jsonString = await rootBundle.loadString('assets/telescopes.json');
    // '''
    //   {
    //     "telescopes": [
    //       {
    //         "Name": "Edge HD 8\\"",
    //         "Manufacturer": "Celestron",
    //         "Weight": 6.35,
    //         "Diameter": 238
    //       }
    //     ]
    //   }
    // ''';
    // I used this to test the decoding

    Map<String, dynamic> decodedJson = jsonDecode(jsonString);

    var telescopesJson = decodedJson["telescopes"];

    for (var telescope in telescopesJson) {
      // print(double.parse(telescope["Diameter"].toString()));
      // return Telescope(-1, json['Name'], json['Manufacturer'], json['Weight'], 0.0 + json['Diameter']);
      // print(telescope.toString());

      await db.execute('INSERT OR IGNORE INTO telescopes VALUES(?, ?, ?, ?, ?)', [telescope["ID"], telescope["Name"], telescope["Manufacturer"], telescope["Weight"] + 0.0, telescope["Diameter"] + 0.0]);
    }
    
    jsonString = await rootBundle.loadString('assets/mounts.json');
    decodedJson = jsonDecode(jsonString);
    var mountsJson = decodedJson["mounts"];
    for (var mount in mountsJson) {
      // print(mount["Distance"].runtimeType);
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
      await db.execute('INSERT OR IGNORE INTO counterweightSetups VALUES(${counterweightSetup["ID"]}, "${counterweightSetup["Name"]}", "${counterweightSetup["Counterweights"]}")');
    }
  }
  Future<List<Telescope>> getTelescopes() async {
    List<Telescope> telescopes = [];
    var dbTelescopes = await db.rawQuery('SELECT * FROM telescopes');
    // print(dbTelescopes);
    for (var telescope in dbTelescopes) {
      // print(telescope);
      telescopes.add(Telescope.fromSQL(telescope));
    }
    // print(telescopes[0].toString());
    return telescopes;
  }

  void addTelescope(Telescope telescope) {
    //TODO: Interface with the database
  }

  List<Mount> getMounts() {
    return [];
    //TODO: Interface with the database
  }

  List<Counterweight> getCounterweights() {
    return [];
    //TODO: Interface with the database
  }

  List<CounterweightSetup> getCounterweightSetups() {
    return [];
    //TODO: Interface with the database
  }
}