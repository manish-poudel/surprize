import 'package:Surprize/AppShare/ShareApp.dart';
import 'package:Surprize/DailyQuizChallengeScoreSummaryPage.dart';
import 'package:Surprize/FeedbackPage.dart';
import 'package:Surprize/Models/DailyQuizChallenge/enums/CurrentQuizState.dart';
import 'package:Surprize/Models/DailyQuizChallenge/enums/QuizState.dart';
import 'package:Surprize/NoticePage.dart';
import 'package:Surprize/QuizLettersPage.dart';
import 'package:Surprize/SettingPage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Surprize/Helper/AppHelper.dart';
import 'package:Surprize/Memory/UserMemory.dart';

import 'CustomWidgets/CustomNavigationDrawerWidget.dart';
import 'DailyQuizChallengePage.dart';
import 'LeaderboardPage.dart';
import 'Models/Player.dart';
import 'ProfilePage.dart';
import 'Resources/ImageResources.dart';


class SurprizeNavigationDrawerWidget extends StatelessWidget {

  BuildContext _parentContext;
  Player _player;
  BuildContext _selfContext;

  SurprizeNavigationDrawerWidget(this._parentContext){
    _player = UserMemory().getPlayer();
  }

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
            child: CircleAvatar(radius: 40, backgroundColor: Colors.white, backgroundImage:
            _player.profileImageURL.isEmpty?AssetImage(ImageResources.emptyUserProfilePlaceholderImage):
            CachedNetworkImageProvider( _player.profileImageURL)
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left:16.0),
            child: Text(_player.name, style: TextStyle(color:  Colors.white, fontFamily: 'Raleway' ,fontSize: 24, fontWeight: FontWeight.w300)),
          ),
          Padding(
            padding: const EdgeInsets.only(left:16.0),
            child: Text(_player.email, style: TextStyle(color: Colors.white, fontFamily: 'Raleway' ,fontSize: 14, fontWeight: FontWeight.w300)),
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
          Container(color: Colors.white,height: 1),
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
            goToGamePlay(),
            drawerButtonNavigationWithPadding(QuizLettersPage(null),Icon(Icons.event_note, color: Colors.purple), "Quiz letters"),
            drawerButtonNavigationWithPadding(LeaderboardPage(_player.membershipId), Icon(Icons.score, color: Colors.purple),"Leaderboard"),
            drawerButtonNavigationWithPadding(NoticePage(),Icon(Icons.new_releases, color: Colors.purple), "Notice"),
            drawerButtonNavigationWithPadding(FeedbackPage(),Icon(Icons.feedback, color: Colors.purple), "Feedback"),
            AppHelper().flatButtonWithRoute(Icon(Icons.share, color: Colors.purple), () => ShareApp().shareAppToMedia(), "Share"),
            Padding(
              padding: const EdgeInsets.only(bottom:8.0),
              child: drawerButtonNavigationWithPadding(SettingPage(),Icon(Icons.settings, color: Colors.purple), "Settings"),
            ),

            // drawerButtonNavigationWithPadding(DailyQuizChallengeScoreSummaryPage(0),Icon(Icons.people, color: Colors.purple), "Summary page"),
          ]),
    );
  }

  /// Footer widget
  Widget drawerFooter(){
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text("Entertained by Omek", style: TextStyle(color:  Colors.black, fontFamily: 'Raleway' ,fontSize: 18, fontWeight: FontWeight.w300)),
          Text("copyright@2019", style: TextStyle(color:  Colors.black, fontFamily: 'Raleway' ,fontSize: 12, fontWeight: FontWeight.w300)),
        ],
      ),
    );
  }
  /// Drawer navigation with no padding
  Widget drawerButtonNavigation(var navTo, Icon icon,  String buttonName){
    return AppHelper().flatButtonWithRoute(icon,
            () => Navigator.push(
            _selfContext,
            CupertinoPageRoute(
                builder: (context) => navTo)),
        buttonName);
  }


  /// Drawer Button Navigation With Padding
  Widget drawerButtonNavigationWithPadding(var navTo, Icon icon, String buttonName){
    return Padding(
        padding: const EdgeInsets.only(top: 1.0),
        child: drawerButtonNavigation(navTo, icon, buttonName)
    );
  }


  /// Go to quiz game play
  Widget goToGamePlay(){
    return Padding(
        padding: const EdgeInsets.only(top: 1.0),
        child:  AppHelper().flatButtonWithRoute(Icon(Icons.games, color: Colors.purple),() => DailyQuizChallengePage(_selfContext).openPage(), "Daily quiz challenge")
    );
  }
}