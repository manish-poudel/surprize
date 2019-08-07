import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:surprize/CustomWidgets/CustomEventsWidgetCard.dart';
import 'package:surprize/CustomWidgets/CustomSliverAppBarWidget.dart';
import 'package:surprize/CustomWidgets/CustomStreamBuilderWidget.dart';
import 'package:surprize/DailyQuizChallengePage.dart';
import 'package:surprize/Firestore/FirestoreOperations.dart';
import 'package:surprize/Helper/AppHelper.dart';
import 'package:surprize/Models/Events.dart';
import 'package:surprize/ProfilePage.dart';
import 'package:surprize/Resources/FirestoreResources.dart';
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
    _screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    _screenHeight = MediaQuery
        .of(context)
        .size
        .height;
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
            height: MediaQuery
                .of(context)
                .size
                .height,
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
                       Container(
                         height: 296,
                         width: 500,
                         child: Padding(
                           padding: const EdgeInsets.only(left:16.0,right:16.0),
                           child: CustomStreamBuilderWidget(
                                FirestoreOperations().getMainCollectionSnapshot(FirestoreResources.collectionEvent),
                                getEventList
                            ),
                         ),
                       ),

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
                        newsCard(),
                        newsCard(),
                        newsCard(),
                      ],
                    )),
              ),
            ),
          )),
    );
  }

  /*
  Get all list view
   */
  ListView getEventList(snapshot){
    return ListView(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      children: snapshot.data.documents.map<Widget>((document){
        Events events = Events.fromMap(document.data);
        return CustomEventWidgetCard(events.photoUrl,
          events.title,
          events.desc,
          AppHelper.dateToReadableString(events.time)
        );
      }).toList()
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
                      AppHelper.textWithIcon(Icons.person, "Manish Poudel", 4.0, 21, Colors.white),
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
                () {
                  goToPage('/dailyQuizChallengeNotAvailablePage');
                },
            'No quiz'),
        Padding(
          padding: const EdgeInsets.only(top: 2.0),
          child: flatButtonWithRoute(
                  () {
                    goToPage('/dailyQuizChallengeGamePlayPage');
                  },
              "Quiz available"),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 2.0),
          child: flatButtonWithRoute(
                  () => DailyQuizChallengePage().openPage(context),
              "Play quiz"),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 2.0),
          child: flatButtonWithRoute((){
        FirebaseAuth.instance.currentUser().then((user){
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProfilePage(user.uid)),
          );
        });

    }, "Profile"),

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
    print("Going to page " + pageName.toString());
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
  Widget newsCard() {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: Container(
          width: _screenWidth,
          child: Card(
            color: Colors.grey[100],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  color: Colors.grey[200],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Icon(Icons.event_note, color: Colors.grey,),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 16.0, top:16.0),
                              child: Text("Welcome to the new area of Surprize",
                                style: TextStyle(
                                    fontSize: 21, fontWeight: FontWeight.w500),),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 16.0, bottom: 16.0),
                              child: Text("12/12/2012", style: TextStyle(fontSize: 12,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500),),
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),
                ),

                Container(
                  color: Colors.grey[50],
                  child: Image.asset(ImageResources.appSurprizeTextLogo,
                      height: 220, width: _screenWidth),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "We are in the new area of surprize where you can earn loads of money with just a click... ",
                    style: TextStyle(fontSize: 18),),
                )
              ],
            ),
          )
      ),
    );
  }
}
