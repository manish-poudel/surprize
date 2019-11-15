
import 'package:flutter/material.dart';
import 'package:Surprize/CountDownTimerTypeEnum.dart';
import 'package:Surprize/CustomWidgets/CalendarEventManagement.dart';
import 'package:Surprize/CustomWidgets/CustomCountDownTimerWidget.dart';
import 'package:Surprize/CustomWidgets/CustomTextButtonWidget.dart';
import 'package:Surprize/Helper/AppHelper.dart';
import 'package:Surprize/Resources/ImageResources.dart';
import 'package:Surprize/Resources/StringResources.dart';

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
      debugShowCheckedModeBanner: false,
      home: new Scaffold(
        key: _scaffoldKey,
        body: Container(
            decoration: BoxDecoration(
                image:DecorationImage(image: new AssetImage(ImageResources.appBackgroundImage), fit: BoxFit.cover)
            ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top:8.0),
              child: Center(
                child: Image.asset(ImageResources.dailyQuizChallengeLogo, height: MediaQuery.of(context).size.height * 0.35, width: MediaQuery.of(context).size.width,),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 32.0, right: 32.0),
              child: Text(StringResources.noCurrentGameText, textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 18.0,fontFamily: 'Raleway')),
            ),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: CustomCountDownTimerWidget(true,32,true, countDownDuration,
                  StringResources.countDownTimeString,
                  MediaQuery.of(context).size.height * 0.35,
                  MediaQuery.of(context).size.height * 0.35,
                  Colors.white,
                  Colors.redAccent,
                  CountDownTimeTypeEnum.DAILY_QUIZ_CHALLENGE_NOT_AVAILABLE),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top:16.0, bottom:16.0),
                  child: CustomTextButtonWidget(StringResources.exitButtonText, Colors.red, () => AppHelper.pop(context)),
                ),
                Padding(
                  padding: const EdgeInsets.only(top:16.0, bottom:16.0),
                  child: CustomTextButtonWidget(StringResources.setReminderButtonText, Colors.blue, () => setReminderForTheGame()),
                ),

              ],
            )
          ],
          ),
        )
      ),
    );
  }

}