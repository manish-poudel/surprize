import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:surprize/CustomWidgets/CustomSliverAppBarWidget.dart';
import 'package:surprize/CustomWidgets/CustomTextButtonWidget.dart';
import 'package:surprize/DailyQuizChallengePage.dart';
import 'package:surprize/Helper/AppHelper.dart';
import 'package:surprize/Resources/ImageResources.dart';

class PlayerDashboard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return PlayerDashboardState();
  }
}

class PlayerDashboardState extends State<PlayerDashboard> {
  double _screenWidth;
  double _screenHeight;

  @override
  void initState() {
    super.initState();
  }

  /*
  Log out user
   */
  void logoutUser() {
    FirebaseAuth.instance.signOut().then((value) {
      try {
        AppHelper.goToPage(context, true, '/loginPage');
      } catch (error) {
        print(error);
      }
    }).catchError((error) {
      print(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    _screenWidth = MediaQuery.of(context).size.width;
    _screenHeight = MediaQuery.of(context).size.height;
    // TODO: implement build
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.purple[800]),
      home: Scaffold(
          drawer: Drawer(
            child: Container(
              decoration: BoxDecoration(color: Colors.purple[800]),
              child: drawerContent(),
            ),
          ),
          body: Container(
            color: Colors.grey[50],
            height: MediaQuery.of(context).size.height,
            child: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  CustomSliverAppBarWidget(sliverTitle(), sliverBackground())
                ];
              },
              body: SingleChildScrollView(
                child: Center(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    //  profileInformationHolder(),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text("Upcoming events",
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              color: Colors.black54,
                              fontSize: 18,
                              fontWeight: FontWeight.w500)),
                    ),
                    eventCard(),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Container(
                        height: 8,
                        color: Colors.grey[200],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text("News ",
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              color: Colors.black54,
                              fontSize: 18,
                              fontWeight: FontWeight.w500)),
                    ),
                    newsCard()
                  ],
                )),
              ),
            ),
          )),
    );
  }

  /*
  Sliver Appbar background
   */
  Widget sliverBackground() {
    return Padding(
      padding: const EdgeInsets.only(top: 72.0),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  textWithIcon(Icons.person, "Manish Poudel"),
                ],
              )),
            )
          ],
        ),
      ),
    );
  }

  /*
  Sliver app bar title
   */
  Widget sliverTitle() {
    return Row(
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(left: (this._screenWidth / 2) - 100),
            child: Text("Home",
                style: TextStyle(
                    fontFamily: 'Roboto', fontSize: 24, color: Colors.white)))
      ],
    );
  }

  /*
  Text with icon
   */
  Widget textWithIcon(IconData icon, String text){
    return    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(icon, color: Colors.white),
        Padding(
          padding: const EdgeInsets.only(left:4.0),
          child: Text(
           text,
            style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 21,
                color: Colors.white),
          ),
        ),
      ],
    );
  }
  Widget profileInformationHolder() {
    return Container(
        decoration: BoxDecoration(color: Colors.purple[300]),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: <Widget>[
              Expanded(
                  child: Text("Score: 10",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'Roboto'))),
              Expanded(
                  child: Text("Rank: 10",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'Roboto'))),
              Container(
                  decoration: new BoxDecoration(
                      border: new Border.all(color: Colors.white, width: 1),
                      borderRadius:
                          new BorderRadius.all(Radius.circular(40.0))),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 4.0, right: 4, top: 1.0, bottom: 1.0),
                    child: Text("Visit profile",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontFamily: 'Roboto')),
                  )),
            ],
          ),
        ));
  }

  Widget drawerContent() {
    return ListView(
      children: <Widget>[
        flatButtonWithRoute(
            () => goToPage('/dailyQuizChallengeNotAvailablePage'), 'No quiz'),
        Padding(
          padding: const EdgeInsets.only(top: 2.0),
          child: flatButtonWithRoute(
              () => goToPage('/dailyQuizChallengeGamePlayPage'),
              "Quiz available"),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 2.0),
          child: flatButtonWithRoute(
              () => DailyQuizChallengePage().openPage(context), "Play quiz"),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 2.0),
          child: flatButtonWithRoute(
              () => goToPage('/dailyQuizChallengeScoreSummaryPage'),
              "Quiz summary page"),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 2.0),
          child: flatButtonWithRoute(() => logoutUser(), "Log out"),
        ),
      ],
    );
  }

  /*
  Go to page
   */
  void goToPage(String pageName) {
    AppHelper.goToPage(context, false, pageName);
  }

  /*
  Button text widget
   */
  Widget buttonText(String text) {
    return Text(text,
        style:
            TextStyle(fontFamily: 'Roboto', color: Colors.white, fontSize: 21));
  }

  Widget flatButtonWithRoute(Function function, String text) {
    return Container(
      child: ListTile(
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.white),
        title: FlatButton(onPressed: function, child: buttonText(text)),
      ),
    );
  }


  /*
  Create news card
   */
  Widget newsCard(){
    return Padding(
      padding: const EdgeInsets.only(left:8.0, right: 8.0),
      child: Container(
        width: _screenWidth,
        child:Card(
        color: Colors.grey[100],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Welcome to the new area of Surprize",  style: TextStyle(fontSize: 21, fontWeight: FontWeight.w500),),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text("12/12/2012",  style: TextStyle(fontSize: 12, color:Colors.grey, fontWeight: FontWeight.w500),),
                ),
              ),
              Container(
                color:Colors.grey[200],
                child: Image.asset(ImageResources.appSurprizeTextLogo,
                   height: 220, width: _screenWidth),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("We are in the new area of surprize where you can earn loads of money with just a click... ",  style: TextStyle(fontSize: 18),),
              )
            ],
          ) ,
        )
      ),
    );
  }
  /*
  Event card
   */
  Widget eventCard() {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0, left: 16.0),
      child: Container(
        height: 160,
        child: Card(
          color: Colors.white,
          child: Row(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Image.asset(ImageResources.appMainIcon,
                      height: 152, width: 158),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text("Daily quiz challenge",
                              style: TextStyle(
                                  fontFamily: 'Roboto',
                                  color: Colors.purple[900],
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text("Play and earn 500",
                            style: TextStyle(
                                fontFamily: 'Roboto',
                                color: Colors.grey,
                                fontSize: 18)),
                      ),
                      Text("12/12/2017 5:00 PM ",
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              color: Colors.grey,
                              fontSize: 16)),

                      Padding(
                        padding: const EdgeInsets.only(top:20.0),
                        child: Container(
                          decoration: new BoxDecoration(
                              color:Colors.purple,
                              border:
                              new Border.all(color: Colors.purple, width: 1),
                              borderRadius:
                              new BorderRadius.all(Radius.circular(40.0))),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.alarm, color:Colors.white),
                                Padding(
                                  padding: const EdgeInsets.only(left:4.0),
                                  child: Text("Set Reminder",
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          color: Colors.white,
                                          fontSize: 18)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
