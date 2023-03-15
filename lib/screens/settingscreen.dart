
import 'package:flutter/material.dart';
import 'package:iot_app/screens/addmapscreen.dart';
import 'package:iot_app/screens/addswitchscreen.dart';
import 'package:iot_app/screens/changelogin.dart';
import 'package:iot_app/screens/controlscreen.dart';
import 'package:iot_app/screens/loginscreen.dart';
import 'package:iot_app/services/auth.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    AuthMethods authMethods = AuthMethods();


    logOut(){

      authMethods.signOut();

      Navigator.push(context,MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ));

    }


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
        title: const Text("Setting", style: TextStyle( fontWeight: FontWeight.bold , fontSize: 20),),
      ),
      backgroundColor: Colors.indigo.shade900,

      body: Column(
        children: [

          SizedBox(
            height: 80,
            width: double.infinity,
            child: GestureDetector(
              onTap: () {
                Navigator.push(context,MaterialPageRoute(
                  builder: (context) => const AddSwitchScreen(),
                ));
              },
              child: Card(
                shadowColor: Colors.blueAccent,
                color: Colors.indigo.shade900,
                elevation: 3,
                //semanticContainer: true,
                //clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    alignment: Alignment.centerLeft,
                    child: const Text("Switch", style: TextStyle( color: Colors.white ,fontWeight: FontWeight.bold , fontSize: 18,),)),),
            ),
          ),

          SizedBox(
            height: 80,
            width: double.infinity,
            child: GestureDetector(
              onTap: () {
                Navigator.push(context,MaterialPageRoute(
                  builder: (context) => const AddMapScreen(),
                ));
              },
              child: Card(
                shadowColor: Colors.blueAccent,
                color: Colors.indigo.shade900,
                elevation: 3,
                //semanticContainer: true,
                //clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    alignment: Alignment.centerLeft,
                    child: const Text("Map", style: TextStyle( color: Colors.white ,fontWeight: FontWeight.bold , fontSize: 18,),)),),
            ),
          ),

          SizedBox(
            height: 80,
            width: double.infinity,
            child: GestureDetector(
              onTap: () {
                Navigator.push(context,MaterialPageRoute(
                  builder: (context) => const ChangeLoginScreen(),
                ));
              },
              child: Card(

                shadowColor: Colors.blueAccent,
                color: Colors.indigo.shade900,
                elevation: 3,
                //semanticContainer: true,
                //clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    alignment: Alignment.centerLeft,
                    child: const Text("Change Password", style: TextStyle( color: Colors.white ,fontWeight: FontWeight.bold , fontSize: 18,),)),),
            ),
          ),

          SizedBox(
            height: 80,
            width: double.infinity,
            child: GestureDetector(
              onTap: () {
                logOut();
              },
              child: Card(
                shadowColor: Colors.blueAccent,

                color: Colors.indigo.shade900,
                elevation: 3,
                //semanticContainer: true,
                //clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    alignment: Alignment.centerLeft,
                    child: const Text("LogOut", style: TextStyle( color: Colors.red ,fontWeight: FontWeight.bold , fontSize: 18,),)),),
            ),
          ),


        ],
      ),
    );
  }
}
