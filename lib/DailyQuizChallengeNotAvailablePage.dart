import 'package:flutter/material.dart';
import 'package:surprize/CountDownTimerTypeEnum.dart';
import 'package:surprize/CustomWidgets/CalendarEventManagement.dart';
import 'package:surprize/CustomWidgets/CustomCountDownTimerWidget.dart';
import 'package:surprize/CustomWidgets/CustomTextButtonWidget.dart';
import 'package:surprize/Helper/AppHelper.dart';
import 'package:surprize/Resources/ImageResources.dart';
import 'package:surprize/Resources/StringResources.dart';

class DailyQuizChallengeNotAvailablePage extends StatefulWidget {

  DateTime _dateTime;
  DailyQuizChallengeNotAvailablePage(this._dateTime);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return DailyQuizChallengeNotAvailablePageState();
  }

}

class DailyQuizChallengeNotAvailablePageState extends State<DailyQuizChallengeNotAvailablePage>{

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Duration countDownDuration;
  /*
  Set reminder for the daily quiz challenge game
   */
  void setReminderForTheGame(){

    // adding event
    CalendarEventManagement().addEventToCalendar(StringResources.setReminderTitle,
        StringResources.setReminderDescription,
        widget._dateTime,
        widget._dateTime).then((value){
    }).catchError((error){
      print(error);
    });
  }

  @override
  void initState() {
    super.initState();
    DateTime currentDateTime = DateTime.now();
    countDownDuration = widget._dateTime.difference(currentDateTime);
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: new Scaffold(
        key: _scaffoldKey,
        body: Container(
            decoration: BoxDecoration(
                image:DecorationImage(image: new AssetImage(ImageResources.appBackgroundImage), fit: BoxFit.cover)
            ),
          child: SingleChildScrollView(
            child: Column(children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top:8.0),
                child: Center(
                  child: Image.asset(ImageResources.dailyQuizChallengeLogo, height: 220, width: 320,),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 32.0, right: 32.0),
                child: Text(StringResources.noCurrentGameText, textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 18.0,fontFamily: 'Roboto')),
              ),
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: CustomCountDownTimerWidget(true, countDownDuration,
                    StringResources.countDownTimeString,
                    180.0,
                    180.0,
                    Colors.white,
                    Colors.redAccent,
                    CountDownTimeTypeEnum.DAILY_QUIZ_CHALLENGE_NOT_AVAILABLE),
              ),
              Padding(
                padding: const EdgeInsets.only(top:16.0, bottom:16.0),
                child: CustomTextButtonWidget(StringResources.setReminderButtonText, Colors.blue, () => setReminderForTheGame()),
              ),
              Padding(
                padding: const EdgeInsets.only(top:16.0, bottom:8.0),
                child: CustomTextButtonWidget(StringResources.exitButtonText, Colors.red, () => AppHelper.pop(context)),
              )
            ],
            ),
          ),
        )
      ),
    );
  }

}