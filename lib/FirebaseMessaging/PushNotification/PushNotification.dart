
import 'dart:async';

import 'package:Surprize/FirebaseMessaging/PushNotification/LocalNotification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotification {

  FirebaseMessaging  _firebaseMessaging = FirebaseMessaging();
  static final PushNotification _pushNotification =
  new PushNotification._internal();

  factory PushNotification() {
    return _pushNotification;
  }

  PushNotification._internal();

  void configure(){
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        LocalNotification().initialize();
        var messageList = message.values.toList();
        LocalNotification().showNotification(messageList[0]['title'],messageList[0]['body']);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
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
    String token = await getDeviceTokenId();
    Firestore.instance.collection("/Device token").document(id).setData({
      "Device id":token
    });
  }
}