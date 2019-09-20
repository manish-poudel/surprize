import 'dart:io';

import 'package:Surprize/Models/DailyQuizChallenge/enums/QuizState.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Surprize/AppShare/FacebookShare.dart';
import 'package:Surprize/AppShare/ShareApp.dart';
import 'package:Surprize/Leaderboard/LeaderboardManager.dart';
import 'package:Surprize/Resources/ImageResources.dart';

import 'CustomWidgets/CustomProgressbarWidget.dart';
import 'Leaderboard/ScoreSystem.dart';
import 'Models/Activity.dart';
import 'Resources/ChannelResources.dart';
import 'UserProfileManagement/UserProfile.dart';

class DailyQuizChallengeScoreSummaryPage extends StatefulWidget {
  final int _totalScore;

  QuizState quizState;
  DailyQuizChallengeScoreSummaryPage(this._totalScore, this.quizState);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return DailyQuizChallengeScoreSummaryPageState();
  }
}

class DailyQuizChallengeScoreSummaryPageState
    extends State<DailyQuizChallengeScoreSummaryPage> {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: new AssetImage(ImageResources.appBackgroundImage),
                  fit: BoxFit.fill)),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                headingText("Score Summary"),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child:
                  totalScoreHeading((widget._totalScore + ScoreSystem.getScoreFromGamePlay()).toString()),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: scoreTypeHeading(
                      "Correct answers", widget._totalScore.toString()),
                ),
                scoreTypeHeading("Game Play", ScoreSystem.getScoreFromGamePlay().toString()),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: totalScore((widget._totalScore + ScoreSystem.getScoreFromGamePlay()).toString()),
                ),
               Container(
                 child: Column(
                   children: <Widget>[
                     Padding(
                       padding: const EdgeInsets.all(4),
                       child: Container(
                         height: 0.1,
                         color: Colors.white,
                       ),
                     ),
                     Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: <Widget>[
                           Icon(Icons.share, color: Colors.white),
                           Padding(
                             padding: const EdgeInsets.only(left:8.0),
                             child: Text("Share and earn points !",style: TextStyle(color:Colors.white, fontSize: 18,fontFamily: 'Raleway', fontWeight: FontWeight.w500),),
                           ),
                         ],
                       ),
                     ),
                     Padding(
                       padding: const EdgeInsets.only(top: 2.0),
                       child: button("Share with Facebook", Colors.blue ,() => shareWithFacebook()),
                     ),
                     Padding(
                       padding: const EdgeInsets.only(top: 4.0, bottom:8.0),
                       child: button("Share with other apps", Colors.purple[800] ,() => shareWithOtherApp()),
                     ),
                   ],
                 ),
               )
              ],
            ),
          ),
        ),
      ),
    );
  }

  /*
  Heading image text
   */
  Widget headingImage() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Center(
          child: Image.asset(ImageResources.dailyQuizChallengeLogo,
              height: 220, width: 320)),
    );
  }

  /*
  Heading text
   */
  Widget headingText(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 48.0),
      child: Text(text,
          style: TextStyle(
              fontSize: 35, fontFamily: 'Raleway', color: Colors.white)),
    );
  }

  /*
  Widget score summary Text
   */
  Widget scoreSummaryText() {
    return Container(
        width: MediaQuery.of(context).size.width,
        decoration:
        BoxDecoration(color: Colors.purple[900], shape: BoxShape.circle),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
              child: Text("Score Summary",
                  style: TextStyle(
                      fontSize: 35,
                      fontFamily: 'Raleway',
                      color: Colors.white))),
        ));
  }

  /*
  Score type heading
   */
  Widget scoreTypeHeading(String text, String score) {
    return Container(
      width: MediaQuery.of(context).size.width - 32,
      decoration: new BoxDecoration(
          border: new Border.all(color: Colors.white, width: 1),
          borderRadius: new BorderRadius.all(Radius.circular(24.0))),
      child: Row(children: <Widget>[
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(text,
                style: TextStyle(
                    color: Colors.white, fontSize: 18.0, fontFamily: 'Raleway')),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Text(score,
              style: TextStyle(
                  color: Colors.white, fontSize: 18.0, fontFamily: 'Raleway')),
        ),
      ]),
    );
  }

  /*
  total score heading
   */
  Widget totalScoreHeading(String totalScore) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 0.0, bottom: 16),
      child: Center(
        child: Container(
          height: 160,
          width: 160,
          decoration:
          BoxDecoration(color: Colors.purple, shape: BoxShape.circle),
          child: Center(
            child: Text(
              totalScore,
              style: TextStyle(
                  color: Colors.white, fontSize: 90, fontFamily: 'Raleway'),
            ),
          ),
        ),
      ),
    );
  }

  Widget button(String text, Color color, Function onClick) {
    return FlatButton(
      child: Container(
        decoration: new BoxDecoration(
            color: color,
            borderRadius: new BorderRadius.all(Radius.circular(8.0))),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(text,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontFamily: 'Raleway')),
        ),
      ),
      onPressed: onClick,
    );
  }

  Widget totalScore(String score) {
    double width = MediaQuery.of(context).size.width;
    return Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: width - 240),
                    child: Text("Total Score",
                        style: TextStyle(
                            color: Colors.white, fontSize: 18, fontFamily: 'Raleway')),
                  )),
              Text(score,
                  style: TextStyle(
                      color: Colors.white, fontSize: 18, fontFamily: 'Raleway'))
            ],
          ),
        ));
  }


  UserProfile _userProfile;
  @override
  void initState() {
    super.initState();
    _userProfile = UserProfile();
      addRecentActivity(ActivityType.PLAYED_QUIZ, (widget._totalScore + ScoreSystem.getScoreFromGamePlay()).toString());
      updateScoreForGamePlay();
  }

  /// Add recent activity
  void addRecentActivity(ActivityType activityType, String totalScore){
    FirebaseAuth.instance.currentUser().then((user){
      _userProfile.addActivity(user.uid, activityType, totalScore, DateTime.now());
    });
  }

  /// Sharing with other app
  shareWithOtherApp() async {
   String result = await ShareApp().shareAfterGamePlay(ScoreSystem.getSoreFromSharingApp("Others"));
  }


  bool hasAllTimeScoreSaved = false;
  bool hasWeeklyScoreSaved = false;
  Future shareWithFacebook() async {
    try {
      String value = await FacebookShare().shareToFacebookWithScore(widget._totalScore);
      print("Shared value" + value);
      if(value == "APP_SHARED"){
        updateScoreForSharing();
        addRecentActivity(ActivityType.SHARING_APP_TO_FACEBOOK, ScoreSystem.getSoreFromSharingApp('Facebook').toString());
      }
      if(value == "APP_SHARE_CANCELED"){
        Scaffold.of(context).showSnackBar(new SnackBar(
          content: new Text("You've cancelled sharing the post. Sharing post can increase your points."),
        ));
      }
    }
    catch(error){
      print(error.toString());
    }
  }

  /// Update Score for game play
  updateScoreForGamePlay(){
    LeaderboardManager().saveScoreAfterGamePlay(widget._totalScore, widget.quizState.quizId, widget.quizState.quizName,
        /// if all time score is saved
            (value){
          print("ALL TIME SCORE SAVED: " + value.toString());
        },

        /// if weekly score is saved
            (value){
          print("WEEKLY SCORE SAVED: " + value.toString());
        },

        /// if daily quiz winner is saved
            (value){
          print("DAILY QUIZ WINNER SCORE SAVED: " + value.toString());
        });
  }


  /// Update score for sharing
  void updateScoreForSharing(){
    CustomProgressbarWidget customProgressbarWidget = new CustomProgressbarWidget();
    customProgressbarWidget.startProgressBar(context,
        "Thanks for sharing!. \n Updating your score ...", Colors.white, Colors.black);
    try {
      LeaderboardManager().saveScoreAfterSharing((value) {
        hasAllTimeScoreSaved = true;
        stopProgressBar(customProgressbarWidget);

      }, (value) {
        hasWeeklyScoreSaved = true;
        stopProgressBar(customProgressbarWidget);
      });
    }
    catch(error){
      customProgressbarWidget.stopAndEndProgressBar(context);
    }
  }

  /// Stop progressbar
  stopProgressBar(customProgressbarWidget){
    if(hasAllTimeScoreSaved && hasWeeklyScoreSaved)
      customProgressbarWidget.stopAndEndProgressBar(context);
  }

}
