import 'package:flutter/material.dart';

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
          )
    );
  }
}
