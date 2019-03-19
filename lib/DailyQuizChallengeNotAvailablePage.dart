import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: new Scaffold(
        backgroundColor: AppColor.colorPrimary,
        body: SingleChildScrollView(
          child: Column(children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 16.0,left: 48.0),
              child: Image.asset(ImageResources.dailyQuizChallengeLogo),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0,left: 32.0, right: 32.0),
              child: Text(StringResources.noCurrentGameText, style: TextStyle(color: Colors.white, fontSize: 18.0,fontFamily: 'Roboto')),
            ),
            Padding(
              padding: const EdgeInsets.only(top:16.0, bottom:16.0),
              child: CustomTextButtonWidget(StringResources.setReminderButtonText, Colors.blue, () => {}),
            ),
            CustomCountDownTimerWidget(new Duration(hours: 00, minutes: 00, seconds: 60), StringResources.countDownTimeString),
            Padding(
              padding: const EdgeInsets.only(top:32.0, bottom:8.0),
              child: CustomTextButtonWidget(StringResources.exitButtonText, Colors.red, () => AppHelper.pop(context)),
            )
          ],
          ),
        )
      ),
    );
  }

}