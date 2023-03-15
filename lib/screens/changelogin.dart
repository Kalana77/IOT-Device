import 'package:flutter/material.dart';
import 'package:iot_app/helper/constants.dart';

import '../services/auth.dart';
import 'controlscreen.dart';

class ChangeLoginScreen extends StatefulWidget {
  const ChangeLoginScreen({Key? key}) : super(key: key);

  @override
  State<ChangeLoginScreen> createState() => _ChangeLoginScreenState();
}

class _ChangeLoginScreenState extends State<ChangeLoginScreen> {


  bool isLoading = false;
  bool isValidCurrentPassword = false;
  bool isValidNewPassword = false;
  bool currentPasswordError = false;
  bool newPasswordError = false;
  String currentPasswordErrorMsg = "";
  String newPasswordErrorMsg = "";


  AuthMethods authMethods = AuthMethods();

  TextEditingController currentPasswordTextEditingController = TextEditingController();
  TextEditingController newPasswordTextEditingController = TextEditingController();
  TextEditingController confirmNewPasswordTextEditingController = TextEditingController();



  changePassword(){

    validCurrentPassword();
    validNewPassword();

    if(isValidCurrentPassword && isValidNewPassword){
      authMethods.gerCredential(Constants.myEmail, currentPasswordTextEditingController.text).then((value) {
        authMethods.changePassword(Constants.myEmail, value, newPasswordTextEditingController.text);

        showAlertDialog(context);

        currentPasswordTextEditingController.clear();
        newPasswordTextEditingController.clear();
        confirmNewPasswordTextEditingController.clear();

      }).catchError((error){
        setState((){
          currentPasswordError = true;
          currentPasswordErrorMsg = "Invalid Password";

        });
      });
    }

  }

  validCurrentPassword(){

    setState((){
      currentPasswordError = false;
    });

    if(currentPasswordTextEditingController.text.isEmpty){
      setState((){
        currentPasswordError = true;
        currentPasswordErrorMsg = "Can not be empty";
      });
    }
    else{
      setState(() {
        isValidCurrentPassword = true;
      });
    }
  }

  validNewPassword(){
    setState((){
      newPasswordError = false;
    });

    if(newPasswordTextEditingController.text.isEmpty){
      setState((){
        newPasswordError = true;
        newPasswordErrorMsg = "Can not be empty";
      });
    }
    else{
      if(newPasswordTextEditingController.text.length< 7){
        setState((){
          newPasswordError = true;
          newPasswordErrorMsg = "Enter more than 6 characters";
        });

      }
      else{
        if(newPasswordTextEditingController.text != confirmNewPasswordTextEditingController.text){
          setState((){
            newPasswordError = true;
            newPasswordErrorMsg = "Password mismatch";
          });
        }
        else{
          setState(() {
            isValidNewPassword = true;
          });
        }
      }
    }
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

  showAlertDialog(BuildContext context) {

    AlertDialog alert = AlertDialog(
      content: Text("Password changed Successfully",style: TextStyle(color: Colors.lightGreen.shade900,fontWeight: FontWeight.bold),),
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
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
        leading: IconButton(onPressed: (){
          Navigator.pushReplacement(context,MaterialPageRoute(
            builder: (context) => const ControlScreen(),
          ));
        }, icon:const Icon(Icons.arrow_back_ios_rounded)),
        title: const Text("Change Password", style: TextStyle( fontWeight: FontWeight.bold , fontSize: 20),),
      ),
      backgroundColor: Colors.indigo.shade900,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                TextField(
                  controller: currentPasswordTextEditingController,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  decoration: textFiledInputDecoration("Current Password", currentPasswordError, currentPasswordErrorMsg),
                ),

                const SizedBox(height:30),

                TextField(
                  controller: newPasswordTextEditingController,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  decoration: textFiledInputDecoration("New Password", newPasswordError, newPasswordErrorMsg),
                ),

                const SizedBox(height:30),

                TextField(
                  controller: confirmNewPasswordTextEditingController,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  decoration: textFiledInputDecoration("Confirm New Password", newPasswordError, newPasswordErrorMsg)
                ),

                const SizedBox(height:30),

                Container(
                  alignment: Alignment.centerLeft,
                  child: OutlinedButton(onPressed:(){
                    changePassword();
                  },
                    style:OutlinedButton.styleFrom(
                        backgroundColor: Colors.yellow,
                        minimumSize: const Size(80, 40),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))
                    ),
                    child:const Text('Save', style: TextStyle(fontWeight: FontWeight.bold , color: Colors.white,),),
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
