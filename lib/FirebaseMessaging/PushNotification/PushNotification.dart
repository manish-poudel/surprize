
import 'dart:async';

import 'package:Surprize/FeedbackPage.dart';
import 'package:Surprize/FirebaseMessaging/PushNotification/LocalNotification.dart';
import 'package:Surprize/NoticePage.dart';
import 'package:Surprize/QuizLettersPage.dart';
import 'package:Surprize/SettingPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class PushNotification {

  FirebaseMessaging  _firebaseMessaging = FirebaseMessaging();
  static final PushNotification _pushNotification =
  new PushNotification._internal();

  factory PushNotification() {
    return _pushNotification;
  }

  PushNotification._internal();

  void configure(context){
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        LocalNotification().initialize();
        var messageList = message.values.toList();
        LocalNotification().showNotification(messageList[0]['title'],messageList[0]['body']);

      },
      onLaunch: (Map<String, dynamic> message) async {
        var messageList = message.values.toList();
        handleClickAction(context,messageList[1]["source"]);
      },
      onResume: (Map<String, dynamic> message) async {
        var messageList = message.values.toList();
        handleClickAction(context,messageList[1]["source"]);
      },
    );
  }

  /// Get device token id
  Future<String> getDeviceTokenId() async {
    String token = await _firebaseMessaging.getToken();
    return token;
  }

  /// Save token to database
  saveToken(String id) async {
    print("Save token");
    String token = await getDeviceTokenId();
    if(token != null) {
      Firestore.instance.collection("/Device token").document(id).setData({
        "DeviceId": token
      });
    }
  }

  /// Handle click action
  handleClickAction(context,String source){
   switch(source){
     case "FEEDBACK_REPLY":
       Navigator.push(
           context,
           MaterialPageRoute(
               builder: (BuildContext context) => FeedbackPage()));
       break;

     case "NOTICE":
       Navigator.push(
           context,
           MaterialPageRoute(
               builder: (BuildContext context) => NoticePage()));
       break;

     case "SETTINGS":
       Navigator.push(
           context,
           MaterialPageRoute(
               builder: (BuildContext context) => SettingPage()));
       break;

     case "QUIZ_LETTERS":
       Navigator.push(
           context,
           MaterialPageRoute(
               builder: (BuildContext context) => QuizLettersPage(null)));
       break;

   }}
}