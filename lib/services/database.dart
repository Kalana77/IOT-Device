import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:iot_app/helper/constants.dart';
import 'package:iot_app/screens/controlscreen.dart';
import 'auth.dart';
import 'package:flutter/material.dart';


class DataBaseMethod{

  FirebaseDatabase database = FirebaseDatabase.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  AuthMethods authMethods = AuthMethods();


  Future<QuerySnapshot<Map<String, dynamic>>> getUserByUsername(String userName) async{
    return await FirebaseFirestore.instance.collection("users").where("userName",isEqualTo: userName).get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getUserByEmail(String email) async{
    return await FirebaseFirestore.instance.collection("users").where("email",isEqualTo: email).get();
  }

  createUser(userInfo, String uid) async{
    await FirebaseFirestore.instance.collection("users").doc(uid).set(userInfo);
  }

  addSwitches(devicesList,devicesName, String uid) async{
    await FirebaseFirestore.instance.collection("users").doc(uid).update({"devices name":devicesName,"devices List" : devicesList});
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getDevicesInfo(String uid) async {
    return await FirebaseFirestore.instance.collection("users").doc(uid).get();
  }

  addDevices(devicesList, String uid) async {
    await database.ref("users/$uid/devices").set(devicesList);
  }

  updateDevicesStatus(int status, String deviceId, String uid){
    database.ref("users/$uid/devices").update({deviceId:status});
  }

  devicesStatusListener(buttonStatus ,String uid) async {
    await database.ref("users/$uid/devices").onValue.listen((event) {
      final data = event.snapshot.value;
      buttonStatus(data);
    });
  }
  Future<DatabaseEvent> getDevicesStatus(String uid) async {
    return await database.ref("users/$uid/devices").once();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getDevicesOnce(String uid) async {
    return await firestore.collection("users").doc(uid).get();
  }

   Future<Stream<DocumentSnapshot<Map<String, dynamic>>>> getDevices(String uid) async {
    return firestore.collection("users").doc(uid).snapshots();
  }



}


