import 'package:Surprize/FirebaseMessaging/PushNotification/PushNotification.dart';
import 'package:Surprize/Firestore/FirestoreOperations.dart';
import 'package:Surprize/Helper/AppHelper.dart';
import 'package:Surprize/Memory/UserMemory.dart';
import 'package:Surprize/Models/Player.dart';
import 'package:Surprize/PlayerDashboard.dart';
import 'package:Surprize/UserProfileManagement/UserProfile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'Resources/FirestoreResources.dart';


class Dashboard{

  BuildContext context;

  Dashboard(this.context);

  /// Go to page
  nav() async {
    try {
      FirebaseUser firebaseUser;
      try{
        firebaseUser = await FirebaseAuth.instance.currentUser();
        firebaseUser.reload();
      }
      catch(error){
        firebaseUser = UserMemory().firebaseUser;
      }

      UserProfile().getProfile(firebaseUser.uid).then((
          DocumentSnapshot documentSnapshot) {

        if(documentSnapshot.exists) {
          Player player = Player.fromMap(documentSnapshot.data);
          player.accountVerified = firebaseUser.isEmailVerified;
          savePlayer(player);
          updateEmailVerification(player);

          try {
            AppHelper.cupertinoRouteWithPushReplacement(
                context, PlayerDashboard());
          }
          catch (error) {
            AppHelper.cupertinoRouteWithPushReplacement(
                context, PlayerDashboard());
          }
        }
        else{
          registerProfileInformation();
        }
      });
    }
    catch(error){
    }
  }

  /// Update email verification
  updateEmailVerification(Player player){
    Firestore.instance.collection(FirestoreResources.userCollectionName).document(player.membershipId)
        .updateData(player.toMap());
  }

  savePlayer(Player player){
    UserMemory().savePlayer(player);
    PushNotification().configure(context);
    PushNotification().saveToken(UserMemory()
        .getPlayer()
        .membershipId);
  }

  /// Register profile information
  registerProfileInformation() async {

    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    // Save user profile information to the database
    Player player = Player(
        user.uid,
        // Player Id
        user.displayName == null|| user.displayName.isEmpty?"Anonymous":user.displayName,
        // Player Name
        "",
        // Player DOB
        "",
        // Player Address
        "",
        // Player country
        "",
        // Player Gender
        user.email == null?"":user.email,
        // Player Email
        user.phoneNumber == null?"":user.phoneNumber,
        DateTime.now(),
        // Player membership date
        user.photoUrl == null?"":user.photoUrl,
        user.isEmailVerified?true:false// Player profile Image URL (To be updated later)
    );

    FirestoreOperations()
        .createData(FirestoreResources.userCollectionName, player.membershipId,
        player.toMap())
        .then((value) {

      savePlayer(player);

      Navigator.of(context).popUntil((route) => route.isFirst);
      AppHelper.cupertinoRouteWithPushReplacement(
          context, PlayerDashboard());

    }).catchError((error) {

    });
  }


}