import 'package:Surprize/CustomWidgets/CustomProgressbarWidget.dart';
import 'package:Surprize/CustomWidgets/DailyQuizChallenge/CustomQuizSummaryDisplayWidget.dart';
import 'package:Surprize/GoogleAds/GoogleAdManager.dart';
import 'package:Surprize/Helper/AppHelper.dart';
import 'package:Surprize/Leaderboard/ScoreSystem.dart';
import 'package:Surprize/Memory/UserMemory.dart';
import 'package:Surprize/Models/DailyQuizChallenge/DQCPlay.dart';
import 'package:Surprize/Models/DailyQuizChallenge/enums/QuizState.dart';
import 'package:Surprize/SurveyFrom.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';

import 'package:Surprize/AppShare/ShareApp.dart';
import 'package:Surprize/Leaderboard/LeaderboardManager.dart';
import 'package:Surprize/Resources/ImageResources.dart';

import 'UserProfileManagement/UserProfile.dart';

class DailyQuizChallengeScoreSummaryPage extends StatefulWidget {
  final int _totalScore;
  final int _totalRightAnswer;

  QuizState quizState;
  Map<String, DQCPlay> dqcPlayList;
  DailyQuizChallengeScoreSummaryPage(this._totalRightAnswer, this._totalScore, this.quizState, this.dqcPlayList);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return DailyQuizChallengeScoreSummaryPageState();
  }
}

class DailyQuizChallengeScoreSummaryPageState
    extends State<DailyQuizChallengeScoreSummaryPage> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _surveyFormShown  = false;
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        key: _scaffoldKey,
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: new AssetImage(ImageResources.appBackgroundImage),
                  fit: BoxFit.fill)),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                widget._totalScore == ScoreSystem.getFullSoreFromQuizPlay()?Center(child: winnerDeclare()):
               loserDeclare(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: scoreReport(),
                ),
                Center(child: watchVideoButton()),
                _playedQuizList()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget winnerDeclare(){
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child:Container(
          decoration: BoxDecoration(
              color: Colors.black26,
              border: new Border.all(color: Colors.black26, width: 0),
              shape: BoxShape.circle
          ),
          child:Image.asset(ImageResources.winnerBanner,height: 160, width: 160))
    );
  }

  Widget loserDeclare(){
   return Padding(
     padding: const EdgeInsets.all(48.0),
     child: Text("Sorry! you didn't win this time!", textAlign:TextAlign.center,style: TextStyle(color: Colors.white,
          fontSize: 24,
          fontFamily: 'Raleway')),
   );
  }
  Widget scoreReport(){
    return Card(
      color:Colors.grey[100],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Score report", style: TextStyle(fontFamily: 'Raleway', fontSize:18, fontWeight:FontWeight.w500,color: Colors.black),),
                Padding(
                  padding: const EdgeInsets.only(right:8.0),
                  child: Text("Correct answers: " + (widget._totalScore/4).toInt().toString() + "/5",style: TextStyle(fontFamily: 'Raleway'),),
                )
              ],
            ),
          ),
          Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.only(top:8.0,left: 16.0,bottom: 8.0),
              child: scoreSummary(),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () => shareWithOtherApp(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
              Icon(Icons.share,color: Colors.purple[800]),
              Padding(
                padding: const EdgeInsets.only(left:8.0),
                child: Text("Share", style: TextStyle(fontSize:16,color: Colors.purple[800])),
              ),
                ],
              ),
            ),
          )
          ,
        ],
      ),
    );
  }

  /// Play video ad button
  Widget watchVideoButton(){
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.star,color: Colors.yellow,size: 24),
            Text("View video to get extra 10 points", textAlign: TextAlign.center, style: TextStyle(color: Colors.white,fontFamily: 'Raleway',fontSize: 18,fontWeight: FontWeight.w700)),
          ],
        ),
        FlatButton(color: Colors.green, child: Text("View", style: TextStyle(color: Colors.white,fontFamily: 'Raleway',fontWeight: FontWeight.w600),), onPressed: () => showVideoAd())
      ],
    );
  }
  /// Event display widget
  Widget _playedQuizList() {
    List<DQCPlay> quizList = widget.dqcPlayList.values.toList();

    return Container(
      child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: quizList.length,
          itemBuilder: (BuildContext context, int index) {

            Color cardBackground = Colors.red[100];
            int selectedAnswer = quizList[index].providedAnswer;
           if(quizList[index].dailyQuizChallengeQnA.rightAnswer == selectedAnswer){
           cardBackground = Colors.green[100];
           }
           else if(selectedAnswer == -1){
             cardBackground = Colors.grey[200];
           }
            return Padding(
              padding: const EdgeInsets.only(left:8.0,right: 8.0),
              child: Card(
                color: cardBackground,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: new Border.all(color: Colors.purple, width: 0),
                                shape: BoxShape.circle
                            ),
                            child: Text(quizList[index].dailyQuizChallengeQnA.rightAnswer == selectedAnswer?"4":"0",style: TextStyle(color: Colors.purple))),
                      ),
                      Container(color: Colors.white, height: 1,),
                      CustomQuizSummaryDisplayWidget(quizList[index].dailyQuizChallengeQnA,selectedAnswer),
                    ],
                  )),
            );
          }),
    );
  }

  Widget scoreSummary(){

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        scoreSummaryText("Score from correct answers", widget._totalScore.toString()),
        Padding(
          padding: const EdgeInsets.only(top:4.0),
          child: scoreSummaryText("Score from Game play", 15.toString()),
        ),
        Padding(
          padding: const EdgeInsets.only(top:16.0,left: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("Total",style: TextStyle(color: Colors.purple,fontFamily: 'Raleway', fontSize: 16,fontWeight: FontWeight.w700)),
              Padding(
                padding: const EdgeInsets.only(right:8.0),
                child: Text((15 + widget._totalScore).toString(),style: TextStyle(color: Colors.purple,fontFamily: 'Raleway', fontSize: 16,fontWeight: FontWeight.w700)),
              )
            ],
          ),
        ),
      ],
    );
  }


  Widget scoreSummaryText(String heading, String val){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
                color: Colors.purple,
                boxShadow: [
                  BoxShadow(
                      color:Colors.black12,
                      offset: Offset(1.0, 5.0),
                      blurRadius: 25.0
                  ),
                ],
                border: new Border.all(color: Colors.white54, width: 0),
                borderRadius:  new BorderRadius.all(Radius.circular(16.0))
            ),
            child: Text(heading,style: TextStyle(color: Colors.white,fontFamily: 'Raleway', fontSize:16,fontWeight: FontWeight.w700))),
        Padding(
          padding: const EdgeInsets.only(right:8.0),
          child: Text(val,style: TextStyle(color: Colors.purple,fontFamily: 'Raleway', fontSize: 16,fontWeight: FontWeight.w700)),
        ),
      ],
    );
  }


  UserProfile _userProfile;
  bool rewardedForVideoAd = false;

  showForm(){
    if(!_surveyFormShown) {
      Future.delayed(Duration.zero, () {
        showDialog(context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              _surveyFormShown = true;
              return SurveyForm(_scaffoldKey, widget.quizState.quizName);
            });
      });
    }
  }

  @override
  void initState() {
    super.initState();
       GoogleAdManager().showQuizGameInterstitialAd(0.0, AnchorType.top);
      _userProfile = UserProfile();
      updateScoreForGamePlay();
      UserMemory().gamePlayed = true;
      Future.delayed(Duration(seconds: 3), () => showForm());
  }

  @override
  void dispose(){
    GoogleAdManager().disposeQuizGameInterstitialAd();
    super.dispose();
  }

  bool rewarded = false;
  ///Show video ad
  showVideoAd() async {
    CustomProgressbarWidget customProgressbarWidget = CustomProgressbarWidget();
    customProgressbarWidget.startProgressBar(
        context, "Please wait while we load video ...", Colors.white, Colors.blueGrey);
    MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(childDirected: false);
    RewardedVideoAd.instance.listener =
        (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) async {
      if (event == RewardedVideoAdEvent.rewarded) {
        rewarded = true;
        AppHelper.showSnackBar("Rewarded 10 points", _scaffoldKey);
        LeaderboardManager().saveForAllTimeScore(UserMemory().getPlayer().membershipId, 10, (value){

        });
        LeaderboardManager().saveForWeeklyScore(UserMemory().getPlayer().membershipId,10, (value){

        });
      }
      if(event == RewardedVideoAdEvent.loaded){
        await RewardedVideoAd.instance.show();
        customProgressbarWidget.stopAndEndProgressBar(context);
      }

      if(event == RewardedVideoAdEvent.failedToLoad){
        AppHelper.showSnackBar("Failed to load ad. Try again!", _scaffoldKey);
        customProgressbarWidget.stopAndEndProgressBar(context);
      }

      if(event == RewardedVideoAdEvent.closed){
        if(rewarded){
          AppHelper.showSnackBar("Rewarded 10 points", _scaffoldKey);
          rewarded = false;
        }
        customProgressbarWidget.stopAndEndProgressBar(context);
      }
    };
   await RewardedVideoAd.instance.load(adUnitId: GoogleAdManager.rewardedVideoAdId, targetingInfo: targetingInfo);
  }


  /// Sharing with other app
  shareWithOtherApp() async {
   ShareApp().shareAppToMedia();
  }


  bool hasAllTimeScoreSaved = false;
  bool hasWeeklyScoreSaved = false;

  /// Update Score for game play
  updateScoreForGamePlay(){
    LeaderboardManager().saveScoreAfterGamePlay(widget._totalRightAnswer, widget._totalScore, widget.quizState.quizId, widget.quizState.quizName,
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


  /// Stop progressbar
  stopProgressBar(customProgressbarWidget){
    if(hasAllTimeScoreSaved && hasWeeklyScoreSaved)
      customProgressbarWidget.stopAndEndProgressBar(context);
  }


}
