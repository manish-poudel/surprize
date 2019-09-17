import 'package:flutter/material.dart';
import 'package:Surprize/DailyQuizChallengeGamePlayPage.dart';
import 'package:Surprize/DailyQuizChallengeScoreSummaryPage.dart';
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
      routes: <String, WidgetBuilder>{
        '/loginPage': (BuildContext context) => LoginPage(),
        '/registrationPage': (BuildContext context) => RegistrationPage(),
        '/dailyQuizChallengeNotAvailablePage': (BuildContext context) => DailyQuizChallengeNotAvailablePage(DateTime.now()),
        '/dailyQuizChallengeGamePlayPage': (BuildContext context) => DailyQuizChallengeGamePlayPage(),
        '/dailyQuizChallengeScoreSummaryPage': (BuildContext context) => DailyQuizChallengeScoreSummaryPage(0, null),
        '/playerProfilePage': (BuildContext context) => ProfilePage()
      },
      home: Scaffold(
        body: SplashScreen(),
      ),
    );
  }
}