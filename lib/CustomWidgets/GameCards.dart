
import 'package:Surprize/Resources/ImageResources.dart';
import 'package:flutter/material.dart';


class GameCards extends StatefulWidget {
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
    mainTitleTextSize = (MediaQuery.of(context).size.height * 0.06).toDouble();
    mainTitleTextSizeTwo = (MediaQuery.of(context).size.height * 0.04).toDouble();
    mainSubTitleTextSize = (MediaQuery.of(context).size.height * 0.03).toDouble();
    return Center(
      child: Column(
        children: <Widget>[
          Card(
            semanticContainer: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Container(
              padding: EdgeInsets.all(1),
              decoration: new BoxDecoration(
                color: Colors.purple[700]
            /*      image: new DecorationImage(
                      fit: BoxFit.fill,
                      image:AssetImage(ImageResources.appBackgroundImage)
                  )*/
              ),
              height: MediaQuery.of(context).size.height * 0.2,
              width: MediaQuery.of(context).size.width,
              child: Card(
                color: Colors.purple[600],
                child: Container(
                  decoration: BoxDecoration(
                      border: new Border.all(color: Colors.purple[600], width: 1),
                      borderRadius:  new BorderRadius.all(Radius.circular(6.0))
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                          width: MediaQuery.of(context).size.width * 0.29,
                          height: MediaQuery.of(context).size.width * 0.29,
                          decoration: new BoxDecoration(
                            color: Colors.green,
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
                                  child: Text("DAILY QUIZ",style: TextStyle(color: Colors.amber,fontFamily: 'Mosco',fontSize: mainTitleTextSizeTwo)),
                                ),
                              ),
                              SlideTransition(
                                  position: _dailyQuizChallengeAnimationOffset,
                                  child: Text("CHALLENGE",style: TextStyle(color: Colors.yellowAccent,fontFamily: 'Mosco',fontSize: mainTitleTextSize))),

                             FadeTransition(
                                opacity: _fadeInAnimation,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 4.0),
                                      child: Text("Tap to play !",
                                          style: TextStyle(color: Colors.white,
                                              fontFamily: 'Mosco',
                                              fontSize: mainSubTitleTextSize)),
                                    ),
                                  )
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
    );
  }
}
