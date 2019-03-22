import 'package:flutter/material.dart';
import 'package:surprize/CountDownTimerTypeEnum.dart';
import 'package:surprize/CustomWidgets/CustomCountDownTimerWidget.dart';
import 'package:surprize/CustomWidgets/DailyQuizChallenge/CustomQuizAnswerButtonWidget.dart';
import 'package:surprize/CustomWidgets/DailyQuizChallenge/CustomQuizQuestionHolderWidget.dart';
import 'package:surprize/Helper/AppColor.dart';
import 'package:surprize/Helper/AppHelper.dart';

class DailyQuizChallengeGamePlayPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return DailyQuizChallengeGamePlayPageState();
  }
}

class DailyQuizChallengeGamePlayPageState extends State<DailyQuizChallengeGamePlayPage> {
   bool _hasButtonBeenPressed = false;
  static final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();

  void onButtonSelect(value, CustomQuizAnswerButtonWidget button) {
    if(!_hasButtonBeenPressed) {
      if (value == 1) {
        AppHelper.showSnackBar("correct", _scaffoldKey);
      }
      setState(() {
        _hasButtonBeenPressed = true;
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
        backgroundColor: AppColor.colorPrimary,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 32.0),
                child: Text(
                  "1",
                  style: TextStyle(color: Colors.white, fontSize: 48),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: CustomCountDownTimerWidget(
                    new Duration(seconds: 15),
                    "",
                    120.0,
                    200.0,
                    Colors.red,
                    Colors.redAccent,
                    CountDownTimeTypeEnum.DAILY_QUIZ_CHALLENGE_GAME_PLAY),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: CustomQuizQuestionHolderWidget(
                    "Who is the president of USA"),
              ),
              CustomQuizAnswerButtonWidget(
                  onButtonSelect,
                  1,
                  "Donald trump",
                  EdgeInsets.only(
                      top: 16.0, left: 16.0, right: 16.0, bottom: 8)),
              CustomQuizAnswerButtonWidget(
                  onButtonSelect,
                  2,
                  "KP Oli",
                  EdgeInsets.only(
                      top: 8.0, left: 16.0, right: 16.0, bottom: 8)),
              CustomQuizAnswerButtonWidget(
                  onButtonSelect,
                  3,
                  "Narendra modi",
                  EdgeInsets.only(
                      top: 8.0, left: 16.0, right: 16.0, bottom: 8)),
              CustomQuizAnswerButtonWidget(
                  onButtonSelect,
                  4,
                  "Barack Obama",
                  EdgeInsets.only(
                      top: 8.0, left: 16.0, right: 16.0, bottom: 8))
            ],
          ),
        ),
      ),
    );
  }
}
