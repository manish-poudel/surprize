import 'package:Surprize/CustomWidgets/CustomFooterWidget.dart';
import 'package:Surprize/CustomWidgets/CustomNoticeViewWidget.dart';
import 'package:Surprize/CustomWidgets/CustomQuizLettersWidget.dart';
import 'package:Surprize/CustomWidgets/GameCards.dart';

import 'package:Surprize/Memory/UserMemory.dart';
import 'package:Surprize/Models/NoNetwork.dart';
import 'package:Surprize/Models/Notice.dart';
import 'package:Surprize/Models/Player.dart';
import 'package:Surprize/Models/QuizLetter/QuizLetter.dart';
import 'package:Surprize/Models/QuizLetter/QuizLetterDisplay.dart';
import 'package:Surprize/NoInternetConnectionPage.dart';
import 'package:Surprize/QuizLettersPage.dart';
import 'package:admob_flutter/admob_flutter.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Surprize/SurprizeChallengePage.dart';
import 'package:Surprize/SurprizeNavigationDrawerWidget.dart';
import 'CustomUpcomingEventsWidget.dart';
import 'CustomWidgets/CustomRoundedEdgeButton.dart';
import 'SurprizeGamePlayPage.dart';
import 'GoogleAds/GoogleAdManager.dart';
import 'Helper/AppHelper.dart';
import 'package:Surprize/Models/DailyQuizChallenge/enums/CurrentQuizState.dart';
import 'package:Surprize/Models/DailyQuizChallenge/enums/QuizState.dart';
import 'Resources/FirestoreResources.dart';

class PlayerDashboard extends StatefulWidget {
  PlayerDashboard();

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return PlayerDashboardState();
  }
}

class PlayerDashboardState extends State<PlayerDashboard>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  SurprizeChallengePage _dailyQuizChallengePage;

  AnimationController _animationControllerSurprize;

  bool _showDailyQuizChallengeWidget = false;
  var subscription;

  QuizLetterDisplay quizLetterDisplay;
  Notice notice;

  CustomQuizLettersWidget customQuizLettersWidget;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  AdmobBanner _admobBanner;
  bool _adLoaded = false;
  bool _showAd = true;
  bool _retrieveDQCLoaded = false;
  bool isEmailVerified;
  bool showEmailVerificationPopUp = false;
  bool _hasPlayerPlayedDQC = false;

  DateTime _nextGame;


  @override
  void initState() {
    super.initState();
    Admob.initialize(GoogleAdManager.appId);
    _admobBanner = AdmobBanner(
      adUnitId: GoogleAdManager.dashboardBannerId,
      adSize: AdmobBannerSize.BANNER,
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
        handleBannerAdEvent(event, args);
      },
    );
    _animationControllerSurprize =
        new AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animationControllerSurprize.repeat();
    _dailyQuizChallengePage = new SurprizeChallengePage(context);
    isDailyQuizAvailable();
    getQuizLetters();
    getLatestNotice();
    getDQCData();
    checkNetworkConnection();
    WidgetsBinding.instance.addObserver(this);
    checkEmailVerificationState();
  }

  /// Check if player has played dqc
  getDQCData() async {
    await Firestore.instance
        .collection(FirestoreResources.collectionDailyQuizChallenge)
        .document(FirestoreResources.docChallengeOfToday)
        .collection(FirestoreResources.docChallengePlayerList)
        .document(UserMemory().getPlayer().membershipId)
        .snapshots()
        .listen((snapshot) {
      setState(() {
        _hasPlayerPlayedDQC = snapshot.exists;
      });
    });

    Firestore.instance
        .collection(FirestoreResources.collectionDailyQuizChallenge)
        .document(FirestoreResources.docChallengeOfToday)
        .get()
        .then((documentSnapshot) {
      _nextGame = AppHelper.convertToDateTime(
          documentSnapshot.data[FirestoreResources.fieldNextGameOn]);
      setState(() {
        _retrieveDQCLoaded = true;
      });
    });
  }

  /// Check email verification state
  void checkEmailVerificationState() {
    UserMemory().firebaseUser.getIdToken();
    FirebaseAuth.instance.currentUser().then((user) {
      user.reload();
      UserMemory().firebaseUser = user;
      setState(() {
        isEmailVerified = UserMemory().firebaseUser.isEmailVerified;
        showEmailVerificationPopUp = !isEmailVerified;
      });
    });
  }

  /// Update email verification
  updateEmailVerification(Player player) {
    Firestore.instance
        .collection(FirestoreResources.userCollectionName)
        .document(player.membershipId)
        .updateData(player.toMap());
  }

  /// Banner events
  handleBannerAdEvent(AdmobAdEvent event, Map<String, dynamic> args) {
    switch (event) {
      case AdmobAdEvent.loaded:
        setState(() {
          _adLoaded = true;
        });
        break;
      case AdmobAdEvent.failedToLoad:
        setState(() {
          _showAd = false;
          _adLoaded = false;
        });
        break;
      default:
    }
  }


  /// Check for network connection
  checkNetworkConnection() {
    print("Check for internet connection");
   Connectivity().checkConnectivity().then((ConnectivityResult result){
     if (result == ConnectivityResult.none) {
       print("no internet");
       AppHelper.cupertinoRouteWithPushReplacement(
           context, NoInternetConnectionPage(Source.PLAYER_DASHBOARD));
     }
   });
    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        print("no internet");
        AppHelper.cupertinoRouteWithPushReplacement(
            context, NoInternetConnectionPage(Source.PLAYER_DASHBOARD));
      }
    });
  }

  @override
  void dispose() {
    _animationControllerSurprize.dispose();
    _animationControllerSurprize.dispose();
    WidgetsBinding.instance.removeObserver(this);
    _adLoaded = false;
    super.dispose();
  }

  bool _dailyQuizChallengePageOpened = false;

  /// Is daily quiz available
  isDailyQuizAvailable() async {
    _dailyQuizChallengePage.listenForDailyQuizGameOn((QuizState quizState) {
      setState(() {
        _showDailyQuizChallengeWidget =
            (quizState.quizState != CurrentQuizState.QUIZ_IS_OFF);
      });
      if (_dailyQuizChallengePageOpened) return;
      if (quizState.quizState ==
              CurrentQuizState.QUIZ_IS_ON_AND_QUESTION_IS_BEING_DISPLAYED ||
          quizState.quizState ==
              CurrentQuizState.QUIZ_IS_ON_AND_QUESTION_IS_NOT_BEING_DISPLAYED) {
        AppHelper.cupertinoRoute(context, SurprizeGamePlayPage());
        _dailyQuizChallengePageOpened = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primaryColor: Colors.purple[800]),
        home: Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
                title: Text("Home", style: TextStyle(fontFamily: 'Raleway'))),
            drawer: SurprizeNavigationDrawerWidget(context),
            body: playerDashboard()));
  }

  Widget playerDashboard() {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[dashboardBody(), Container(height: 48)],
      )),
    );
  }

  /// Dashboard body
  Widget dashboardBody() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Visibility(
              visible: showEmailVerificationPopUp,
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  color: Colors.purple[800],
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 16.0, top: 16),
                              child: Text(
                                "Account not verified! Send verification link",
                                style: TextStyle(
                                    color: Colors.white, fontFamily: 'Raleway'),
                              ),
                            ),
                            IconButton(
                                color: Colors.purple,
                                icon: Icon(Icons.send),
                                onPressed: () {
                                  UserMemory()
                                      .firebaseUser
                                      .sendEmailVerification()
                                      .then((_) {
                                    setState(() {
                                      AppHelper.showSnackBar(
                                          "Email verification link has been sent to your email id. Follow the link to verify your email address. Please note that it might take some time to see changes",
                                          _scaffoldKey);
                                      showEmailVerificationPopUp = false;
                                    });
                                  });
                                }),
                          ],
                        ),
                        IconButton(
                            icon: Icon(Icons.close),
                            color: Colors.red,
                            iconSize: 18,
                            onPressed: () {
                              setState(() {
                                showEmailVerificationPopUp = false;
                              });
                            })
                      ]))),
          noticeView(),
          Visibility(
            visible: _retrieveDQCLoaded,
            child: Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 4.0),
              child: GameCards(_hasPlayerPlayedDQC, _nextGame, _scaffoldKey),
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: CustomUpcomingEventsWidget()),
          advertisement(),
          Visibility(
            visible: _showDailyQuizChallengeWidget,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: dailyQuizOnWidget(),
            ),
          ),
          //Visibility(visible:quizLetterDisplay != null,child: AppHelper.appHeaderDivider()),

          quizLetterDisplay != null
              ? GestureDetector(
                  child: quizLettersSmallContainer(),
                  onTap: () => AppHelper.cupertinoRoute(
                      context,
                      QuizLettersPage(
                          quizLetterDisplay.quizLetter.quizLettersId)))
              : Visibility(visible: false, child: Container()),
          // Visibility(visible:notice != null,child: AppHelper.appHeaderDivider()),
        ],
      ),
    );
  }

  Widget advertisement() {
    return Visibility(
      visible: _showAd,
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Visibility(
                    visible: _adLoaded,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Container(
                          decoration: new BoxDecoration(
                              color: Colors.amber,
                              border:
                                  new Border.all(color: Colors.amber, width: 1),
                              borderRadius:
                                  new BorderRadius.all(Radius.circular(1.0))),
                          child: Text("Ad",
                              style: TextStyle(color: Colors.white))),
                    ),
                  ),
                  Center(
                    child: _admobBanner,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget footer() {
    return CustomFooterWidget();
  }

  Widget noticeView() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
      child: Container(
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
            opacity: _animationControllerSurprize,
            child: Text(
              "Surprize Challenge is on !!!",
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
                        builder: (context) => SurprizeGamePlayPage())),
                color: Colors.purple[800],
                text: "Play")
          ]),
        ],
      ),
    );
  }

  /// Quiz letter small container
  Widget quizLettersSmallContainer() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
      child: Card(
        color: Colors.purple[800],
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
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: Text("Quiz letter",
                          style: TextStyle(
                              fontFamily: 'Raleway',
                              color: Colors.white,
                              fontWeight: FontWeight.w500)),
                    ),
                    IconButton(
                        tooltip:
                            "Quiz letter is a fun way to test your knowledge on different subjects with facts reveal. This improves your chance of winning daily quiz challenge!",
                        icon: Icon(Icons.help_outline,
                            color: Colors.white, size: 14),
                        onPressed: () {
                          _scaffoldKey.currentState.showSnackBar(new SnackBar(
                              content: new Text(
                                  "Quiz letter is a fun way to test your knowledge on different subjects with facts reveal. This improves your chance of winning daily quiz challenge!")));
                        })
                  ],
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () => AppHelper.cupertinoRoute(context,
                          QuizLettersPage(quizLetterDisplay.displayId)),
                      child: Container(
                        padding: EdgeInsets.all(4.0),
                        decoration: new BoxDecoration(
                            border:
                                new Border.all(color: Colors.white, width: 1),
                            borderRadius:
                                new BorderRadius.all(Radius.circular(40.0))),
                        child: Text("Play more",
                            style: TextStyle(
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
        .snapshots()
        .listen((docSnapshot) {
      setState(() {
        QuizLetter quizLetter =
            QuizLetter.fromMap(docSnapshot.documents[0].data);
        quizLetterDisplay = QuizLetterDisplay(
            quizLetter.quizLettersId + UserMemory().getPlayer().membershipId,
            false,
            quizLetter,
            true,
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
        .snapshots()
        .listen((docSnapshot) {
      setState(() {
        notice = Notice.fromMap(docSnapshot.documents[0].data);
      });
    });
  }
}
