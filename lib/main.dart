import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:surprize/DailyQuizChallengeGamePlayPage.dart';
import 'package:surprize/DailyQuizChallengeScoreSummaryPage.dart';
import 'package:surprize/ProfilePage.dart';
import 'package:surprize/SplashScreen.dart';
import 'package:surprize/DailyQuizChallengeNotAvailablePage.dart';
import 'package:surprize/PlayerDashboard.dart';
import 'LoginPage.dart';
import 'RegistrationPage.dart';

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
        '/playerProfilePage': (BuildContext context) => ProfilePage(null)
      },
    );
  }

  Widget handleCurrentScreen(){
    return new Container(
        height : 0.0,
        width: 0.0,
        child:StreamBuilder(
            stream: FirebaseAuth.instance.onAuthStateChanged,
            builder: (BuildContext context, snapshot){
              if(snapshot.connectionState == ConnectionState.waiting){
               return SplashScreen();
              }
              else{
                if(snapshot.hasData){
                  return PlayerDashboard(snapshot.data);
                }
                else {
                  return new LoginPage();
                }
              }
            })
    );
  }

}