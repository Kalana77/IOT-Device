import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iot_app/helper/constants.dart';
import 'package:iot_app/screens/mapscreen.dart';
import 'package:iot_app/screens/settingscreen.dart';
import '../services/database.dart';


class ControlScreen extends StatefulWidget {
   const ControlScreen({Key? key}) : super(key: key);
  @override
  State<ControlScreen> createState() => _ControlScreenState();

}

class _ControlScreenState extends State<ControlScreen> {

  DataBaseMethod dataBaseMethod = DataBaseMethod();


  Stream<DocumentSnapshot<Map<String, dynamic>>>? devices;
  Map<dynamic,dynamic>? devicesStates;



  @override
  void initState() {
    super.initState();
    dataBaseMethod.getDevices(Constants.myUid).then((value){
      setState((){
        devices=value;

      });
    });
    dataBaseMethod.updateDevicesStatus(0, "boardStatus", Constants.myUid);
    dataBaseMethod.devicesStatusListener(buttonStatus,Constants.myUid);
    dataBaseMethod.getDevicesStatus(Constants.myUid).then((value){
        setState((){devicesStates = value.snapshot.value as Map?;});
    });
  }

  buttonStatus(status){
    setState((){
      devicesStates = status;
    });
  }

  Widget devicesStream(){
    return devices == null ? const Text("Devices Not Connected",style: TextStyle(color: Colors.grey),)
        : StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: devices,
        builder:(BuildContext context,AsyncSnapshot <DocumentSnapshot<Map<String, dynamic>>> snapshot){
          if(snapshot.data != null && snapshot.data!.data()!.length > 2 && devicesStates != null){
            return buttonWidget(snapshot.data!.data()!["devices List"],snapshot.data!.data()!["devices name"]);
          }
          else{
            return const Text("Devices Not Connected",style: TextStyle(color: Colors.grey),);
          }
      }
    );
  }


  Widget buttonWidget(List<dynamic> devicesId, Map<String,dynamic> devicesName){
    return Wrap(
      spacing: 20,
      runSpacing: 20,

      children: devicesId.map((id) => controlButtons(devicesName[id],id)).toList(),
    );
  }

  Widget controlButtons(String name,String id){
    return OutlinedButton(
      onPressed:(){
        int status = 0;
        if(devicesStates![id] == 1){
          status = 0;
        }
        else{
          status = 1;
        }
        devicesStates!["boardStatus"] == 0 ? null :DataBaseMethod().updateDevicesStatus(status, id, Constants.myUid);
      },

      style: OutlinedButton.styleFrom(
          fixedSize: const Size(170, 80),
          backgroundColor: devicesStates![id] == 1 ? Colors.yellow.shade100 : Colors.blueGrey.shade100,
          primary: devicesStates![id]== 1 ? Colors.yellow.shade800 : Colors.blueGrey,
          //side: BorderSide(color:Colors.transparent,),
          elevation: 5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
      ),
      child:Row(
        children: [
          Expanded(
            child: devicesStates!["boardStatus"] == 0 ? const Text("Connecting...",style: TextStyle(fontSize:15,fontWeight: FontWeight.bold)): Container(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      devicesStates![id] == 1 ?"ON":"OFF",
                      style: const TextStyle(fontSize:15,fontWeight: FontWeight.bold)
                  ),

                  Wrap(
                    children: [
                      Text(
                          name,
                          style: const TextStyle(fontSize:15,fontWeight: FontWeight.bold)
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          Container(
              padding: const EdgeInsets.only(right: 5),
              child: Icon(
                devicesStates![id] == 1 ? Icons.lightbulb:Icons.lightbulb_outlined,
                //Icons.lightbulb_outlined,
                color: devicesStates![id] == 1 ? Colors.yellow.shade800:Colors.grey.shade200,
                size: 25,
              )
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
        elevation: 2,
        centerTitle: true,
        backgroundColor: Colors.indigo.shade900,
        actions: [IconButton(onPressed: (){
          Navigator.pushReplacement(context,MaterialPageRoute(
            builder: (context) => const SettingScreen(),
          ));
        },icon:const Icon(Icons.settings)
        )],
        title: const Text("Let's Switch", style: TextStyle( fontWeight: FontWeight.bold , fontSize: 20),),
      ),
      backgroundColor: Colors.indigo.shade900,
      body:Column(
        //mainAxisSize: MainAxisSize.min,
        //mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 25,right: 10),
            height: 120,
            alignment: Alignment.topRight,
            child: OutlinedButton(onPressed: (){

              Navigator.pushReplacement(context,MaterialPageRoute(
                builder: (context) => const MapScreen(),
              ));

            },

              style: OutlinedButton.styleFrom(
                  side: const BorderSide(color:Colors.transparent,),
                  backgroundColor: Colors.white10,
                  fixedSize: const Size(130,60),
                  //elevation: 1,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
              ),

              child:Row(
                children: const [
                  Text("View Map",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold),),

                  Icon(Icons.navigate_next_sharp,color: Colors.grey,size: 30,)
                ],
              ),
            ),
          ),
          Flexible(
            child: Container(
                alignment: Alignment.center,
                child: SingleChildScrollView(child: devicesStream())),
          ),
        ],
      ),
    );
  }
}


