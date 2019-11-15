import 'package:flutter/material.dart';
import 'package:Surprize/SurprizeGamePlayPage.dart';
import 'package:Surprize/SurprizeSummaryPage.dart';
import 'package:Surprize/ProfilePage.dart';
import 'package:Surprize/SplashScreen.dart';
import 'package:Surprize/DailyQuizChallengeNotAvailablePage.dart';
import 'LoginPage.dart';
import 'RegistrationPage.dart';

void main() => runApp(EntryPoint());

class EntryPoint extends StatelessWidget{
  BuildContext context;
  @override
  Widget build(BuildContext context) {
    this.context = context;
    // TODO: implement build
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        '/loginPage': (BuildContext context) => LoginPage(),
        '/registrationPage': (BuildContext context) => RegistrationPage(),
        '/dailyQuizChallengeNotAvailablePage': (BuildContext context) => DailyQuizChallengeNotAvailablePage(DateTime.now()),
        '/dailyQuizChallengeGamePlayPage': (BuildContext context) => SurprizeGamePlayPage(),
        '/dailyQuizChallengeScoreSummaryPage': (BuildContext context) => DailyQuizChallengeScoreSummaryPage(0, 0, null,null),
        '/playerProfilePage': (BuildContext context) => ProfilePage()
      },
      home: Scaffold(
        body: SplashScreen(),
      ),
    );
  }

}