import 'package:Surprize/FirebaseMessaging/PushNotification/PushNotification.dart';
import 'package:Surprize/Helper/AppHelper.dart';
import 'package:Surprize/Memory/UserMemory.dart';
import 'package:Surprize/Models/Player.dart';
import 'package:Surprize/PlayerDashboard.dart';
import 'package:Surprize/UserProfileManagement/UserProfile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'ProfileSetUpPage.dart';

class Dashboard{

  FirebaseUser _firebaseUser;
  BuildContext context;

  Dashboard(this.context,this._firebaseUser);

  /// Go to page
  nav(){
    UserProfile().getProfile(_firebaseUser.uid).then((DocumentSnapshot documentSnapshot) {
      if(documentSnapshot.data != null) {
        UserMemory().savePlayer(Player.fromMap(documentSnapshot.data));
        PushNotification().configure(context);
        PushNotification().saveToken(UserMemory().getPlayer().membershipId);
        try {
          Navigator.of(context).pop();
        }
        catch(error){
          AppHelper.cupertinoRouteWithPushReplacement(context, PlayerDashboard());
        }
        AppHelper.cupertinoRouteWithPushReplacement(context, PlayerDashboard());
      }
      else{
        try {
          Navigator.of(context).pop();
        }
        catch(error){
          AppHelper.cupertinoRouteWithPushReplacement(context, ProfileSetUpPage(_firebaseUser));
        }
        AppHelper.cupertinoRouteWithPushReplacement(context, ProfileSetUpPage(_firebaseUser));
      }
    });
  }

}