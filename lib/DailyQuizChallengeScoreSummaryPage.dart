import 'package:flutter/material.dart';
import 'package:surprize/Leaderboard/LeaderboardManager.dart';
import 'package:surprize/Resources/ImageResources.dart';

import 'Leaderboard/ScoreSystem.dart';

class DailyQuizChallengeScoreSummaryPage extends StatefulWidget {
  final int _totalScore;

  DailyQuizChallengeScoreSummaryPage(this._totalScore);

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
                Padding(
                  padding: const EdgeInsets.only(top: 64.0),
                  child: button("Share and earn point", Icons.share),
                ),
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
              fontSize: 35, fontFamily: 'Roboto', color: Colors.white)),
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
                      fontFamily: 'Roboto',
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
                    color: Colors.white, fontSize: 18.0, fontFamily: 'Roboto')),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Text(score,
              style: TextStyle(
                  color: Colors.white, fontSize: 18.0, fontFamily: 'Roboto')),
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
                  color: Colors.white, fontSize: 90, fontFamily: 'Roboto'),
            ),
          ),
        ),
      ),
    );
  }

  Widget button(String text, IconData icon) {
    return FlatButton(
      child: Container(
        decoration: new BoxDecoration(
            color: Colors.purple[800],
            border: new Border.all(color: Colors.white, width: 0.5),
            borderRadius: new BorderRadius.all(Radius.circular(24.0))),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Expanded(
                  child: Text(text,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'Roboto'))),
              Icon(icon, color: Colors.white)
            ],
          ),
        ),
      ),
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
                            color: Colors.white, fontSize: 18, fontFamily: 'Roboto')),
                  )),
              Text(score,
                  style: TextStyle(
                      color: Colors.white, fontSize: 18, fontFamily: 'Roboto'))
            ],
          ),
        ));
  }

  @override
  void initState() {
    super.initState();
    LeaderboardManager().saveScoreAfterGamePlay(widget._totalScore,

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

}
