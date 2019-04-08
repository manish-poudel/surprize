import 'package:flutter/material.dart';
import 'package:surprize/CountDownTimerTypeEnum.dart';
import 'package:surprize/CustomWidgets/CalendarEventManagement.dart';
import 'package:surprize/CustomWidgets/CustomCountDownTimerWidget.dart';
import 'package:surprize/CustomWidgets/CustomTextButtonWidget.dart';
import 'package:surprize/Helper/AppColor.dart';
import 'package:surprize/Helper/AppHelper.dart';
import 'package:surprize/Resources/ImageResources.dart';
import 'package:surprize/Resources/StringResources.dart';

class DailyQuizChallengeNotAvailablePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return DailyQuizChallengeNotAvailablePageState();
  }

}

class DailyQuizChallengeNotAvailablePageState extends State<DailyQuizChallengeNotAvailablePage>{

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  /*
  Set reminder for the daily quiz challenge game
   */
  void setReminderForTheGame(){
    // adding event
    CalendarEventManagement().addEventToCalendar(StringResources.setReminderTitle,
        StringResources.setReminderDescription,
        DateTime.now(),
        DateTime.now()).then((value){
    }).catchError((error){
      print(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: new Scaffold(
        key: _scaffoldKey,
        backgroundColor: AppColor.colorPrimary,
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
                child: Text(StringResources.noCurrentGameText, style: TextStyle(color: Colors.white, fontSize: 18.0,fontFamily: 'Roboto')),
              ),
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: CustomCountDownTimerWidget(true,new Duration(hours: 00, minutes: 00, seconds: 60), StringResources.countDownTimeString, 180.0, 180.0,
                    Colors.blueAccent, Colors.white, CountDownTimeTypeEnum.DAILY_QUIZ_CHALLENGE_NOT_AVAILABLE),
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