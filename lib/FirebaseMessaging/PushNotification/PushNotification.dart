
import 'package:Surprize/FirebaseMessaging/PushNotification/LocalNotification.dart';
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

  getDeviceTokenId(){
    _firebaseMessaging.getToken().then((token){
      print(token);
    });
  }
}