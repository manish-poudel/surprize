
import 'package:Surprize/DQCQuestionRetrievePage.dart';
import 'package:Surprize/Helper/AppHelper.dart';
import 'package:Surprize/Resources/ImageResources.dart';
import 'package:Surprize/Resources/StringResources.dart';
import 'package:flutter/material.dart';

import '../CountDownTimerTypeEnum.dart';
import 'CustomCountDownTimerWidget.dart';

class GameCards extends StatefulWidget {

  bool _played;
  DateTime _dateTime;
  GlobalKey _scaffoldKey;

  GameCards(this._played, this._dateTime,this._scaffoldKey);

  @override
  _GameCardsState createState() => _GameCardsState();
}

class _GameCardsState extends State<GameCards> with TickerProviderStateMixin{

  double mainTitleTextSize;
  double mainSubTitleTextSize;
  double mainTitleTextSizeTwo;
  AnimationController _dailyQuizChallengeAnimationController;
  AnimationController _fadeInAnimation;

  Animation<Offset> _dailyQuizChallengeAnimationOffset;
  Animation<Offset> _dailyQuizChallengeAnimationOffsetTwo;

  @override
  void initState() {
    super.initState();
    _dailyQuizChallengeAnimationController = new AnimationController(vsync: this, duration: Duration(milliseconds:750));
    _fadeInAnimation = new AnimationController(vsync: this, duration: Duration(seconds: 1));

    _dailyQuizChallengeAnimationOffset = Tween<Offset>(begin: Offset(1.0, 0.0), end:Offset.zero ).animate(_dailyQuizChallengeAnimationController);
    _dailyQuizChallengeAnimationOffsetTwo = Tween<Offset>(begin: Offset(0.0, -1.0), end:Offset.zero ).animate(_dailyQuizChallengeAnimationController);

    Future.delayed(Duration(seconds:1)).then((_){
      _dailyQuizChallengeAnimationController.forward();
      _fadeInAnimation.repeat(reverse: true, period: Duration(seconds: 1));
    });
  }


  @override
  Widget build(BuildContext context) {
    mainTitleTextSize = (MediaQuery.of(context).size.height * 0.04).toDouble();
    mainTitleTextSizeTwo = (MediaQuery.of(context).size.height * 0.02).toDouble();
    mainSubTitleTextSize = (MediaQuery.of(context).size.height * 0.02).toDouble();
    return GestureDetector(
      onTap: () {
        !widget._played?AppHelper.cupertinoRoute(context, QuestionRetrievePage()):AppHelper.showSnackBar("You have already played today's Daily Quiz Challenge!", widget._scaffoldKey);
      },
      child: Center(
        child: Column(
          children: <Widget>[
            Card(
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Container(
                padding: EdgeInsets.all(1),
                decoration: new BoxDecoration(
                  color: Colors.purple[700]

                ),
                child: Card(
                  color: Colors.purple[600],
                  child: Container(
                    decoration: BoxDecoration(
                        border: new Border.all(color: Colors.purple[600], width: 1),
                        borderRadius:  new BorderRadius.all(Radius.circular(6.0))
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Container(
                            width: 80,
                            height: 80,
                            decoration: new BoxDecoration(
                                shape: BoxShape.circle,
                                image: new DecorationImage(
                                    fit: BoxFit.fill,
                                    image:AssetImage(ImageResources.moneyBag)
                                )
                            )),
                          Padding(
                            padding: const EdgeInsets.only(left:16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                SlideTransition(
                                  position:_dailyQuizChallengeAnimationOffsetTwo,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top:8.0),
                                    child: Text("DAILY QUIZ",style: TextStyle(color: Colors.amber,fontFamily: 'Mosco',fontSize: 32)),
                                  ),
                                ),
                                SlideTransition(
                                    position: _dailyQuizChallengeAnimationOffset,
                                    child: Text("CHALLENGE",style: TextStyle(color: Colors.yellowAccent,fontFamily: 'Mosco',fontSize: 28))),

                               !widget._played?FadeTransition(
                                  opacity: _fadeInAnimation,
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 4.0,bottom: 8.0),
                                        child: Text("Tap to play !",
                                            style: TextStyle(color: Colors.white,
                                                fontFamily: 'Mosco',
                                                fontSize: 18)),
                                      ),
                                    ):Padding(
                                   padding: const EdgeInsets.only(top: 4.0),
                                   child:Column(
                                 children: <Widget>[
                                   Text("Next game on",
                                       style: TextStyle(color: Colors.white,
                                           fontFamily: 'Raleway',
                                           fontSize: 18)),
                                   Padding(
                                     padding: const EdgeInsets.only(left:2.0,bottom: 8.0),
                                     child: CustomCountDownTimerWidget(false,18,true, widget._dateTime.difference(DateTime.now()),
                                         StringResources.countDownTimeString,
                                         64,
                                         250,
                                         Colors.white,
                                         Colors.redAccent,
                                         CountDownTimeTypeEnum.DAILY_QUIZ_CHALLENGE_NOT_AVAILABLE),
                                   ),

                                 ],
                               ))
                              ],
                            ),
                          )
                      ],
                    ),
                  ),
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              elevation: 1,
              margin: EdgeInsets.all(10),
            ),
          ],
        ),
      ),
    );
  }
}
