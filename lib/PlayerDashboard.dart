import 'package:Surprize/CustomWidgets/CustomQuizLettersWidget.dart';
import 'package:Surprize/Models/QuizLetter/QuizLetter.dart';
import 'package:Surprize/Models/QuizLetter/QuizLetterDisplay.dart';
import 'package:Surprize/QuizLettersPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Surprize/DailyQuizChallengePage.dart';
import 'package:Surprize/SurprizeNavigationDrawerWidget.dart';
import 'CustomUpcomingEventsWidget.dart';
import 'CustomWidgets/CustomNewsCardWidget.dart';
import 'CustomWidgets/CustomRoundedEdgeButton.dart';
import 'DailyQuizChallengeGamePlayPage.dart';
import 'Helper/AppHelper.dart';
import 'Models/DailyQuizChallenge/CurrentQuizState.dart';
import 'Models/DailyQuizChallenge/QuizState.dart';
import 'Resources/FirestoreResources.dart';


//// MAKE SURE YOU REMOVE DEPENDENCIES IN GRADLE FOR EG, FIRESTORE... AND CHECK IF IT WORK.. thEY MAY BE NOT BE REQUIRED!!!!!
class PlayerDashboard extends StatefulWidget {

  PlayerDashboard();

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return PlayerDashboardState();
  }
}

class PlayerDashboardState extends State<PlayerDashboard>
    with SingleTickerProviderStateMixin {

  DailyQuizChallengePage _dailyQuizChallengePage;
  AnimationController _animationController;

  bool _showDailyQuizChallengeWidget = false;

  QuizLetterDisplay quizLetterDisplay;
  CustomQuizLettersWidget customQuizLettersWidget;


  @override
  void initState() {
    super.initState();
    _animationController = new AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animationController.repeat();
    _dailyQuizChallengePage = new DailyQuizChallengePage(context);
    isDailyQuizAvailable();
    getQuizLetters();
  }


  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// Is daily quiz available
  isDailyQuizAvailable() async {

    _dailyQuizChallengePage.listenForDailyQuizGameOn((QuizState quizState){
      setState(() {
        _showDailyQuizChallengeWidget = (quizState.quizState != CurrentQuizState.QUIZ_IS_OFF);
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(primaryColor: Colors.purple[800]),
        home: Scaffold(
            appBar: AppBar(title: Text("Home", style: TextStyle(fontFamily: 'Raleway'))),
            drawer: SurprizeNavigationDrawerWidget(context),
            body: dashboardBody()));
  }

  /// Dashboard body
  Widget dashboardBody()  {
    return SingleChildScrollView(
      child: Center(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          //  profileInformationHolder(),
          AppHelper.appSmallHeader("Upcoming events"),
          Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: CustomUpcomingEventsWidget()),
          dailyQuizOnWidget(),
          AppHelper.appHeaderDivider(),
          quizLetterDisplay != null?GestureDetector(child: quizLettersSmallContainer(), onTap: () => AppHelper.cupertinoRoute(context,QuizLettersPage(quizLetterDisplay.quizLetter.quizLettersId))
          ):Visibility(visible: false,child: Container()),
          AppHelper.appHeaderDivider(),
          AppHelper.appSmallHeader("Hear from us"),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: CustomNewsCardWidget(),
          ),
        ],
      )),
    );
  }

  /// Daily quiz on widget
  Widget dailyQuizOnWidget(){
    return AnimatedOpacity(
      opacity: _showDailyQuizChallengeWidget ? 1.0 : 0.0,
      duration: Duration(seconds: 1),
      child: Column(children: <Widget>[
        Visibility(visible: _showDailyQuizChallengeWidget , child: AppHelper.appHeaderDivider()),
        Visibility(visible: _showDailyQuizChallengeWidget, child: playDailyQuizChallenge(context)),
      ]),
    );
  }


  /// Play quiz challenge short cut button widget
  Widget playDailyQuizChallenge(context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        children: <Widget>[
          FadeTransition(
            opacity: _animationController,
            child: Text(
              "Game is on !!!",
              style: TextStyle(
                  fontFamily: 'Raleway',
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                  color: Colors.purple),
            ),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            CustomRoundedEdgeButton(
                onClicked: () => Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) =>
                            DailyQuizChallengeGamePlayPage())),
                color: Colors.purple[800],
                text: "Play Daily Quiz Challenge")
          ]),
        ],
      ),
    );
  }

  /// Quiz letter small container
  Widget quizLettersSmallContainer(){

    return Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top:8.0, left: 16, bottom: 4),
              child: Text("Quiz Letters", style: TextStyle(fontFamily: 'Raleway', color: Colors.black, fontWeight: FontWeight.w500)),
            ),
            CustomQuizLettersWidget(quizLetterDisplay),
          ],
        ));
  }

  /// Quiz letters
  void getQuizLetters() {
    Firestore.instance.collection(FirestoreResources.collectionQuizLetterName).limit(1).orderBy(FirestoreResources.fieldQuizLetterAddedDate, descending: true).
    getDocuments().then((docSnapshot){
      setState(() {
        quizLetterDisplay = QuizLetterDisplay(false,QuizLetter.fromMap(docSnapshot.documents[0].data), true, false);
        customQuizLettersWidget = CustomQuizLettersWidget(quizLetterDisplay);
      });
    });
  }

}
