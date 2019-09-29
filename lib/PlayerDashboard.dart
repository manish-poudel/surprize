
import 'package:Surprize/CustomWidgets/CustomFooterWidget.dart';
import 'package:Surprize/CustomWidgets/CustomNoticeViewWidget.dart';
import 'package:Surprize/CustomWidgets/CustomQuizLettersWidget.dart';
import 'package:Surprize/Memory/UserMemory.dart';
import 'package:Surprize/Models/Notice.dart';
import 'package:Surprize/Models/QuizLetter/QuizLetter.dart';
import 'package:Surprize/Models/QuizLetter/QuizLetterDisplay.dart';
import 'package:Surprize/QuizLettersPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Surprize/DailyQuizChallengePage.dart';
import 'package:Surprize/SurprizeNavigationDrawerWidget.dart';
import 'CustomUpcomingEventsWidget.dart';
import 'CustomWidgets/CustomRoundedEdgeButton.dart';
import 'DailyQuizChallengeGamePlayPage.dart';
import 'Helper/AppHelper.dart';
import 'package:Surprize/Models/DailyQuizChallenge/enums/CurrentQuizState.dart';
import 'package:Surprize/Models/DailyQuizChallenge/enums/QuizState.dart';
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
  Notice notice;

  CustomQuizLettersWidget customQuizLettersWidget;

  @override
  void initState() {
    super.initState();
    _animationController =
        new AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animationController.repeat();
    _dailyQuizChallengePage = new DailyQuizChallengePage(context);
    isDailyQuizAvailable();
    getQuizLetters();
    getLatestNotice();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// Is daily quiz available
  isDailyQuizAvailable() async {
    _dailyQuizChallengePage.listenForDailyQuizGameOn((QuizState quizState) {
      setState(() {
        _showDailyQuizChallengeWidget =
            (quizState.quizState != CurrentQuizState.QUIZ_IS_OFF);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primaryColor: Colors.purple[800]),
        home: Scaffold(
            appBar: AppBar(
                title: Text("Home", style: TextStyle(fontFamily: 'Raleway'))),
            drawer: SurprizeNavigationDrawerWidget(context),
            body: Container(
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  dashboardBody(),
                ],
              )),
            )));
  }

  /// Dashboard body
  Widget dashboardBody() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          //  profileInformationHolder(),
          quizLetterDisplay != null
              ? GestureDetector(
              child: quizLettersSmallContainer(),
              onTap: () => AppHelper.cupertinoRoute(
                  context,
                  QuizLettersPage(
                      quizLetterDisplay.quizLetter.quizLettersId)))
              : Visibility(visible: false, child: Container()),

          Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: CustomUpcomingEventsWidget()),
          Visibility(visible: _showDailyQuizChallengeWidget,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: dailyQuizOnWidget(),
            ),
          ),
          //Visibility(visible:quizLetterDisplay != null,child: AppHelper.appHeaderDivider()),
          noticeView(),
          // Visibility(visible:notice != null,child: AppHelper.appHeaderDivider()),

        ],
      ),
    );
  }

  Widget footer() {
    return CustomFooterWidget();
  }

  Widget noticeView() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: new BoxDecoration(
            border: new Border.all(color: Colors.grey[100], width:4),
            borderRadius: new BorderRadius.all(Radius.circular(6.0))
        ),
        child: Visibility(
            visible: notice != null,
            child: notice != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Card(child: CustomNoticeViewWidget(notice)),
                    ],
                  )
                : Container()),
      ),
    );
  }

  /// Daily quiz on widget
  Widget dailyQuizOnWidget() {
    return AnimatedOpacity(
      opacity: _showDailyQuizChallengeWidget ? 1.0 : 0.0,
      duration: Duration(seconds: 1),
      child: Column(children: <Widget>[
        Visibility(
            visible: _showDailyQuizChallengeWidget,
            child: playDailyQuizChallenge(context)),
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
  Widget quizLettersSmallContainer() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: Card(
        color: Colors.purple[600],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: CustomQuizLettersWidget(quizLetterDisplay),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left:12.0),
                  child: Text("Quiz letters of a day!",
                      style: TextStyle(
                          fontFamily: 'Raleway',
                          color: Colors.white,

                          fontWeight: FontWeight.w500)),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: GestureDetector(
                      onTap: () => AppHelper.cupertinoRoute(context, QuizLettersPage(quizLetterDisplay.displayId)),
                      child: Container(
                        padding: EdgeInsets.all(4.0),
                        decoration: new BoxDecoration(
                            border: new Border.all(color: Colors.white, width: 1),
                            borderRadius: new BorderRadius.all(Radius.circular(40.0))
                        ),
                        child: Text("Play more", style:TextStyle(
                            fontFamily: 'Raleway',
                            color: Colors.white,
                            fontWeight: FontWeight.w500)),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  /// Quiz letters
  void getQuizLetters() {
    Firestore.instance
        .collection(FirestoreResources.collectionQuizLetterName)
        .limit(1)
        .orderBy(FirestoreResources.fieldQuizLetterAddedDate, descending: true)
        .getDocuments()
        .then((docSnapshot) {
      setState(() {
        QuizLetter quizLetter =
            QuizLetter.fromMap(docSnapshot.documents[0].data);
        quizLetterDisplay = QuizLetterDisplay(
            quizLetter.quizLettersId + UserMemory().getPlayer().membershipId,
            false,
            quizLetter,
            false,
            false);
        customQuizLettersWidget = CustomQuizLettersWidget(quizLetterDisplay);
      });
    });
  }

  /// Quiz letters
  void getLatestNotice() {
    Firestore.instance
        .collection(FirestoreResources.collectionNotice)
        .limit(1)
        .orderBy(FirestoreResources.fieldNoticeAddedDate, descending: true)
        .getDocuments()
        .then((docSnapshot) {
      setState(() {
        notice = Notice.fromMap(docSnapshot.documents[0].data);
      });
    });
  }
}
