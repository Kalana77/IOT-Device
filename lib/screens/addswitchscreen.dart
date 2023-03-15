import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:iot_app/helper/constants.dart';

import '../services/auth.dart';
import '../services/database.dart';
import 'controlscreen.dart';

class AddSwitchScreen extends StatefulWidget {
  const AddSwitchScreen({Key? key}) : super(key: key);

  @override
  State<AddSwitchScreen> createState() => _AddSwitchScreenState();
}

class _AddSwitchScreenState extends State<AddSwitchScreen> {



  bool isValidDeviceId = false;
  bool isValidDeviceName = false;
  bool deviceIdError = false;
  bool deviceNameError = false;
  String deviceIdErrorMsg = "";
  String deviceNameErrorMsg = "";


  AuthMethods authMethods = AuthMethods();
  DataBaseMethod dataBaseMethod = DataBaseMethod();

  SingleValueDropDownController deviceIdTextEditingController = SingleValueDropDownController();
  TextEditingController deviceNameTextEditingController = TextEditingController();

  List<dynamic> devicesList = [];
  Map<String,dynamic> devicesNames = {};
  Map<dynamic,dynamic> devices = {};
  List<DropDownValueModel> dropDownDevicesId = [];
  List<dynamic> devicesId = [];

  @override
  void initState() {
    super.initState();

    dataBaseMethod.getDevicesInfo(Constants.myUid).then((value){
      setState((){
        if(value.data()!.length > 2){
          devicesNames = value["devices name"];
          devicesList = value["devices List"];
        }

      });

      dataBaseMethod.getDevicesStatus(Constants.myUid).then((value){
        setState((){

          devices = (value.snapshot.value as Map?)!;
          if(value.snapshot.value != null){
            for(var key in devices.keys){
              if(!devicesNames.containsKey(key) && key.toString() != "boardStatus"){
                dropDownDevicesId.add(DropDownValueModel(name: key, value: key),);
                devicesId.add(key);
              }
            }
          }
        });
      });

    });
  }

  addSwitch(){

    validateDeviceId();
    validateDeviceName();

    if(isValidDeviceId && isValidDeviceName){
      devicesNames.addAll({deviceIdTextEditingController.dropDownValue!.value:deviceNameTextEditingController.text});
      devicesList.add(deviceIdTextEditingController.dropDownValue!.value);
      dataBaseMethod.addSwitches(devicesList,devicesNames, Constants.myUid);
      dataBaseMethod.updateDevicesStatus(0, deviceIdTextEditingController.dropDownValue!.value,Constants.myUid);

      removeIdFromList(deviceIdTextEditingController.dropDownValue!.value);

      deviceIdTextEditingController.clearDropDown();
      deviceNameTextEditingController.clear();
    }

  }

  removeIdFromList(String key){
    int index = devicesId.indexOf(key);
    dropDownDevicesId.removeAt(index);
    devicesId.removeAt(index);
  }

  InputDecoration textFiledInputDecoration(text,bool isError, String errorMsg){
    return InputDecoration(
      errorText: isError ? errorMsg:null,
      hintText: text,
      //border:OutlineInputBorder(borderSide: BorderSide(color:Colors.white) ,borderRadius:BorderRadius.circular(50)),
      hintStyle: const TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold),
      focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color:Colors.yellow , width: 2)),
      enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color:Colors.grey , width: 2)),
      errorBorder: const UnderlineInputBorder(borderSide: BorderSide(color:Colors.red , width: 2)),
      focusedErrorBorder: const UnderlineInputBorder(borderSide: BorderSide(color:Colors.red, width: 2)),
      //alignLabelWithHint:
    );
  }

  validateDeviceId(){

    setState((){
      deviceIdError = false;
      isValidDeviceId = false;
    });

    if(deviceIdTextEditingController.dropDownValue == null){
      setState((){
        deviceIdError = true;
        deviceIdErrorMsg = "Can not be empty";
      });
    }else{
      setState((){
        isValidDeviceId = true;
      });
    }
  }

  validateDeviceName(){

    setState((){
      deviceNameError = false;
      isValidDeviceName = false;
    });

    if(deviceNameTextEditingController.text.isEmpty){
      setState((){
        deviceNameError = true;
        deviceNameErrorMsg = "Can not be empty";
      });
    }else{
      setState((){
        isValidDeviceName = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //alignLabelWithHint:
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
        title: const Text("Add Switch", style: TextStyle( fontWeight: FontWeight.bold , fontSize: 20),),
      ),
      backgroundColor: Colors.indigo.shade900,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [




                DropDownTextField(
                  singleController: deviceIdTextEditingController,
                  dropDownList: dropDownDevicesId,
                  dropDownItemCount: dropDownDevicesId.length,
                  listTextStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  textStyle: const TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold),
                  textFieldDecoration: textFiledInputDecoration("Device Id", deviceIdError, deviceIdErrorMsg),
                ),

                const SizedBox(height:30),

                TextField(
                  controller: deviceNameTextEditingController,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  decoration: textFiledInputDecoration("Device Name", deviceNameError, deviceIdErrorMsg),
                ),

                const SizedBox(height:30),

                Container(
                  alignment: Alignment.centerLeft,
                  child: OutlinedButton(onPressed:(){

                    addSwitch();

                  },
                    style:OutlinedButton.styleFrom(
                        backgroundColor: Colors.yellow,
                        minimumSize: const Size(80, 40),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))
                    ),
                    child:const Text('Add', style: TextStyle(fontWeight: FontWeight.bold , color: Colors.white,),),
                  ),
                ),

                const SizedBox(height:50),

                Container(
                  alignment: Alignment.topCenter,
                  child: Text("User ID : " + Constants.myUid, style: TextStyle(color: Colors.grey),),

                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
