import 'package:flutter/material.dart';
import 'package:iot_app/helper/constants.dart';
import 'package:iot_app/screens/controlscreen.dart';
import 'package:iot_app/screens/loginscreen.dart';
import 'package:iot_app/services/auth.dart';
import 'package:iot_app/services/database.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  bool isLoading = false;
  bool isValidEmail = false;
  bool isValidUserName = false;
  bool isValidPassword = false;
  bool userNameError = false;
  bool emailError = false;
  bool passwordError = false;
  String userNameErrorMsg = "";
  String emailErrorMsg = "";
  String passwordErrorMsg = "";

  AuthMethods authMethods = AuthMethods();
  DataBaseMethod dataBaseMethod = DataBaseMethod();

  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController userNameTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  TextEditingController confirmPasswordTextEditingController = TextEditingController();


  createAccount(){

      validEmail();
      validUserName();
      validPassword();

      if(isValidEmail && isValidUserName && isValidPassword){

        authMethods.signUpWithEmailAndPassword(emailTextEditingController.text, passwordTextEditingController.text).then((value){
          if(value!=null){

            Map<String,dynamic> userInfoMap = {
              "email": emailTextEditingController.text,
              "userName": userNameTextEditingController.text,
            };
            //dataBaseMethods.uploadUserInfo(authMethods.getCurrentUid(),userInfoMap);

            Constants.myEmail = emailTextEditingController.text;
            Constants.userName = userNameTextEditingController.text;
            Constants.myUid = value.userId;

            /*
         SharedPreferenceFunction.saveUserNameSharedPreference(nameTextEditingController.text);
         SharedPreferenceFunction.saveUserEmailSharedPreference(emailTextEditingController.text);
         SharedPreferenceFunction.saveUIdSharedPreference(authMethods.getCurrentUid());
         SharedPreferenceFunction.saveUserEmailSharedPreference("");

          */

            dataBaseMethod.createUser(userInfoMap, value.userId);


            Navigator.pushReplacement(context,MaterialPageRoute(
              //TODO
                builder:(context) => ControlScreen()
            ));
          }
          else{
            setState(() {
              isLoading = false;
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
      dataBaseMethod.getUserByUsername(userNameTextEditingController.text).then((value){
        if(value.docs.isNotEmpty){
          setState((){
            userNameError = true;
            userNameErrorMsg = "Existing User name";
          });
        }
        else{
          setState(() {
             isValidUserName = true;
          });
        }
      });
    }
  }

  validEmail(){

    setState((){
      emailError = false;
    });

    if(emailTextEditingController.text.isEmpty){
      setState((){
        emailError = true;
        emailErrorMsg = "Please enter email";
      });
    }
    else{
      if(RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(emailTextEditingController.text)){
        dataBaseMethod.getUserByEmail(emailTextEditingController.text).then((value){
          if(value.docs.isNotEmpty){
            setState((){
              emailError = true;
              emailErrorMsg = "Email already registered";
            });
          }
          else{
            setState(() {
              isValidEmail = true;
            });
          }
        });
      }
      else{
        setState((){
          emailError = true;
          emailErrorMsg = "Enter valid email";
        });
      }
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
      if(passwordTextEditingController.text.length< 7){
        setState((){
          passwordError = true;
          passwordErrorMsg = "Enter more than 6 characters";
        });

      }
      else{
        if(passwordTextEditingController.text != confirmPasswordTextEditingController.text){
          setState((){
            passwordError = true;
            passwordErrorMsg = "Password mismatch";
          });
        }
        else{
          setState(() {
            isValidPassword = true;
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
      //resizeToAvoidBottomInset: false,
      appBar: AppBar(
        titleSpacing: 20,
        elevation: 2,
        centerTitle: true,
        backgroundColor: Colors.indigo.shade900,
        leading: IconButton(onPressed: (){
          Navigator.pushReplacement(context,MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ));
        }, icon:const Icon(Icons.arrow_back_ios_rounded)),
        title: const Text("Register", style: TextStyle( fontWeight: FontWeight.bold , fontSize: 20),),
      ),
      backgroundColor: Colors.indigo.shade900,
      body: isLoading? const Center(child: CircularProgressIndicator()):Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(

                  controller: emailTextEditingController,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  decoration: textFiledInputDecoration("email", emailError, emailErrorMsg),
                ),

                const SizedBox(height: 20,),

                TextField(
                  controller: userNameTextEditingController,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  decoration: textFiledInputDecoration("Username", userNameError, userNameErrorMsg),
                ),

                const SizedBox(height: 20,),

                TextField(
                  controller: passwordTextEditingController,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  decoration: textFiledInputDecoration("Password", passwordError, passwordErrorMsg),
                ),

                const SizedBox(height: 20,),

                TextField(
                  controller: confirmPasswordTextEditingController,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  decoration: textFiledInputDecoration("Confirm Password", passwordError, passwordErrorMsg),
                ),

                const SizedBox(height: 20,),

                OutlinedButton(onPressed:(){
                  createAccount();
                },
                  style:OutlinedButton.styleFrom(
                      backgroundColor: Colors.yellow,
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))
                  ),
                  child:const Text('Register', style: TextStyle(fontWeight: FontWeight.bold , color: Colors.white,fontSize: 20),),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
