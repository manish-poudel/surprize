import 'package:Surprize/AppIntroPage.dart';
import 'package:Surprize/AppShare/ShareApp.dart';
import 'package:Surprize/Resources/FirestoreResources.dart';
import 'package:Surprize/SurprizeGamePlayPage.dart';

import 'package:Surprize/FeedbackPage.dart';

import 'package:Surprize/NoticePage.dart';

import 'package:Surprize/QuizLettersPage.dart';
import 'package:Surprize/SettingPage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Surprize/Helper/AppHelper.dart';
import 'package:Surprize/Memory/UserMemory.dart';

import 'CustomWidgets/CustomNavigationDrawerWidget.dart';
import 'SurprizeChallengePage.dart';
import 'LeaderboardPage.dart';
import 'Models/Player.dart';

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top:32.0,left: 16.0, right: 16.0, bottom: 16.0),
            child: CircleAvatar(radius: 40, backgroundColor: Colors.white, backgroundImage:
            _player.profileImageURL.isEmpty?AssetImage(ImageResources.emptyUserProfilePlaceholderImage):
            CachedNetworkImageProvider( _player.profileImageURL)
            ),
          ),
          Visibility(
            visible: _player.name.isNotEmpty,
            child: Padding(
              padding: _player.email.isNotEmpty?const EdgeInsets.only(left:16.0):const EdgeInsets.only(left:16.0,bottom: 16.0),
              child: Text(_player.name, style: TextStyle(color:  Colors.white, fontFamily: 'Raleway' ,fontSize: 24, fontWeight: FontWeight.w300)),
            ),
          ),
          Visibility(
            visible: _player.email.isNotEmpty,
            child: Padding(
              padding: const EdgeInsets.only(left:16.0, bottom: 16.0),
              child: Text(_player.email, style: TextStyle(color: Colors.white, fontFamily: 'Raleway' ,fontSize: 14, fontWeight: FontWeight.w300)),
            ),
          ),
        ],
      ),
    );
  }

  /// Drawer list
  Widget drawerList() {
    return MediaQuery.removePadding(
     context: _parentContext,
      removeTop: true,
      child: ListView(
        children: <Widget>[
          profileDisplay(),
          drawerButtons(),
          Container(color: Colors.white,height: 1),
          AppHelper().socialMediaWidget(_selfContext),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(child: Text("delete"),onTap: (){
              Firestore.instance.collection(FirestoreResources.collectionDailyQuizChallenge).document(FirestoreResources.docChallengeOfToday)
                  .collection(FirestoreResources.docChallengePlayerList).document(UserMemory().getPlayer().membershipId).delete();
            }),
          ),
          Container(height: 52)
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
            drawerButtonNavigationWithPadding(QuizLettersPage(null),Icon(Icons.event_note, color: Colors.purple[700]), "Quiz Letters"),
            drawerButtonNavigationWithPadding(LeaderboardPage(_player.membershipId), Icon(Icons.score, color: Colors.purple[700]),"Leaderboard"),
            drawerButtonNavigationWithPadding(NoticePage(),Icon(Icons.new_releases, color: Colors.purple[700]), "Notice"),
            drawerButtonNavigationWithPadding(FeedbackPage(),Icon(Icons.feedback, color: Colors.purple[700]), "Feedback"),
            drawerButtonNavigationWithPadding(AppIntroPage("HELP"),Icon(Icons.live_help, color: Colors.purple[700]), "Help"),
            drawerButtonNavigationWithPadding(SurprizeGamePlayPage(),Icon(Icons.live_help, color: Colors.purple[700]), "Test play"),
            AppHelper().flatButtonWithRoute(Icon(Icons.share, color: Colors.purple[700]), () => ShareApp().shareAppToMedia(), "Share"),
            Padding(
              padding: const EdgeInsets.only(bottom:8.0),
              child: drawerButtonNavigationWithPadding(SettingPage(),Icon(Icons.settings, color: Colors.purple[700]), "Settings"),
            ),
            // drawerButtonNavigationWithPadding(DailyQuizChallengeScoreSummaryPage(0),Icon(Icons.people, color: Colors.purple), "Summary page"),
          ]),
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
        child:  AppHelper().flatButtonWithRoute(Icon(Icons.games, color: Colors.purple[800]),() => SurprizeChallengePage(_selfContext).openPage(), "Surprize Challenge")
    );
  }
}