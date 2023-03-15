import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iot_app/screens/controlscreen.dart';
import 'package:iot_app/screens/signupscreen.dart';
import 'package:iot_app/services/auth.dart';
import 'package:iot_app/services/database.dart';

import '../helper/constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  bool isValidUserName = false;
  bool isValidPassword = false;
  bool userNameError = false;
  bool passwordError = false;
  String userNameErrorMsg = "";
  String passwordErrorMsg = "";


  AuthMethods authMethods = AuthMethods();
  DataBaseMethod dataBaseMethod = DataBaseMethod();
  TextEditingController userNameTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  QuerySnapshot<Map<String, dynamic>>? userInfo;


  signInAccount(){

    validUserName();
    validPassword();

    if(isValidUserName && isValidPassword){
      dataBaseMethod.getUserByUsername(userNameTextEditingController.text).then((value){
        setState((){
          userInfo = value;
        });
        if(value.docs.isNotEmpty){
          authMethods.signInWithEmailAndPassword(userInfo!.docs[0]["email"], passwordTextEditingController.text).then((value){
            if(value != null){
              setState(() {
                Constants.userName = userNameTextEditingController.text;
                Constants.myEmail = userInfo!.docs[0]["email"];
                Constants.myUid = authMethods.getCurrentUid();
              });

              Navigator.pushReplacement(context,MaterialPageRoute(
                builder: (context) => const ControlScreen(),
              ));

            }else{
              setState((){
                userNameError = true;
                userNameErrorMsg = "invalid username or password";
                passwordError = true;
                passwordErrorMsg = "invalid username or password";

              });
            }
          });

        }
        else{
          setState((){
            userNameError = true;
            userNameErrorMsg = "invalid username or password";
            passwordError = true;
            passwordErrorMsg = "invalid username or password";

          });

        }
      });
    }
  }

  validUserName(){

    setState((){
      userNameError = false;
    });

    if(userNameTextEditingController.text.isEmpty){
      setState((){
        userNameError = true;
        userNameErrorMsg = "Please enter name";
      });
    }
    else{
      setState(() {
        isValidUserName = true;
      });
    }
  }

  validPassword(){

    setState((){
      passwordError = false;
    });

    if(passwordTextEditingController.text.isEmpty){
      setState((){
        passwordError = true;
        passwordErrorMsg = "Can't be empty";
      });
    }
    else{
      setState(() {
        isValidPassword = true;
      });
    }
  }

  InputDecoration textFiledInputDecoration(text,bool isError, String errorMsg){
    return InputDecoration(
      errorText: isError ? errorMsg:null,
      hintText: text,
      //border:OutlineInputBorder(borderSide: BorderSide(color:Colors.white) ,borderRadius:BorderRadius.circular(50)),
      hintStyle: const TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold),
      focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color:Colors.yellow,width: 2) ,borderRadius:BorderRadius.circular(50)),
      enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color:Colors.grey , width: 2) ,borderRadius:BorderRadius.circular(50)),
      errorBorder: OutlineInputBorder(borderSide: const BorderSide(color:Colors.red , width: 2) ,borderRadius:BorderRadius.circular(50)),
      focusedErrorBorder: OutlineInputBorder(borderSide: const BorderSide(color:Colors.red , width: 2) ,borderRadius:BorderRadius.circular(50)),
      //alignLabelWithHint:
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/img1.png"),
                fit:BoxFit.fill,
              ),
            ),
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            //mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.only(left: 20),
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:[
                    const Text('Welcome to',
                      style: TextStyle(
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                    )),

                    const Text('Power',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 50,
                        ),
                    ),
                    RichText(
                        text: TextSpan(
                          style: GoogleFonts.merriweather(textStyle: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 50,
                          )),
                          children: const [
                            TextSpan(text: "Dir"),
                            TextSpan(text: "e", style:TextStyle(color: Colors.yellow)),
                            TextSpan(text: "ctor")
                          ]
                        )

                    ),

                  ],
                ),
              ),

              const SizedBox(height: 50,),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  children: [

                    TextField(
                      controller: userNameTextEditingController,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      decoration: textFiledInputDecoration("Username", userNameError , userNameErrorMsg),
                    ),

                    const SizedBox(height: 20,),

                    TextField(
                      controller: passwordTextEditingController,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      decoration: textFiledInputDecoration("Password", passwordError, passwordErrorMsg),
                    ),

                    const SizedBox(height: 20,),

                    OutlinedButton(onPressed:(){

                      signInAccount();

                    },
                      style:OutlinedButton.styleFrom(
                        backgroundColor: Colors.yellow,
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))
                      ),
                      child:const Text('Login', style: TextStyle(fontWeight: FontWeight.bold , color: Colors.white,fontSize: 20),),
                    ),


                    const SizedBox(height: 15,),

                    const Text('Forgotten a Password',
                        style: TextStyle(
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.bold,
                          //fontSize: 40,
                        )),

                    const SizedBox(height: 15,),

                    RichText(
                        text: TextSpan(
                            style: GoogleFonts.merriweather(textStyle: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            )),
                            children:[
                              TextSpan(text: "Don't have an account?  "),
                              TextSpan(
                                text: "Sign up", style:TextStyle(color: Colors.yellow),
                                recognizer: TapGestureRecognizer()..onTap = (){
                                  Navigator.pushReplacement(context,MaterialPageRoute(
                                    builder: (context) => const SignupScreen(),
                                  ));
                                }),
                            ]
                        )

                    ),

                    const SizedBox(height: 80,),

                  ],),

              ),

            ],
          ),
        ],
      ),
    );
  }
}
