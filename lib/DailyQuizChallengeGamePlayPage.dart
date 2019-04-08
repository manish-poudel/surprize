import 'package:flutter/material.dart';
import 'package:surprize/CountDownTimerTypeEnum.dart';
import 'package:surprize/CustomWidgets/CustomCountDownTimerWidget.dart';
import 'package:surprize/CustomWidgets/DailyQuizChallenge/CustomQuizAnswerButtonWidget.dart';
import 'package:surprize/CustomWidgets/DailyQuizChallenge/CustomQuizQuestionHolderWidget.dart';
import 'package:surprize/Firestore/FirestoreOperations.dart';
import 'package:surprize/Helper/AppColor.dart';
import 'package:surprize/Helper/AppHelper.dart';
import 'package:surprize/Models/DailyQuizChallenge/DailyQuizChallengeQnA.dart';
import 'package:surprize/Models/DailyQuizChallenge/QuizState.dart';
import 'package:surprize/Resources/FirestoreResources.dart';
import 'package:surprize/Resources/ImageResources.dart';

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
  DailyQuizChallengeQnA _quizChallengeQnA;
  List<DailyQuizChallengeQnA> _dailyQuizChallengeQnAList;

  String quizFirstAnswerOption = 'Donald Trump';
  String quizSecondAnswerOption = 'KP Oli';
  String quizThirdAnswerOption = 'Narendra Modi';
  String quizFourthAnswerOption = 'Barack Obama';

  bool _clickableButton = true;
  bool _hasQuizStateBeenRetrieved = false;
  bool _hasQuizListBeenRetrieved = false;

  static final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();


  @override
  void initState() {
    super.initState();
    initQuizQuestion();
    listenForQuizState();
  }


  void setButtonClickable(bool clickable){
    _clickableButton = clickable;
  }

  /*
  Start quiz
   */
  void startQuiz(){
  }

  /*
  Stop quiz
   */
  void stopQuiz(){

  }

  /*
  Check if given answer is correct answer
   */
  bool isRightAnswer(value){
    return value == _quizChallengeQnA.rightAnswer.toString();
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
        _hasQuizListBeenRetrieved = true;
      });

    });
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
          startQuiz();

          // Get current quiz value
          _dailyQuizChallengeQnAList.forEach((dailyQuizChallengeQnA){
            if(dailyQuizChallengeQnA.id == _quizState.currentQuizId){
              _quizChallengeQnA = dailyQuizChallengeQnA;
            }
          });

        }
        if (!_quizState.isSwitchOn) {
          _hasQuizStateBeenRetrieved = false;
          setButtonClickable(true);
          //stopQuiz();
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
        AppHelper.showSnackBar("correct", _scaffoldKey);
      }
      setState(() {
        setButtonClickable(false);
        button.changeColor(value);
      });
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
          child: (_hasQuizStateBeenRetrieved && _hasQuizListBeenRetrieved ? ifAllQuizValueHasBeenSet() : ifQuizValueIsInRetrievedMode()),
        ),
      ),
    );
  }

  /*
  Widget for quiz play
   */
    Widget ifAllQuizValueHasBeenSet(){
      return  SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top:42.0),
          child: Center(
          child: Text(
            "Let's play Daily quiz challenge!",
            style: TextStyle(color: Colors.white, fontSize:24, fontWeight: FontWeight.w500),
          ),
      ),
        ),
            Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: CustomCountDownTimerWidget(true, new Duration(seconds: 10),
                    "", countDownTimerHeight, countDownTimerWidth,
                    Colors.white,
                    Colors.red[900],
                    CountDownTimeTypeEnum.DAILY_QUIZ_CHALLENGE_GAME_PLAY)),

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
                          "4",
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
                          child: CustomQuizQuestionHolderWidget(
                              _quizChallengeQnA.question),
                        ),

                        CustomQuizAnswerButtonWidget(onButtonSelect, quizFirstButtonCode, _quizChallengeQnA.answers.elementAt(0),
                            EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0, bottom: 8)),

                        CustomQuizAnswerButtonWidget(onButtonSelect, quizSecondButtonCode, _quizChallengeQnA.answers.elementAt(1),
                            EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0, bottom: 8)),

                        CustomQuizAnswerButtonWidget(onButtonSelect, quizThirdButtonCode, _quizChallengeQnA.answers.elementAt(2),
                            EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0, bottom: 8)),

                        CustomQuizAnswerButtonWidget(onButtonSelect, quizFourButtonCode, _quizChallengeQnA.answers.elementAt(3),
                            EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0, bottom: 8.0))
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
            child: Text("Get Ready! Question will be on your screen soon", style: TextStyle(color: Colors.white, fontSize: 21)),
          )
        ]),
      ),
    );
}

}
