import 'package:balancemate/database_manager.dart';
class Calculator {
  Calculator();

  static Telescope? telescope;
  static Mount? mount;
  static dynamic counterweight;

  static double? calculateDistance() {
    if (telescope == null || mount == null || counterweight == null) {
      return null;
    }
    double radius = telescope!.getDiameter() / 2;
    double weight = telescope!.getWeight();
    double? distance = mount!.getDistance();
    double counterweightWeight = 0.0;
    // ignore: non_constant_identifier_names it isn't used in enough places to worry about
    double RA2TelescopeCenter; 

    if (counterweight is Counterweight) {
      counterweightWeight = counterweight.getWeight();
    }
    else if (counterweight is CounterweightSetup) {
      for (var i in counterweight.getCounterweights()) {
        counterweightWeight += i.getWeight();
      }
    }
    if (distance != null) {
      RA2TelescopeCenter = (distance + radius) / 1000;
    }
    else {
      RA2TelescopeCenter = radius / 1000;
    }
    // print("radius: $radius");
    // print("weight: $weight");
    // print("distance: $distance");
    // print("counterweightWeight: $counterweightWeight");
    // print("RA2TelescopeCenter: $RA2TelescopeCenter");
    // print(counterweightSetup.toString());
    double momentLoad = (weight * 9.81) * RA2TelescopeCenter;
    return (momentLoad / (counterweightWeight * 9.81) * 1000);
  }
}



// Telescope with 16.32kg and 271
// Mount with 100mm distance
// 21lb iOptron
// result 403mm 
//INSERT OR IGNORE INTO mounts VALUES(100, "test me", "Jacob", 100.0})