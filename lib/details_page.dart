import 'package:flutter/material.dart';

class DetailsPage extends StatefulWidget{
  const DetailsPage({super.key});
  @override
  State<StatefulWidget> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
    @override
    Widget build(BuildContext context) {
    return const Scaffold(
      body: 
        SafeArea(child: 
          Padding(padding: EdgeInsets.all(16), child:
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Measurements and Details", style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),),
                SizedBox(height: 16), 
                Text("Telescope Weight"),
                SizedBox(height: 16), 
                Text("Mount Weight"),
                SizedBox(height: 16), 
                Text("Counterweight weight"),
                SizedBox(height: 16), 
                Text("How far from Mount point"),
                SizedBox(height: 16)
              ],
            )
          )  
        )
    );
  }
}
