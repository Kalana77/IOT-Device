import 'package:firebase_auth/firebase_auth.dart';
import 'package:iot_app/helper/constants.dart';

import '../model/firebaseuser.dart';

class AuthMethods{

  final FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseUser? _firebaseUserFromFirebase(User user){
    return user !=null ? FirebaseUser(userId: user.uid):null;
  }

  Future<User?> getCurrentUser() async {
    return await _auth.currentUser;
  }

  Future signUpWithEmailAndPassword(String email,String password)async {
    try{
      UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);

      User? firebaseUser = credential.user;

      return _firebaseUserFromFirebase(firebaseUser!);
    }catch(e){
      print(e.toString());
    }
  }

  Future signInWithEmailAndPassword(String email,String password)async {
    try{
      UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: password);

      User? firebaseUser = credential.user;

      return _firebaseUserFromFirebase(firebaseUser!);
    }catch(e){
      print(e.toString());
    }
  }

  Future gerCredential(String email,String currentPassword) async {
    final user = await getCurrentUser();
    final cred = EmailAuthProvider.credential(email:email, password: currentPassword);
    return await user!.reauthenticateWithCredential(cred);
  }

  Future changePassword(String email,cred, String newPassword) async {
    final user = await getCurrentUser();
    user!.updatePassword(newPassword).then((value) {
    }).catchError((error) {
      print(error);
    });
  }


  Future resetPass(String email)async {
    try{
      return await _auth.sendPasswordResetEmail(email: email);
    }catch(e){
      print(e.toString());
    }
  }

  String getCurrentUid(){
    return _auth.currentUser!.uid;
  }


  signOut()async {

    Constants.myEmail = "";
    Constants.userName = "";
    Constants.myUid = "";

    await _auth.signOut();
  }



}