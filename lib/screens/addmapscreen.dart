import 'package:flutter/material.dart';

import 'controlscreen.dart';

class AddMapScreen extends StatefulWidget {
  const AddMapScreen({Key? key}) : super(key: key);

  @override
  State<AddMapScreen> createState() => _AddMapScreenState();
}

class _AddMapScreenState extends State<AddMapScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
        elevation: 2,
        centerTitle: true,
        backgroundColor: Colors.indigo.shade900,
        leading: IconButton(onPressed: (){
          Navigator.pushReplacement(context,MaterialPageRoute(
            builder: (context) => const ControlScreen(),
          ));
        }, icon:const Icon(Icons.arrow_back_ios_rounded)),
        title: const Text("Add Map", style: TextStyle( fontWeight: FontWeight.bold , fontSize: 20),),
      ),
      backgroundColor: Colors.indigo.shade900,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                const TextField(
                  decoration: InputDecoration(
                    hintText: 'Device Id',
                    hintStyle: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color:Colors.yellow , width: 2)),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color:Colors.grey , width: 2)),

                  ),
                ),

                const SizedBox(height:30),

                const TextField(
                  decoration: InputDecoration(
                    hintText: 'Device Name',
                    hintStyle: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color:Colors.yellow , width: 2)),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color:Colors.grey , width: 2)),

                  ),
                ),

                const SizedBox(height:30),

                Container(
                  alignment: Alignment.centerLeft,
                  child: OutlinedButton(onPressed:(){
                  },
                    style:OutlinedButton.styleFrom(
                        backgroundColor: Colors.yellow,
                        minimumSize: const Size(80, 40),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))
                    ),
                    child:const Text('Add', style: TextStyle(fontWeight: FontWeight.bold , color: Colors.white,),),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
