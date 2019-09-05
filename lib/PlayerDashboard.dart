import 'package:flutter/material.dart';
import 'package:surprize/Memory/UserMemory.dart';
import 'package:surprize/Models/Player.dart';
import 'package:surprize/SurprizeNavigationDrawerWidget.dart';
import 'CustomUpcomingEventsWidget.dart';
import 'CustomWidgets/CustomNewsCardWidget.dart';
import 'CustomWidgets/CustomRoundedEdgeButton.dart';
import 'DailyQuizChallengeGamePlayPage.dart';
import 'Helper/AppHelper.dart';

class PlayerDashboard extends StatefulWidget {

  PlayerDashboard();

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return PlayerDashboardState();
  }
}

class PlayerDashboardState extends State<PlayerDashboard>
    with SingleTickerProviderStateMixin {
  double _screenWidth;
  double _screenHeight;

  AnimationController _animationController;

  @override
  void initState() {
    _animationController = new AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animationController.repeat();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _screenWidth = MediaQuery.of(context).size.width;
    _screenHeight = MediaQuery.of(context).size.height;

    return MaterialApp(
        theme: ThemeData(primaryColor: Colors.purple[800]),
        home: Scaffold(
            appBar: AppBar(title: Text("Home")),
            drawer: SurprizeNavigationDrawerWidget(context),
            body: dashboardBody()));
  }

  /// Dashboard body
  Widget dashboardBody() {
    return SingleChildScrollView(
      child: Center(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          //  profileInformationHolder(),
          AppHelper.appSmallHeader("Upcoming events"),
          Container(
            child: Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: CustomUpcomingEventsWidget()),
          ),
          Visibility(visible: true, child: AppHelper.appHeaderDivider()),
          Visibility(visible: true, child: playDailyQuizChallenge(context)),
          AppHelper.appHeaderDivider(),
          AppHelper.appSmallHeader("News"),
          CustomNewsCardWidget(),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: CustomNewsCardWidget(),
          )
        ],
      )),
    );
  }

  /// Play quiz challenge short cut button widget
  Widget playDailyQuizChallenge(context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        children: <Widget>[
          FadeTransition(
            opacity: _animationController,
            child: Text(
              "Game is on !!!",
              style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.redAccent),
            ),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            CustomRoundedEdgeButton(
                onClicked: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            DailyQuizChallengeGamePlayPage())),
                color: Colors.purple[800],
                text: "Play Daily Quiz Challenge")
          ]),
        ],
      ),
    );
  }
}
