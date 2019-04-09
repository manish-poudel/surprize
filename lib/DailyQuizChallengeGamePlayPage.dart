import 'dart:async';

import 'package:flutter/material.dart';
import 'package:surprize/CountDownTimerTypeEnum.dart';
import 'package:surprize/CustomWidgets/CustomCountDownTimerWidget.dart';
import 'package:surprize/CustomWidgets/DailyQuizChallenge/CustomQuizAnswerButtonWidget.dart';
import 'package:surprize/CustomWidgets/DailyQuizChallenge/CustomQuizQuestionHolderWidget.dart';
import 'package:surprize/DailyQuizChallengeScoreSummaryPage.dart';
import 'package:surprize/Firestore/FirestoreOperations.dart';
import 'package:surprize/Helper/AppHelper.dart';
import 'package:surprize/Helper/SoundHelper.dart';
import 'package:surprize/Models/DailyQuizChallenge/DailyQuizChallengeQnA.dart';
import 'package:surprize/Models/DailyQuizChallenge/QuizState.dart';
import 'package:surprize/Resources/FirestoreResources.dart';
import 'package:surprize/Resources/ImageResources.dart';
import 'package:surprize/Resources/SoundResources.dart';
import 'package:surprize/Resources/StringResources.dart';

class DailyQuizChallengeGamePlayPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return DailyQuizChallengeGamePlayPageState();
  }
}

class DailyQuizChallengeGamePlayPageState extends State<DailyQuizChallengeGamePlayPage> {

  static double countDownTimerHeight = 120.0;
  static double countDownTimerWidth = 200.0;

 // init button code value
 static final int quizFirstButtonCode = 1;
 static final int quizSecondButtonCode = 2;
 static final int quizThirdButtonCode = 3;
 static final int quizFourButtonCode = 4;

  QuizState _quizState;

  List<DailyQuizChallengeQnA> _dailyQuizChallengeQnAList;
  DailyQuizChallengeQnA _quizChallengeQnA;

  CustomQuizQuestionHolderWidget _quizQuestion;
  CustomQuizAnswerButtonWidget _firstAnswer;
  CustomQuizAnswerButtonWidget _secondAnswer;
  CustomQuizAnswerButtonWidget _thirdAnswer;
  CustomQuizAnswerButtonWidget _fourthAnswer;

  CustomCountDownTimerWidget _customCountDownTimerWidget = CustomCountDownTimerWidget(true, new Duration(seconds: 10),
      "", countDownTimerHeight, countDownTimerWidth,
      Colors.white,
      Colors.red[900],
      CountDownTimeTypeEnum.DAILY_QUIZ_CHALLENGE_GAME_PLAY);

  bool _clickableButton = true;
  bool _hasQuizStateBeenRetrieved = false;
  bool _hasQuizListBeenRetrieved = false;
  bool _isGameFinished = false;
  bool _hasMusicStarted = false;

  int currentIndex = 0;

 SoundHelper _soundHelper;

 int _totalScore = 0;

  static final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();


  @override
  void initState() {
    super.initState();
    initQuizQuestion();
   listenForQuizState();
   _soundHelper = SoundHelper();

  }



  @override
  void dispose() {
    super.dispose();
    if(_soundHelper != null) {
      _soundHelper.stopSound();
    }
  }

  void setButtonClickable(bool clickable){
    _clickableButton = clickable;
  }

  /*
  Initialize question and answer for the first time
   */
  void initializeQuestionAndAnswer(int currentIndex){

    // setting quiz question
    _quizQuestion = CustomQuizQuestionHolderWidget(_dailyQuizChallengeQnAList[currentIndex].question);

    // Setting answer button for the quiz
    _firstAnswer =  CustomQuizAnswerButtonWidget(onButtonSelect, quizFirstButtonCode, _dailyQuizChallengeQnAList[currentIndex].answers.elementAt(0),
        EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0, bottom: 8));

    _secondAnswer = CustomQuizAnswerButtonWidget(onButtonSelect, quizSecondButtonCode,   _dailyQuizChallengeQnAList[currentIndex].answers.elementAt(1),
        EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0, bottom: 8));

    _thirdAnswer = CustomQuizAnswerButtonWidget(onButtonSelect, quizThirdButtonCode,  _dailyQuizChallengeQnAList[currentIndex].answers.elementAt(2),
        EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0, bottom: 8));

    _fourthAnswer= CustomQuizAnswerButtonWidget(onButtonSelect, quizFourButtonCode,  _dailyQuizChallengeQnAList[currentIndex].answers.elementAt(3),
        EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0, bottom: 8.0));
  }

  /*
  Check if given answer is correct answer
   */
  bool isRightAnswer(value){
    return value == _dailyQuizChallengeQnAList[currentIndex].rightAnswer;
  }

  /*
  Init quiz
   */
  void initQuizQuestion() {
    // Listen for the quiz question and answers.
    FirestoreOperations().getNestedCollectionReference(
        FirestoreResources.collectionQuizName,
        FirestoreResources.collectionQuestionAndAnswersList,
        "h9Y2waV1lifvEjOW2ajW").snapshots().listen((querySnapshot) {

      setState(() {
         _dailyQuizChallengeQnAList = querySnapshot.documents.map((documentSnapshot) =>
                DailyQuizChallengeQnA.fromMap(documentSnapshot.data)).toList();
         initializeQuestionAndAnswer(currentIndex);
        _hasQuizListBeenRetrieved = true;
         setButtonClickable(true);
      });

    });
  }

  /*
  Update question and answer
   */
  void updateQuestionAndAnswer(){

    // Update answer
    _quizQuestion.updateQuestion(_dailyQuizChallengeQnAList[currentIndex].question);

    // Update question
    _firstAnswer.setQuizAnswer(_dailyQuizChallengeQnAList[currentIndex].answers.elementAt(0));
    _secondAnswer.setQuizAnswer(_dailyQuizChallengeQnAList[currentIndex].answers.elementAt(1));
    _thirdAnswer.setQuizAnswer(_dailyQuizChallengeQnAList[currentIndex].answers.elementAt(2));
    _fourthAnswer.setQuizAnswer(_dailyQuizChallengeQnAList[currentIndex].answers.elementAt(3));
  }

  /**
   * Listen for the quiz if its on or not.
   */
  void listenForQuizState() {
    // Listen for the quiz state
    FirestoreOperations().getSnapshotStream(
        FirestoreResources.collectionQuizName, "h9Y2waV1lifvEjOW2ajW")
        .listen((snapshot) {
      setState(() {
        _quizState = QuizState.fromMap(snapshot.data);
        print(_quizState.isSwitchOn);
        if (_quizState.isSwitchOn) {
          _hasQuizStateBeenRetrieved = true;

          // Get current quiz value
          _dailyQuizChallengeQnAList.forEach((dailyQuizChallengeQnA){
            if(dailyQuizChallengeQnA.id == _quizState.currentQuizId){
              _quizChallengeQnA = dailyQuizChallengeQnA;
            }
          });

        }
        if (!_quizState.isSwitchOn) {
          _hasQuizStateBeenRetrieved = false;
        }
      });
    });
  }

  /*
  Handle button click event
   */
  void onButtonSelect(value, CustomQuizAnswerButtonWidget button) {
    if(_clickableButton) {
      if (isRightAnswer(value)) {
        _totalScore = _totalScore + 10;
        AppHelper.showSnackBar("correct", _scaffoldKey);
      }
      else{
        AppHelper.showSnackBar("wrong", _scaffoldKey);
      }
        setButtonClickable(false);
        button.changeColor(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: Scaffold(
        key: _scaffoldKey,
        body: Container(
          height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                image:DecorationImage(image: new AssetImage(ImageResources.appBackgroundImage),fit: BoxFit.fill)
            ),
          child: (_hasQuizListBeenRetrieved && _hasQuizStateBeenRetrieved ? ifAllQuizValueHasBeenSet() : ifQuizValueIsInRetrievedMode()),
        ),
      ),
    );
  }

  /*
  Keep time track
   */
  void keepTimeTrack(int second) async {
    Future.delayed(Duration(seconds: second), (){
      setState(() {
        if((currentIndex + 1) != _dailyQuizChallengeQnAList.length) {
          currentIndex = currentIndex + 1;
          updateQuestionAndAnswer();
          resetButtonColor();
          setButtonClickable(true);
          _customCountDownTimerWidget.repeatCountdown();
        }
        else{
          _customCountDownTimerWidget.stopCountdown();
          _isGameFinished = true;
          setButtonClickable(false);
          AppHelper.showSnackBar("Game has finished", _scaffoldKey);
          goToScoreSummaryPage();
        }
      });
    }).catchError((error){
      print(error);
    });
  }

  /*
  Reset button color;
   */
  void resetButtonColor(){
    _firstAnswer.resetColor();
    _secondAnswer.resetColor();
    _thirdAnswer.resetColor();
    _fourthAnswer.resetColor();
  }

  /*
  Widget for quiz play
   */
    Widget ifAllQuizValueHasBeenSet(){

      if(!_hasMusicStarted) {
        _soundHelper.playBackgroundSound(SoundResources.dailyQuizChallengeBackgroundMusic.split('/')[1],
            SoundResources.dailyQuizChallengeBackgroundMusic);
        _hasMusicStarted = true;
      }

      if(!_isGameFinished) {
        keepTimeTrack(10);
      }
      
      return  SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top:42.0),
          child: Center(
          child: Text(
            StringResources.headingText,
            style: TextStyle(color: Colors.white, fontSize:24, fontWeight: FontWeight.w500),
          ),
      ),
        ),
            Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: _customCountDownTimerWidget),

            Stack(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 32, left:0.0),
                  child: Center(
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(color: Colors.purple, shape: BoxShape.circle),
                      child: Center(
                        child: Text(
                          (currentIndex + 1).toString(),
                          style: TextStyle(color: Colors.white, fontSize:24, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top:64, left: 8.0, right: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color:Colors.black26,
                              offset: Offset(1.0, 3.0),
                              blurRadius: 21.0
                          ),
                        ],
                        border: new Border.all(color: Colors.purple, width: 1),
                        borderRadius:  new BorderRadius.all(Radius.circular(21.0))
                    ),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left:4.0, right: 4.0, top: 4.0),
                          child: _quizQuestion,
                        ),

                        _firstAnswer,
                        _secondAnswer,
                        _thirdAnswer,
                        _fourthAnswer,

                      ],
                    ),
                  ),
                )
              ],
            )],
        ),
      );
  }

  // Widget if value is in retrieved mode
  Widget ifQuizValueIsInRetrievedMode(){
    return Padding(
      padding: const EdgeInsets.only(top:240.0),
      child: Center(
        child: Column(
            children: <Widget>[
          CircularProgressIndicator(backgroundColor: Colors.redAccent,),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(StringResources.getReadyForQuizText, style: TextStyle(color: Colors.white, fontSize: 21)),
          )
        ]),
      ),
    );
}

void goToScoreSummaryPage(){
  Navigator.pushReplacement(context, MaterialPageRoute(
    builder: (context) => DailyQuizChallengeScoreSummaryPage(_totalScore),
  ));
}

}
