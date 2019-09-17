import 'package:Surprize/NoticePage.dart';
import 'package:Surprize/QuizLettersPage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Surprize/Helper/AppHelper.dart';
import 'package:Surprize/Memory/UserMemory.dart';

import 'CustomWidgets/CustomNavigationDrawerWidget.dart';
import 'DailyQuizChallengeGamePlayPage.dart';
import 'DailyQuizChallengeNotAvailablePage.dart';
import 'DailyQuizChallengePage.dart';
import 'DailyQuizChallengeScoreSummaryPage.dart';
import 'LeaderboardPage.dart';
import 'Models/Player.dart';
import 'NoticeReadingPage.dart';
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
        drawerButtonNavigationWithPadding(ProfilePage(),Icon(Icons.person, color: Colors.purple), "Profile"),
            drawerButtonNavigationWithPadding(NoticePage(),Icon(Icons.new_releases, color: Colors.purple), "Notice"),

       // drawerButtonNavigationWithPadding(DailyQuizChallengeScoreSummaryPage(0),Icon(Icons.people, color: Colors.purple), "Summary page"),
        logOutButton()
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
          Text("Entertained by silicon guys", style: TextStyle(color:  Colors.black, fontFamily: 'Raleway' ,fontSize: 18, fontWeight: FontWeight.w300)),
          Text("siliconguy123@gmail.com", style: TextStyle(color:  Colors.black, fontFamily: 'Raleway' ,fontSize: 12, fontWeight: FontWeight.w300)),
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

  /// Widget logout button
  Widget logOutButton(){
    return Padding(
        padding: const EdgeInsets.only(top: 1.0),
        child:  AppHelper().flatButtonWithRoute(Icon(Icons.call_missed_outgoing, color: Colors.purple),() => AppHelper().logoutUser(_parentContext), "Logout")
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