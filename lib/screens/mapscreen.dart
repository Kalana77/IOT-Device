import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'controlscreen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {

  bool isImageExists = false;


  @override
  void initState() {

    rootBundle.load("assets/images/houseMap.png").then((value){
      setState((){
        isImageExists = true;
      });
    }).catchError((err){
      setState((){
        isImageExists = false;
      });
    });
    //print(File("assets/images/houseMap.png").exists().);
    super.initState();
  }

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
        title: const Text("Map", style: TextStyle( fontWeight: FontWeight.bold , fontSize: 20),),
      ),
        backgroundColor: Colors.indigo.shade900,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        //mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 7),
            alignment: Alignment.bottomLeft,
            child: const Text("No 22,Malwathta Rd, Colombo",
               style: TextStyle( fontWeight: FontWeight.bold , fontStyle: FontStyle.italic, color: Colors.white),
            ),
          ),

          isImageExists? Container(
            //padding: EdgeInsets.symmetric(horizontal: 10),
            height: 500,
            //width: double.infinity,
            decoration: const BoxDecoration(
              //color: Colors.black,
              shape: BoxShape.rectangle,
              image: DecorationImage(
                image:AssetImage("assets/images/houseMap.png"),
                fit: BoxFit.scaleDown
              ),
            ),
          ):Container(),
        ],
      ),
    );
  }
}
