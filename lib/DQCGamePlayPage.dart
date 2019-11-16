import 'package:Surprize/AppShare/ShareApp.dart';
import 'package:Surprize/CountDownTimerTypeEnum.dart';
import 'package:Surprize/CustomWidgets/CustomCountDownTimerWidget.dart';
import 'package:Surprize/CustomWidgets/CustomProgressbarWidget.dart';
import 'package:Surprize/CustomWidgets/DailyQuizChallenge/CustomQuizAnswerButtonWidget.dart';
import 'package:Surprize/GoogleAds/GoogleAdManager.dart';
import 'package:Surprize/Helper/AppHelper.dart';
import 'package:Surprize/Helper/SoundHelper.dart';
import 'package:Surprize/Leaderboard/LeaderboardManager.dart';
import 'package:Surprize/Leaderboard/ScoreSystem.dart';
import 'package:Surprize/LeaderboardPage.dart';
import 'package:Surprize/Memory/UserMemory.dart';
import 'package:Surprize/Models/DailyQuizChallenge/DLeaderboard.dart';
import 'package:Surprize/Models/DailyQuizChallenge/DailyQuizChallengeQnA.dart';
import 'package:Surprize/Models/QuizLetter/QuizLetter.dart';
import 'package:Surprize/Resources/FirestoreResources.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'Resources/ImageResources.dart';
import 'Resources/SoundResources.dart';

class DQCGamePlayPage extends StatefulWidget {

  List<QuizLetter> quizList;
  DQCGamePlayPage(this.quizList);

  @override
  _DQCGamePlayPageState createState() => _DQCGamePlayPageState();
}

class _DQCGamePlayPageState extends State<DQCGamePlayPage>
    with TickerProviderStateMixin {
  static double countDownTimerHeight = 120;
  static double countDownTimerWidth = 120;

  CustomCountDownTimerWidget _customCountDownTimerWidget = buildTimer();

  FadeTransition _quizQuestion;
  CustomQuizAnswerButtonWidget _firstAnswer;
  CustomQuizAnswerButtonWidget _secondAnswer;
  CustomQuizAnswerButtonWidget _thirdAnswer;
  CustomQuizAnswerButtonWidget _fourthAnswer;

  CustomQuizAnswerButtonWidget _selectedAnswerButton;

  List<DailyQuizChallengeQnA> _dailyQuizChallengeQnAList;

  int _currentGameIndex = 0;
  int _selectedButtonIndex = -1;
  int _totalScore = 0;

  bool _isScoreSaved = false;
  bool _isGameWon = false;
  bool _isGameOver = false;
  bool _chancedUsed = false;
  bool _handleAnswerCheckProcess = false;
  bool _chanceUsedAndPlayedAgain = false;

  AnimationController _fadeInAnimation;

  String imageUrl;
  String body;

  @override
  void initState() {
    getQuestion();
    super.initState();
    _fadeInAnimation = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 500));
    _fadeInAnimation.forward();
    createQuizWidget();
    saveScore(false);
  }


  @override
  void dispose(){
    saveScore(_isGameWon);
    GoogleAdManager().disposeDQCInterstitialAd();
    super.dispose();
  }

  /// Get question
  getQuestion() {
    _dailyQuizChallengeQnAList = new List();
    widget.quizList.forEach((quizLetter){
      _dailyQuizChallengeQnAList.add(quizLetter.dailyQuizChallengeQnA);
    });

  }

  /// Reset color
  resetColor() {
    _firstAnswer.resetColor();
    _secondAnswer.resetColor();
    _thirdAnswer.resetColor();
    _fourthAnswer.resetColor();
  }

  /// Update answer
  updateAnswer() {

    _quizQuestion = FadeTransition(
      opacity: _fadeInAnimation,
      child: Text(_dailyQuizChallengeQnAList[_currentGameIndex].question,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.white,
              fontSize: 21.0,
              fontWeight: FontWeight.w500,
              fontFamily: 'Raleway')),
    );
    _firstAnswer.setQuizAnswer(
        _dailyQuizChallengeQnAList[_currentGameIndex].answers.elementAt(0));
    _secondAnswer.setQuizAnswer(
        _dailyQuizChallengeQnAList[_currentGameIndex].answers.elementAt(1));
    _thirdAnswer.setQuizAnswer(
        _dailyQuizChallengeQnAList[_currentGameIndex].answers.elementAt(2));
    _fourthAnswer.setQuizAnswer(
        _dailyQuizChallengeQnAList[_currentGameIndex].answers.elementAt(3));
  }

  /// Proceed to next question
  void checkAnswerAndProceed(int questionNumber) {

    if (_handleAnswerCheckProcess || _currentGameIndex != questionNumber)
      return;
    _handleAnswerCheckProcess = true;
    _customCountDownTimerWidget.stopCountdown();
    if (_dailyQuizChallengeQnAList[_currentGameIndex].rightAnswer ==
        _selectedButtonIndex) {
      _totalScore = _totalScore + ScoreSystem.getScoreFromQuizCorrectAnswer();
      if (_selectedAnswerButton != null) {
        _selectedAnswerButton.changeColor(_selectedButtonIndex, "CORRECT");
      }
      (_currentGameIndex == _dailyQuizChallengeQnAList.length - 1)
          ? handleGameWon()
          : handleNextQuestion();
    } else {
      handleGameOver();
    }
  }

  /// handling next question
  handleNextQuestion(){
    SoundHelper soundHelper = SoundHelper();
    soundHelper..playBackgroundSound(
        SoundResources.rightSelection
            .split('/')[1],
        SoundResources.rightSelection);
    soundHelper.stopSound();
    Future.delayed(Duration(milliseconds: 700),
            () => showResumeDialogBox('Correct-O', "Next"));
  }

  /// Return resume dialog box message
  String getResumeMessage(){
    if(_currentGameIndex == 3){
      return "Wooho! You have made this far but the real challenge still awaits!";
    }
    if(_currentGameIndex == 6){
      return "Money on the sight but the challenge going to get real tough now!";
    }
    if(_currentGameIndex == 8){
      return "Take a deep breath and get ready to win money with this final question!";
    }
    return "";
  }

  /// Save score
  saveScore(bool won){
    String id = Firestore.instance.collection(FirestoreResources.collectionDailyQuizChallenge).document(FirestoreResources.docChallengeOfToday)
        .collection(FirestoreResources.docChallengePlayerList).document().documentID;
    DLeaderboard dLeaderboard = DLeaderboard(id,UserMemory().getPlayer().membershipId,
        UserMemory().getPlayer().name, UserMemory().getPlayer().profileImageURL,DateTime.now(), _totalScore, won, UserMemory().firebaseUser.isEmailVerified);
    Firestore.instance.collection(FirestoreResources.collectionDailyQuizChallenge).document(FirestoreResources.docChallengeOfToday)
        .collection(FirestoreResources.docChallengePlayerList).document(dLeaderboard.playerId).setData(dLeaderboard.toMap());
    if(_totalScore != 0){
      if(!_isScoreSaved){
        // updateScoreLeaderboard();
        _isScoreSaved = true;
      }
    }
  }

  /// Check if its ok to show quiz details
  bool showQuizDisplay(){
    if(_currentGameIndex == 9){
      return _chanceUsedAndPlayedAgain;
    }
    return true;
  }

  /// If game is won
  handleGameWon() {
    _isGameWon = true;
    saveScore(_isGameWon);

    SoundHelper soundHelper = SoundHelper();
    soundHelper..playBackgroundSound(
        SoundResources.won
            .split('/')[1],
        SoundResources.won);
    soundHelper.stopSound();
    _customCountDownTimerWidget.stopCountdown();
    showWonDialogBox(context);
  }

  /// Proceed to next question
  handleCorrectAnswer() {
    Future.delayed(Duration(milliseconds: 500), () {
      _selectedButtonIndex = -1;
      setState(() {
        _handleAnswerCheckProcess = false;
        if (_currentGameIndex < _dailyQuizChallengeQnAList.length - 1) {
          _currentGameIndex = _currentGameIndex + 1;
        }
        resetColor();
        _buttonClickable = true;
        _customCountDownTimerWidget.resetCountdown();
        _customCountDownTimerWidget.startCountdown();
        updateAnswer();
      });
    });
  }

  /// Handle game over
  handleGameOver() {
    if (_selectedAnswerButton != null) {
      SoundHelper soundHelper = SoundHelper();
      soundHelper..playBackgroundSound(
          SoundResources.wrongSelection
              .split('/')[1],
          SoundResources.wrongSelection);
      soundHelper.stopSound();
      _selectedAnswerButton.changeColor(_selectedButtonIndex, "WRONG");
    }
    _isGameOver = true;
    if(_currentGameIndex > 9 ) {
      Future.delayed(
          Duration(milliseconds: 800),
              () =>
              showCorrectAnswer(
                  _dailyQuizChallengeQnAList[_currentGameIndex].rightAnswer));
    }
    else{
      if(_chancedUsed) {
        Future.delayed(
            Duration(milliseconds: 800),
                () =>
                showCorrectAnswer(
                    _dailyQuizChallengeQnAList[_currentGameIndex].rightAnswer));
      }
    }
    Future.delayed(Duration(seconds: 2), () {
      popUpGameOverDialogBox();
    });
  }

  /// Show correct answer
  showCorrectAnswer(int buttonCode) {
    switch (buttonCode) {
      case 1:
        _firstAnswer.changeColor(buttonCode, "CORRECT");
        break;
      case 2:
        _secondAnswer.changeColor(buttonCode, "CORRECT");
        break;
      case 3:
        _thirdAnswer.changeColor(buttonCode, "CORRECT");
        break;
      case 4:
        _fourthAnswer.changeColor(buttonCode, "CORRECT");
        break;
    }
  }

  /// Keep time track for the question
  void keepTimeTrack(int seconds, int questionNumber) {
    Future.delayed(Duration(seconds: seconds), () {
      if ((_currentGameIndex + 1) > _dailyQuizChallengeQnAList.length) {
        print("Game over");
        _customCountDownTimerWidget.stopCountdown();
        _buttonClickable = false;
        return;
      } else {
        checkAnswerAndProceed(questionNumber);
      }
    });
  }

  /// Handle question fade in animation
  initQuestionFadeInAnimation() {
    if (_currentGameIndex + 1 > _dailyQuizChallengeQnAList.length) {
      _fadeInAnimation.stop();
      return;
    }
    _fadeInAnimation.forward();
  }

  @override
  Widget build(BuildContext context) {
    initQuestionFadeInAnimation();
    keepTimeTrack(11, _currentGameIndex);
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
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    quizHeadingTitle(),
                    GestureDetector(onTap:(){
                      showWonDialogBox(context);
                    },child: _customCountDownTimerWidget),
                    quizQuestionAnswerBox()
                  ],
                ),
              ),
            )));
  }

  Widget displayQuizDetails(context){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: new BoxDecoration(
            color:Colors.grey[100],
            borderRadius: new BorderRadius.all(
                Radius.circular(12.0))),
        child: Column(
          children: <Widget>[
            ClipRRect(
                child: widget.quizList[_currentGameIndex].quizLettersUrl != null && widget.quizList[_currentGameIndex].quizLettersUrl.isNotEmpty?
                FadeInImage.assetNetwork(image: widget.quizList[_currentGameIndex].quizLettersUrl,placeholder: ImageResources.emptyImageLoadingUrlPlaceholder, height: 240, width: 240,fit: BoxFit.fill,):Container(height: 0,width: 0),
                borderRadius:BorderRadius.all(Radius.circular(10.0))),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(widget.quizList[_currentGameIndex].quizLettersBody, textAlign:TextAlign.center,style: TextStyle(fontFamily: 'Raleway')),
            )
          ],
        ),
      ),
    );
  }

  /// Pop up dialog box
  popUpGameOverDialogBox() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => showGameOverDialog(context));
  }

  showWonDialogBox(context) {
    GoogleAdManager().showDQCExitInterstitialAd(0.0, AnchorType.bottom);
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0)),
          child: Container(
            padding: EdgeInsets.all(8),
            height: MediaQuery.of(context).size.height * 0.32,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Positioned(
                  top: 16,
                  child: CircleAvatar(
                    child: Image.asset(ImageResources.achievementTrophy),
                    radius: 21,
                  ),
                ),
                Positioned(
                  top: 68,
                  child: Column(
                    children: <Widget>[
                      Text("Congratulation!",
                          style: TextStyle(
                              color: Colors.purple[800],
                              fontSize: 18,
                              fontFamily: 'Raleway',
                              fontWeight: FontWeight.w600)),
                      Padding(
                        padding: const EdgeInsets.only(left:8.0, right: 8.0),
                        child: Column(
                          children: <Widget>[
                            Text("You've won today's",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.purple[600],
                                    fontSize: 16,
                                    fontFamily: 'Raleway',
                                    fontWeight: FontWeight.w500)),
                            Text("DAILY QUIZ CHALLENGE",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.purple[600],
                                    fontSize: 16,
                                    fontFamily: 'Raleway',
                                    fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top:4.0),
                            child: Text("Check ", style: TextStyle(
                                color: Colors.blueGrey,
                                fontSize: 14,
                                fontFamily: 'Raleway',
                                fontWeight: FontWeight.w400)),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                              AppHelper.cupertinoRouteWithPushReplacement(this.context, LeaderboardPage(UserMemory().getPlayer().membershipId));
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(top:4.0),
                              child: Text("leaderboard", style: TextStyle(
                                  color: Colors.blueGrey,
                                  decoration: TextDecoration.underline,
                                  fontSize: 14,
                                  decorationStyle: TextDecorationStyle.solid,
                                  fontFamily: 'Raleway',
                                  fontWeight: FontWeight.w500)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top:4.0),
                            child: Text(" to see other winners", style: TextStyle(
                                color: Colors.blueGrey,
                                fontSize: 14,
                                fontFamily: 'Raleway',
                                fontWeight: FontWeight.w400)),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top:8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            FlatButton(
                                child: Text("Exit",
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 18)),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  Navigator.of(this.context).pop();
                                }),
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: FlatButton(
                                  child: Row(
                                    children: <Widget>[
                                      Icon(Icons.share,
                                          color: Colors.green),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 4.0),
                                        child: Text("Share",
                                            style: TextStyle(
                                                color: Colors.green,
                                                fontSize: 18)),
                                      ),
                                    ],
                                  ),
                                  onPressed: () {
                                    ShareApp().shareAppFromDQC();
                                  }),

                            ),

                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  /// Quiz Heading
  Widget quizHeadingTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text("Daily Quiz Challenge",
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
                (_currentGameIndex + 1).toString() +
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

  /// Build timer
  static CustomCountDownTimerWidget buildTimer() {
    return CustomCountDownTimerWidget(
        true,
        32,
        true,
        new Duration(seconds: 11),
        "",
        countDownTimerHeight,
        countDownTimerWidth,
        Colors.white,
        Colors.red[500],
        CountDownTimeTypeEnum.DAILY_QUIZ_CHALLENGE_GAME_PLAY);
  }

  bool _buttonClickable = true;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  /// On button select
  onButtonSelect(value, CustomQuizAnswerButtonWidget button) {
    _selectedAnswerButton = button;
    if (_buttonClickable) {
      _buttonClickable = false;
      _selectedButtonIndex = value;
      checkAnswerAndProceed(_currentGameIndex);
    }
  }

  /// Create quiz Widget
  createQuizWidget() {
    try {
      // setting quiz question
      _quizQuestion = FadeTransition(
        opacity: _fadeInAnimation,
        child: Text(_dailyQuizChallengeQnAList[_currentGameIndex].question,
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
          1,
          _dailyQuizChallengeQnAList[_currentGameIndex].answers.elementAt(0),
          EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0, bottom: 8));

      _secondAnswer = CustomQuizAnswerButtonWidget(
          onButtonSelect,
          2,
          _dailyQuizChallengeQnAList[_currentGameIndex].answers.elementAt(1),
          EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0, bottom: 8));

      _thirdAnswer = CustomQuizAnswerButtonWidget(
          onButtonSelect,
          3,
          _dailyQuizChallengeQnAList[_currentGameIndex].answers.elementAt(2),
          EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0, bottom: 8));

      _fourthAnswer = CustomQuizAnswerButtonWidget(
          onButtonSelect,
          4,
          _dailyQuizChallengeQnAList[_currentGameIndex].answers.elementAt(3),
          EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0, bottom: 8.0));
    } catch (error) {}
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

  /// On hitting will pop scope
  Future<bool> _onWillPopScope() async {
    Navigator.of(context).pop();
    return true;
  }

  /// Show resume dialog box
  showResumeDialogBox(String message, String buttonText) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => WillPopScope(
          onWillPop: (){},
          child: Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircleAvatar(
                            backgroundImage: AssetImage(ImageResources.happyEmoji),
                            radius: 24,
                          ),
                        ),
                        Column(
                          children: <Widget>[
                            Text(message,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.purple,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Raleway')),
                            Visibility(visible: _currentGameIndex == 3 || _currentGameIndex == 6 || _currentGameIndex == 8,
                              child: Text(getResumeMessage(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Raleway')),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Visibility(visible: showQuizDisplay(),child: SingleChildScrollView(child: displayQuizDetails(context))),
                    FlatButton(
                        color: Colors.green,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text(buttonText,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Raleway')),
                          ],
                        ),
                        onPressed: () {
                          _chanceUsedAndPlayedAgain = _chancedUsed;
                          Navigator.of(context).pop();
                          handleCorrectAnswer();
                        }),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  ///Show video ad
  showVideoAd() async {
    CustomProgressbarWidget customProgressbarWidget = CustomProgressbarWidget();
    customProgressbarWidget.startProgressBar(
        context, "Loading video ...", Colors.white, Colors.blueGrey);
    MobileAdTargetingInfo targetingInfo =
    MobileAdTargetingInfo(childDirected: false);
    RewardedVideoAd.instance.listener = (RewardedVideoAdEvent event,
        {String rewardType, int rewardAmount}) async {
      if (event == RewardedVideoAdEvent.rewarded) {
        _chancedUsed = true;
        Navigator.of(_dialogBoxContext).pop();
      }
      if (event == RewardedVideoAdEvent.loaded) {
        await RewardedVideoAd.instance.show();
        customProgressbarWidget.stopAndEndProgressBar(context);
      }

      if (event == RewardedVideoAdEvent.failedToLoad) {
        customProgressbarWidget.stopAndEndProgressBar(context);
        AppHelper.showSnackBar("Failed to load ad. Try again!", _scaffoldKey);
      }

      if (event == RewardedVideoAdEvent.closed) {
        if (_chancedUsed == true) {
          showResumeDialogBox(
              "Congratulation! You've earn one more chance!",
              "Resume");
        }
      }
    };
    await RewardedVideoAd.instance.load(
        adUnitId: GoogleAdManager.rewardedVideoAdId, targetingInfo: targetingInfo);
  }


  BuildContext _dialogBoxContext;
  Widget showGameOverDialog(context) {

    GoogleAdManager().showDQCExitInterstitialAd(0.0, AnchorType.bottom);
    this._dialogBoxContext = context;
    return WillPopScope(
      onWillPop: _onWillPopScope,
      child: Dialog(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          backgroundImage: AssetImage(ImageResources.sadEmoji),
                          radius: 24,
                        ),
                      ),
                      Text("Wrong answer!",
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 21,
                              fontFamily: 'Raleway',
                              color: Colors.black)),
                    ],
                  ),
                  Visibility(visible: showQuizDisplay() ,child: SingleChildScrollView(child: displayQuizDetails(context))),
                  Visibility(
                    visible: !_chancedUsed,
                    child: Text("Watch video to get one more chance!",
                        style: TextStyle(
                            fontFamily: 'Raleway',  color:Colors.blueGrey,fontWeight: FontWeight.w500)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:16.0,bottom: 16.0),
                    child: Row(
                      mainAxisAlignment: _chancedUsed
                          ? MainAxisAlignment.center
                          : MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        FlatButton(
                            child: Text("Exit",
                                style: TextStyle(color: Colors.red,fontFamily: 'Raleway', fontWeight:FontWeight.w600,fontSize: 18)),
                            onPressed: () {
                              saveScore(_isGameWon);
                              GoogleAdManager().disposeDQCInterstitialAd();
                              Navigator.of(context).pop();
                              Navigator.of(this.context).pop();
                            }),
                        Visibility(
                          visible: !_chancedUsed,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: FlatButton(
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: new BoxDecoration(
                                      color: Colors.green,
                                      border: new Border.all(
                                          color: Colors.white, width: 1),
                                      borderRadius: new BorderRadius.all(
                                          Radius.circular(40.0))),
                                  child: Row(
                                    children: <Widget>[
                                      Icon(Icons.videocam, color: Colors.white),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 4.0),
                                        child: Text("Watch",
                                            style: TextStyle(
                                                color: Colors.white, fontSize: 18)),
                                      ),
                                    ],
                                  ),
                                ),
                                onPressed: () {
                                  showVideoAd();
                                }),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }


  /// Update score to the leaderboard
  void updateScoreLeaderboard(){
    LeaderboardManager leaderboardManager = LeaderboardManager();
    leaderboardManager.saveForAllTimeScore(UserMemory().getPlayer().membershipId,_totalScore, (value){
      print("All Time score saved");
    });
    leaderboardManager.saveForWeeklyScore(UserMemory().getPlayer().membershipId, _totalScore,(value){
      print("Weekly score saved");
    });
  }
}
