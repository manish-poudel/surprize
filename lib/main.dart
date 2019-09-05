

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:surprize/DailyQuizChallengeGamePlayPage.dart';
import 'package:surprize/DailyQuizChallengeScoreSummaryPage.dart';
import 'package:surprize/ProfilePage.dart';
import 'package:surprize/SplashScreen.dart';
import 'package:surprize/DailyQuizChallengeNotAvailablePage.dart';
import 'package:surprize/PlayerDashboard.dart';
import 'LoginPage.dart';
import 'Memory/UserMemory.dart';
import 'Models/Player.dart';
import 'RegistrationPage.dart';
import 'UserProfileManagement/UserProfile.dart';

void main() => runApp(EntryPoint());

class EntryPoint extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
      home:handleCurrentScreen(),
      routes: <String, WidgetBuilder>{
        '/loginPage': (BuildContext context) => LoginPage(),
        '/registrationPage': (BuildContext context) => RegistrationPage(),
        '/dailyQuizChallengeNotAvailablePage': (BuildContext context) => DailyQuizChallengeNotAvailablePage(),
        '/dailyQuizChallengeGamePlayPage': (BuildContext context) => DailyQuizChallengeGamePlayPage(),
        '/dailyQuizChallengeScoreSummaryPage': (BuildContext context) => DailyQuizChallengeScoreSummaryPage(0),
        '/playerProfilePage': (BuildContext context) => ProfilePage()
      },
    );
  }

  Widget handleCurrentScreen(){
    return Container(
        height : 0.0,
        width: 0.0,
        child:StreamBuilder(
            stream: FirebaseAuth.instance.onAuthStateChanged,
            builder: (BuildContext context, snapshot){
              if(snapshot.connectionState == ConnectionState.waiting) {
                return SplashScreen();
              }
              else{
                if(snapshot.hasData){
                  UserProfile().getProfile(snapshot.data.uid).then((DocumentSnapshot documentSnapshot) {
                    UserMemory().savePlayer(Player.fromMap(documentSnapshot.data));
                    Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context) =>
                                PlayerDashboard()));
                  });
                  return SplashScreen();
                }
                else {
                  return new LoginPage();
                }
              }
            })
    );
  }

}