import 'dart:async';

import 'package:Surprize/CustomWidgets/CustomDidYouKnowWidget.dart';
import 'package:Surprize/GoogleAds/GoogleAdManager.dart';
import 'package:Surprize/Helper/AppHelper.dart';
import 'package:Surprize/Memory/UserMemory.dart';
import 'package:Surprize/Models/DailyQuizChallenge/DQCPlay.dart';
import 'package:Surprize/Models/DailyQuizChallenge/enums/UserPresenceState.dart';
import 'package:Surprize/Models/Facts.dart';
import 'package:Surprize/Models/QuizDataState.dart';
import 'package:Surprize/TimesUpPage.dart';
import 'package:Surprize/UserProfileManagement/UserProfile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:Surprize/CountDownTimerTypeEnum.dart';
import 'package:Surprize/CustomWidgets/CustomCountDownTimerWidget.dart';
import 'package:Surprize/CustomWidgets/DailyQuizChallenge/CustomQuizAnswerButtonWidget.dart';
import 'package:Surprize/SurprizeSummaryPage.dart';
import 'package:Surprize/Firestore/FirestoreOperations.dart';
import 'package:Surprize/Helper/SoundHelper.dart';
import 'package:Surprize/Leaderboard/ScoreSystem.dart';
import 'package:Surprize/Models/DailyQuizChallenge/DailyQuizChallengeQnA.dart';
import 'package:Surprize/Models/DailyQuizChallenge/enums/QuizState.dart';
import 'package:Surprize/Resources/FirestoreResources.dart';
import 'package:Surprize/Resources/ImageResources.dart';
import 'package:Surprize/Resources/SoundResources.dart';
import 'package:Surprize/Resources/StringResources.dart';

import 'package:Surprize/Models/DailyQuizChallenge/enums/CurrentQuizState.dart';

class SurprizeGamePlayPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SurprizeGamePlayPageState();
  }
}

class SurprizeGamePlayPageState
    extends State<SurprizeGamePlayPage> with WidgetsBindingObserver,TickerProviderStateMixin {
  static double countDownTimerHeight = 120.0;
  static double countDownTimerWidth = 200.0;

  // init button code value
  static final int quizFirstButtonCode = 1;
  static final int quizSecondButtonCode = 2;
  static final int quizThirdButtonCode = 3;
  static final int quizFourButtonCode = 4;

  QuizState _quizState;

  List<DailyQuizChallengeQnA> _dailyQuizChallengeQnAList;


  FadeTransition _quizQuestion;
  CustomQuizAnswerButtonWidget _firstAnswer;
  CustomQuizAnswerButtonWidget _secondAnswer;
  CustomQuizAnswerButtonWidget _thirdAnswer;
  CustomQuizAnswerButtonWidget _fourthAnswer;

  CustomCountDownTimerWidget _customCountDownTimerWidget =
      CustomCountDownTimerWidget(
          true,
          32,
          true,
          new Duration(seconds: 11),
          "",
          countDownTimerHeight,
          countDownTimerWidth,
          Colors.white,
          Colors.red[900],
          CountDownTimeTypeEnum.DAILY_QUIZ_CHALLENGE_GAME_PLAY);

  bool _clickableButton = true;
  bool _disableButtonPermanently = false;

  bool _readyToShowQuestion = false;
  bool _hasQuizListBeenRetrieved = false;
  bool _isGameFinished = false;
  bool _hasMusicStarted = false;

  int currentIndex = 0;

  SoundHelper _soundHelper;

  int _totalScore = 0;
  int _totalRightAnswer = 0;

  UserProfile _userProfile;

  Map<String, DQCPlay> quizPlayList = new Map();
  Map<String, Facts> _funFacts = new Map();

  GlobalKey<ScaffoldState> _scaffoldKey;

  bool _isQuestionFromCache = false;
  AnimationController _fadeInAnimation;

  @override
  void initState() {
    super.initState();
    getFacts();
    WidgetsBinding.instance.addObserver(this);
    _fadeInAnimation = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 500));
    _fadeInAnimation.forward();
    initQuizQuestion();
    listenForQuizState();
    _userProfile = UserProfile();
    _userProfile.setUserPresence(
     UserMemory().getPlayer().membershipId, UserPresenceState.ONLINE);
    _soundHelper = SoundHelper();
    _scaffoldKey = GlobalKey<ScaffoldState>();
      Future.delayed(Duration(seconds: 5), (){
      GoogleAdManager().disposeNoticeBannerAd();
      GoogleAdManager().disposeQuizLetterBannerAd();
    });
  }

  getFacts(){
    Firestore.instance.collection(FirestoreResources.collectionsDidYouKnow).snapshots().listen((querySnapshot){
      querySnapshot.documents.forEach((docSnapshot){
        Facts fact = Facts.fromMap(docSnapshot.data);
        if(_funFacts.containsKey(fact.id)){
          _funFacts.remove(fact.id);
        }
        if(fact.state == "DELETED")
          return;

        setState(() {
          _funFacts.putIfAbsent(fact.id, () => fact);
        });

      });
    });
  }


  @override
  void dispose() {
    if (!_isGameFinished)
      _userProfile.setUserPresence(UserMemory().getPlayer().membershipId,
          UserPresenceState.END_GAME_ABRUPTLY);
    _fadeInAnimation.dispose();
    WidgetsBinding.instance.removeObserver(this);
    if (_soundHelper != null) {
      _soundHelper.stopSound();
    }
    _quizState = null;
    super.dispose();
  }
  /// Detect the change in app lifecycle state
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      _userProfile.setUserPresence(UserMemory().getPlayer().membershipId,
          UserPresenceState.END_GAME_ABRUPTLY);
      if (_soundHelper != null) {
        _soundHelper.stopSound();
      }
    }
    if (state == AppLifecycleState.resumed) {
      _userProfile.setUserPresence(
          UserMemory().getPlayer().membershipId, UserPresenceState.ONLINE);
      _soundHelper.stopSound();
      _quizState.quizState ==
              CurrentQuizState.QUIZ_IS_ON_AND_QUESTION_IS_NOT_BEING_DISPLAYED
          ? _soundHelper.playBackgroundSound(
              SoundResources.dailyQuizChallengeWaitingBackgroundMusic
                  .split('/')[1],
              SoundResources.dailyQuizChallengeWaitingBackgroundMusic)
          : _soundHelper.playBackgroundSound(
              SoundResources.dailyQuizChallengeBackgroundMusic.split('/')[1],
              SoundResources.dailyQuizChallengeBackgroundMusic);
    }
  }

  void setButtonClickable(bool clickable) {
    _clickableButton = clickable;
  }

  /*
  Initialize question and answer for the first time
   */
  void initializeQuestionAndAnswer(int currentIndex) {
    try {
      // setting quiz question
      _quizQuestion = FadeTransition(
        opacity: _fadeInAnimation,
        child: Text(_dailyQuizChallengeQnAList[currentIndex].question,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white,
                fontSize: 21.0,
                fontWeight: FontWeight.w500,
                fontFamily: 'Raleway')),
      );

      // Setting answer button for the quiz
      _firstAnswer = CustomQuizAnswerButtonWidget(
          onButtonSelect,
          quizFirstButtonCode,
          _dailyQuizChallengeQnAList[currentIndex].answers.elementAt(0),
          EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0, bottom: 8));

      _secondAnswer = CustomQuizAnswerButtonWidget(
          onButtonSelect,
          quizSecondButtonCode,
          _dailyQuizChallengeQnAList[currentIndex].answers.elementAt(1),
          EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0, bottom: 8));

      _thirdAnswer = CustomQuizAnswerButtonWidget(
          onButtonSelect,
          quizThirdButtonCode,
          _dailyQuizChallengeQnAList[currentIndex].answers.elementAt(2),
          EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0, bottom: 8));

      _fourthAnswer = CustomQuizAnswerButtonWidget(
          onButtonSelect,
          quizFourButtonCode,
          _dailyQuizChallengeQnAList[currentIndex].answers.elementAt(3),
          EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0, bottom: 8.0));
    } catch (error) {}
  }

  /*
  Check if given answer is correct answer
   */
  bool isRightAnswer(value) {
    return value == _dailyQuizChallengeQnAList[currentIndex].rightAnswer;
  }

  bool retry = false;
  StreamSubscription<QuerySnapshot> subscription;
  /*
  Init quiz
   */
  void initQuizQuestion() {
    if (retry) {
      subscription.cancel();
      subscription = null;
    }

    // Listen for the quiz question and answers.
    subscription = FirestoreOperations()
        .getNestedCollectionReference(
            FirestoreResources.collectionQuizName,
            FirestoreResources.collectionQuestionAndAnswersList,
            FirestoreResources.fieldQuizDocumentName)
        .snapshots()
        .listen((querySnapshot) {

      if (mounted) {
        setState(() {
          try {
            _dailyQuizChallengeQnAList = querySnapshot.documents
                .map((documentSnapshot) =>
                    DailyQuizChallengeQnA.fromMap(documentSnapshot.data))
                .where((val) => val.state == QuizDataState.ACTIVE)
                .toList();
          } catch (error) {
            if (!retry) {
              initQuizQuestion();
            }
            retry = true;
            return;
          }
          _isQuestionFromCache = false;
        });
      }

      quizPlayList.putIfAbsent(_dailyQuizChallengeQnAList[0].id,
          () => DQCPlay(_dailyQuizChallengeQnAList[0], -1));
      quizPlayList.putIfAbsent(_dailyQuizChallengeQnAList[1].id,
          () => DQCPlay(_dailyQuizChallengeQnAList[1], -1));
      quizPlayList.putIfAbsent(_dailyQuizChallengeQnAList[2].id,
          () => DQCPlay(_dailyQuizChallengeQnAList[2], -1));
      quizPlayList.putIfAbsent(_dailyQuizChallengeQnAList[3].id,
          () => DQCPlay(_dailyQuizChallengeQnAList[3], -1));
      quizPlayList.putIfAbsent(_dailyQuizChallengeQnAList[4].id,
          () => DQCPlay(_dailyQuizChallengeQnAList[4], -1));
      initializeQuestionAndAnswer(currentIndex);

      _hasQuizListBeenRetrieved = true;
      setButtonClickable(true);
    });
  }

  /*
  Update question and answer
   */
  void updateQuestionAndAnswer() {
    // Update answer
    _quizQuestion =
        FadeTransition(
          opacity: _fadeInAnimation,
          child: Text(_dailyQuizChallengeQnAList[currentIndex].question,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 21.0,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Raleway')),
        );

    // Update question
    _firstAnswer.setQuizAnswer(
        _dailyQuizChallengeQnAList[currentIndex].answers.elementAt(0));
    _secondAnswer.setQuizAnswer(
        _dailyQuizChallengeQnAList[currentIndex].answers.elementAt(1));
    _thirdAnswer.setQuizAnswer(
        _dailyQuizChallengeQnAList[currentIndex].answers.elementAt(2));
    _fourthAnswer.setQuizAnswer(
        _dailyQuizChallengeQnAList[currentIndex].answers.elementAt(3));
  }

  /**
   * Listen for the quiz if its on or not.
   */
  void listenForQuizState() {
    // Listen for the quiz state
    FirestoreOperations()
        .getSnapshotStream(FirestoreResources.collectionQuizName,
            FirestoreResources.fieldQuizDocumentName)
        .listen((snapshot) {

          _quizState = QuizState.fromMap(snapshot.data);
          if (_quizState.quizState ==
              CurrentQuizState.QUIZ_IS_ON_AND_QUESTION_IS_BEING_DISPLAYED) {

            setState(() {
              _readyToShowQuestion = true;
            });
          }
          if (_quizState.quizState == CurrentQuizState.QUIZ_IS_ON_AND_QUESTION_IS_NOT_BEING_DISPLAYED) {
            setState(() {
              _readyToShowQuestion = false;
            });
          }
          if (_quizState.quizState == CurrentQuizState.QUIZ_IS_OFF) {
            _soundHelper.stopSound();
            AppHelper.cupertinoRouteWithPushReplacement(context, TimesUpPage());
          }
        });

  }

  /*
  Handle button click event
   */
  void onButtonSelect(value, CustomQuizAnswerButtonWidget button) {
    if (_clickableButton && !_disableButtonPermanently) {
      quizPlayList[_dailyQuizChallengeQnAList[currentIndex].id].providedAnswer =
          value;
      if (isRightAnswer(value)) {
        _totalScore = _totalScore + ScoreSystem.getScoreFromQuizCorrectAnswer();
        _totalRightAnswer++;
      }
      setButtonClickable(false);
      button.changeColor(value,"SELECTED");
    }
  }

  /// Handle question fade in animation
  initQuestionFadeInAnimation() {
    if (currentIndex + 1 > _dailyQuizChallengeQnAList.length) {
      _fadeInAnimation.stop();
      return;
    }
    _fadeInAnimation.forward();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        key: _scaffoldKey,
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: new AssetImage(ImageResources.appBackgroundImage),
                  fit: BoxFit.fill)),
          child: (_readyToShowQuestion && _hasQuizListBeenRetrieved
              ? ifAllQuizValueHasBeenSet()
              : ifQuizValueIsInRetrievedMode()),
        ),
      ),
    );
  }

  /*
  Keep time track
   */
  void keepTimeTrack(int second) async {
    Future.delayed(Duration(seconds: second), () {
      if (mounted) {
        setState(() {
          if ((currentIndex + 1) != _dailyQuizChallengeQnAList.length) {
            currentIndex = currentIndex + 1;
            updateQuestionAndAnswer();
            resetButtonColor();
            setButtonClickable(true);
            _customCountDownTimerWidget.resetCountdown();
            _customCountDownTimerWidget.startCountdown();
          } else {
            _customCountDownTimerWidget.stopCountdown();
            _isGameFinished = true;
            setButtonClickable(false);
            _userProfile.setUserPresence(UserMemory().getPlayer().membershipId,
                UserPresenceState.PLAYED_GAME_AND_EXITED);
            goToScoreSummaryPage();
          }
        });
      }
    }).catchError((error) {
      print(error);
    });
  }

  /*
  Reset button color;
   */
  void resetButtonColor() {
    _firstAnswer.resetColor();
    _secondAnswer.resetColor();
    _thirdAnswer.resetColor();
    _fourthAnswer.resetColor();
  }

  /// Quiz Heading
  Widget quizHeadingTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text("Surprize Challenge",
            style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 24,
                color: Colors.white,
                fontFamily: 'Raleway')),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Question: ",
                style: TextStyle(
                    fontWeight: FontWeight.w200,
                    fontSize: 24,
                    color: Colors.white,
                    fontFamily: 'Raleway')),
            Text(
                (currentIndex + 1).toString() +
                    "/" +
                    _dailyQuizChallengeQnAList.length.toString(),
                style: TextStyle(
                    fontWeight: FontWeight.w200,
                    fontSize: 24,
                    color: Colors.white,
                    fontFamily: 'Raleway')),
          ],
        ),
      ],
    );
  }

  /// Quiz question and answer box
  Widget quizQuestionAnswerBox() {
    return Padding(
      padding: const EdgeInsets.only(left: 18, right: 18),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
                left: 4.0, right: 4.0, top: 4.0, bottom: 8.0),
            child: _quizQuestion,
          ),
          SizedBox(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black26,
                        offset: Offset(1.0, 3.0),
                        blurRadius: 21.0),
                  ],
                  border: new Border.all(color: Colors.white10, width: 0),
                  borderRadius: new BorderRadius.all(Radius.circular(21.0))),
              child: Column(
                children: <Widget>[
                  _firstAnswer,
                  _secondAnswer,
                  _thirdAnswer,
                  _fourthAnswer,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  /*
  Widget for quiz play
   */
  Widget ifAllQuizValueHasBeenSet() {
    if (!_hasMusicStarted) {
      _soundHelper.stopSound();
      _soundHelper.playBackgroundSound(
          SoundResources.dailyQuizChallengeBackgroundMusic.split('/')[1],
          SoundResources.dailyQuizChallengeBackgroundMusic);
      _hasMusicStarted = true;
    }

    if (!_isGameFinished) {
      initQuestionFadeInAnimation();
      keepTimeTrack(11);
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        quizHeadingTitle(),
        _customCountDownTimerWidget,
        quizQuestionAnswerBox()
      ],
    );
  }

  bool soundOn = true;
  bool _waitingMusicPlayed = false;
  // Widget if value is in retrieved mode
  Widget ifQuizValueIsInRetrievedMode() {
    if (_quizState == null ||
        _quizState.quizState ==
            CurrentQuizState.QUIZ_IS_ON_AND_QUESTION_IS_NOT_BEING_DISPLAYED ||
        _isQuestionFromCache) {
      if (soundOn) {
        if (!_waitingMusicPlayed) {
          _soundHelper.playBackgroundSound(
              SoundResources.dailyQuizChallengeWaitingBackgroundMusic
                  .split('/')[1],
              SoundResources.dailyQuizChallengeWaitingBackgroundMusic);
          _waitingMusicPlayed = true;
        }
      } else {
        _soundHelper.stopSound();
        _waitingMusicPlayed = false;
      }
    }

    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom:8.0),
            child: _funFacts.length != 0?Text("Did you know?", style: TextStyle(fontFamily: 'Raleway', color: Colors.white,fontWeight: FontWeight.w600, fontSize: 18)):Container(height:0, width:0)
    ),
          _funFacts.length != 0?CustomDidYouKnowWidget(_funFacts.values.toList()):Container(height: 0, width: 0),
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Text(
                _isQuestionFromCache
                    ? "We are unable to load new quiz questions. Make sure your internet is working!"
                    : StringResources.getReadyForQuizText,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white, fontFamily: 'Raleway', fontSize: 21)),
          ),
        ],
      ),

      IconButton(
          icon: Icon(soundOn ? Icons.volume_up : Icons.volume_off),
          color: Colors.white,
          onPressed: () {
            if (mounted) {
              setState(() {
                soundOn = !soundOn;
              });
            }
          }),
    ]);
  }

/*
Go to summary page after game is finished.
 */
  void goToScoreSummaryPage() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => DailyQuizChallengeScoreSummaryPage(_totalRightAnswer,_totalScore, _quizState, quizPlayList),
        ));
  }

  /// Listen of quiz state change
  listenForQuizStateChange() {
    Firestore.instance
        .collection(FirestoreResources.collectionQuizName)
        .document(FirestoreResources.fieldQuizDocumentName)
        .snapshots()
        .listen((snapshot) {
      QuizState quizState = QuizState.fromMap(snapshot.data);
      if (quizState.quizState == CurrentQuizState.QUIZ_IS_OFF) {
        if(mounted) {
          setState(() {
            _disableButtonPermanently = true;
          });
        }
      }
    });
  }
}
