import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:surprize/Helper/AppHelper.dart';

import 'CustomWidgets/CustomNavigationDrawerWidget.dart';
import 'DailyQuizChallengeGamePlayPage.dart';
import 'DailyQuizChallengeNotAvailablePage.dart';
import 'DailyQuizChallengePage.dart';
import 'DailyQuizChallengeScoreSummaryPage.dart';
import 'LeaderboardPage.dart';
import 'NewsReadingPage.dart';
import 'ProfilePage.dart';


class SurprizeNavigationDrawerWidget extends StatelessWidget{

  BuildContext _parentContext;
  String _uid;

  BuildContext _selfContext;

  SurprizeNavigationDrawerWidget(this._uid, this._parentContext);

  @override
  Widget build(BuildContext context) {
    this._selfContext = context;
    return CustomNavigationDrawerWidget(drawerContent());
  }

  /// Drawer content
  Widget drawerContent(){
    return Container(
      decoration: BoxDecoration(color: Colors.white),
        child:  drawerList(),
    );
  }

  /// Profile display widget
  Widget profileDisplay(){
    return Container(
      decoration: BoxDecoration(color: Colors.purple[800]),
      height:160,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
         Padding(
           padding: const EdgeInsets.all(16.0),
           child: CircleAvatar(radius: 40, backgroundColor: Colors.white, backgroundImage: NetworkImage('http://lorempixel.com/400/200/')),
         ),
          Padding(
            padding: const EdgeInsets.only(left:16.0),
            child: Text("Manish poudel", style: TextStyle(color:  Colors.white, fontFamily: 'Roboto' ,fontSize: 24, fontWeight: FontWeight.w300)),
          ),
          Padding(
            padding: const EdgeInsets.only(left:16.0),
            child: Text("mns6313@gmail.com", style: TextStyle(color: Colors.white, fontFamily: 'Roboto' ,fontSize: 14, fontWeight: FontWeight.w300)),
          ),
        ],
      ),
    );
  }

  /// Drawer list
  Widget drawerList() {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: ListView(
        children: <Widget>[
          profileDisplay(),

          drawerButtons(),
          drawerFooter()
        ],
      ),
    );
  }

  /// Drawer button list
  Widget drawerButtons(){
    return Container(
      decoration: BoxDecoration(color: Colors.grey[100]),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
        drawerButtonNavigation(DailyQuizChallengeNotAvailablePage(), Icon(Icons.people, color: Colors.purple),"No quiz"),
        drawerButtonNavigationWithPadding(DailyQuizChallengeGamePlayPage(),Icon(Icons.people, color: Colors.purple), "Quiz available"),
        goToGamePlay(),
        drawerButtonNavigationWithPadding(ProfilePage(_uid),Icon(Icons.person, color: Colors.purple), "Profile"), drawerButtonNavigationWithPadding(NewsReadingPage(),Icon(Icons.assignment, color: Colors.purple), "News"),
        drawerButtonNavigationWithPadding(LeaderboardPage(_uid), Icon(Icons.score, color: Colors.purple),"Leaderboard"),
        drawerButtonNavigationWithPadding(DailyQuizChallengeScoreSummaryPage(0),Icon(Icons.people, color: Colors.purple), "Summary page"),
        logOutButton()
      ]),
    );
  }

  /// Footer widget
  Widget drawerFooter(){
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          Text("Entertained by silicon guys", style: TextStyle(color:  Colors.black, fontFamily: 'Roboto' ,fontSize: 18, fontWeight: FontWeight.w300)),
          Text("siliconguy123@gmail.com", style: TextStyle(color:  Colors.black, fontFamily: 'Roboto' ,fontSize: 12, fontWeight: FontWeight.w300)),
        ],
      ),
    );
  }
  /// Drawer navigation with no padding
  Widget drawerButtonNavigation(var navTo, Icon icon,  String buttonName){
   return AppHelper().flatButtonWithRoute(icon,
            () => Navigator.push(
            _selfContext,
            MaterialPageRoute(
                builder: (context) => navTo)),
        buttonName);
  }


  /// Drawer Button Navigation With Padding
  Widget drawerButtonNavigationWithPadding(var navTo, Icon icon, String buttonName){
    return Padding(
        padding: const EdgeInsets.only(top: 2.0),
      child: drawerButtonNavigation(navTo, icon, buttonName)
    );
  }

  /// Widget logout button
  Widget logOutButton(){
    return Padding(
        padding: const EdgeInsets.only(top: 2.0),
        child:  AppHelper().flatButtonWithRoute(Icon(Icons.call_missed_outgoing, color: Colors.purple),() => AppHelper().logoutUser(this), "Logout")
    );
  }


  /// Go to quiz game play
  Widget goToGamePlay(){
    return Padding(
        padding: const EdgeInsets.only(top: 2.0),
        child:  AppHelper().flatButtonWithRoute(Icon(Icons.play_arrow, color: Colors.purple),() => DailyQuizChallengePage(_selfContext), "Play Quiz")
    );
  }
}