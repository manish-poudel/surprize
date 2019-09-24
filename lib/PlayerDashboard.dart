import 'package:Surprize/AppShare/FacebookShare.dart';
import 'package:Surprize/AppShare/ShareApp.dart';
import 'package:Surprize/CustomWidgets/CustomFooterWidget.dart';
import 'package:Surprize/CustomWidgets/CustomNoticeViewWidget.dart';
import 'package:Surprize/CustomWidgets/CustomQuizLettersWidget.dart';
import 'package:Surprize/Memory/UserMemory.dart';
import 'package:Surprize/Models/Notice.dart';
import 'package:Surprize/Models/QuizLetter/QuizLetter.dart';
import 'package:Surprize/Models/QuizLetter/QuizLetterDisplay.dart';
import 'package:Surprize/NoticePage.dart';
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
    _animationController = new AnimationController(vsync: this, duration: Duration(seconds: 1));
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
    _dailyQuizChallengePage.listenForDailyQuizGameOn((QuizState quizState){
      setState(() {
        _showDailyQuizChallengeWidget = (quizState.quizState != CurrentQuizState.QUIZ_IS_OFF);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primaryColor: Colors.purple[800]),
        home: Scaffold(
            appBar: AppBar(title: Text("Home", style: TextStyle(fontFamily: 'Raleway'))),
            drawer: SurprizeNavigationDrawerWidget(context),
            body: Container(
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  dashboardBody(),
                  Align(alignment:Alignment.bottomCenter,child: footer()),
                ],
              )),
            )));
  }

  /// Dashboard body
  Widget dashboardBody()  {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          //  profileInformationHolder(),
          AppHelper.appSmallHeader("Upcoming events"),
          Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: CustomUpcomingEventsWidget()),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: dailyQuizOnWidget(),
          ),
          Visibility(visible:quizLetterDisplay != null,child: AppHelper.appHeaderDivider()),
          quizLetterDisplay != null?GestureDetector(child: quizLettersSmallContainer(), onTap: () =>  AppHelper.cupertinoRoute(context,QuizLettersPage(quizLetterDisplay.quizLetter.quizLettersId))
          ):Visibility(visible: false,child: Container()),
          Visibility(visible:notice != null,child: AppHelper.appHeaderDivider()),
          noticeView(),
          AppHelper.appHeaderDivider(),
        ],
      ),
    );
  }

  Widget footer(){
    return CustomFooterWidget();
  }

  Widget noticeView(){
    return Container(
      color: Colors.white10,
      child: Visibility(visible:notice != null,child: notice != null?Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top:12.0, left:12.0),
                child: Text("Hear from us",
                    style: TextStyle(
                        fontFamily: 'Raleway',
                        color: Colors.black54,
                        fontSize: 18,
                        fontWeight: FontWeight.w500)),
              ),
              Padding(
                padding: const EdgeInsets.only(top:12.0, right:12.0),
                child: GestureDetector(
                  onTap: () => AppHelper.cupertinoRoute(context, NoticePage()),
                  child: Text("More", style:TextStyle(
                      fontFamily: 'Raleway',
                      color: Colors.grey,
                      fontSize: 16,
                      fontWeight: FontWeight.w400)),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(child: CustomNoticeViewWidget(notice)),
          )
        ],
      ): Container()),
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
        QuizLetter quizLetter =  QuizLetter.fromMap(docSnapshot.documents[0].data);
        quizLetterDisplay = QuizLetterDisplay(quizLetter.quizLettersId + UserMemory().getPlayer().membershipId,
            false, quizLetter, true, false);
        customQuizLettersWidget = CustomQuizLettersWidget(quizLetterDisplay);
      });
    });
  }

  /// Quiz letters
  void getLatestNotice() {
    Firestore.instance.collection(FirestoreResources.collectionNotice).limit(1).orderBy(FirestoreResources.fieldNoticeAddedDate, descending: true).
    getDocuments().then((docSnapshot){
      setState(() {
        notice =  Notice.fromMap(docSnapshot.documents[0].data);
      });
    });
  }

}
