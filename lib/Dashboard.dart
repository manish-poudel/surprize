import 'package:Surprize/FirebaseMessaging/PushNotification/PushNotification.dart';
import 'package:Surprize/Helper/AppHelper.dart';
import 'package:Surprize/Memory/UserMemory.dart';
import 'package:Surprize/Models/Player.dart';
import 'package:Surprize/PlayerDashboard.dart';
import 'package:Surprize/UserProfileManagement/UserProfile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';


class Dashboard{

  BuildContext context;

  Dashboard(this.context);

  bool retry = false;
  /// Go to page
  nav(){
    try {
      if(retry)
        return;

      UserProfile().getProfile(UserMemory().firebaseUser.uid).then((
          DocumentSnapshot documentSnapshot) {
        UserMemory().savePlayer(Player.fromMap(documentSnapshot.data));
        PushNotification().configure(context);
        PushNotification().saveToken(UserMemory()
            .getPlayer()
            .membershipId);
        try {
          AppHelper.cupertinoRouteWithPushReplacement(
              context, PlayerDashboard());
        }
        catch (error) {
          AppHelper.cupertinoRouteWithPushReplacement(
              context, PlayerDashboard());
        }
      });
    }
    catch(error){
      nav();
      retry = true;
    }
  }

}