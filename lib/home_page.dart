import 'package:flutter/material.dart';
import 'package:balancemate/calculator.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
                const SizedBox(height: 32,),
                Align(alignment: Alignment.centerLeft, child:
                  Column(children: [
                    Row(children: [
                      const Text('Telescope: ', style: TextStyle(fontWeight: FontWeight.bold)),
                      Expanded(child: 
                        Text(Calculator.telescope != null ? Calculator.telescope.toString() : "No Telescope Selected", softWrap: true, overflow: TextOverflow.ellipsis)
                      )
                    ]),
                    const SizedBox(height: 8),
                    Row(children: [
                      const Text('Mount: ', style: TextStyle(fontWeight: FontWeight.bold)),
                      Expanded(child:
                        Text(Calculator.mount != null ? Calculator.mount.toString() : "No Mount Selected", softWrap: true, overflow: TextOverflow.ellipsis)
                      )
                    ]),
                    const SizedBox(height: 8),
                    Row(children: [
                      const Text('Counterweight: ', style: TextStyle(fontWeight: FontWeight.bold)),
                      Expanded(child: 
                        Text(Calculator.counterweight != null ? Calculator.counterweight.toString() : "No Counterweight Selected", softWrap: true, overflow: TextOverflow.ellipsis)
                      )
                    ]),
                    const SizedBox(height: 32),
                    const Center(child: Text('Counterweight Distance: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20))),
                    Text(Calculator.calculateDistance() != null ? "${Calculator.calculateDistance()!.round().toString()}mm" : "There is no valid setup!", softWrap: true, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 20))
                  ])
                ),
                const SizedBox(height: 32),
                Center(child: Image.asset("assets/Amazing and extremely cool telescope icon that's certainly not just dev art ;D.png")),
              ]),
            )
        )
    );
  }
}
