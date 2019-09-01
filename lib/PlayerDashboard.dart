
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:surprize/Resources/ImageResources.dart';
import 'package:surprize/SurprizeNavigationDrawerWidget.dart';
import 'CustomUpcomingEventsWidget.dart';
import 'Helper/AppHelper.dart';
import 'NewsReadingPage.dart';

class PlayerDashboard extends StatefulWidget {

  FirebaseUser user;
  PlayerDashboard(this.user);

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


  @override
  Widget build(BuildContext context) {

    _screenWidth = MediaQuery.of(context).size.width;
    _screenHeight = MediaQuery.of(context).size.height;

    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.purple[800]),
      home: Scaffold(
        appBar: AppBar(title:Text("Home")),
          drawer: SurprizeNavigationDrawerWidget(widget.user.uid, context),
          body:dashboardBody())
    );
  }


  /// Dashboard body
  Widget dashboardBody(){
    return SingleChildScrollView(
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
                child: Padding(
                  padding: const EdgeInsets.only(left:16.0,right:16.0),
                  child: CustomUpcomingEventsWidget()
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
              newsCard()
            ],
          )),
    );
  }

  /// News card
  Widget newsCard() {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NewsReadingPage()),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: Container(
            width: _screenWidth,
            child: Card(
              color: Colors.grey[100],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    color: Colors.white,
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
                                      fontSize: 21, fontWeight: FontWeight.w300),),
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
                    height: 170,
                    color: Colors.grey[50],
                    child: Image.network('http://lorempixel.com/400/200/', height: 160),
                  ),
                  Container(
                    color:Colors.white,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left:8.0, right:8.0, top:8.0),
                          child: Text(
                            "We are in the new area of surprize where you can earn loads of money with just a click..",
                            style: TextStyle(fontSize: 18, color:Colors.black, fontWeight: FontWeight.w400)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left:8.0),
                          child: FlatButton(child: Text("Click for more")),
                        )
                      ],
                    ),
                  ),

                ],
              ),
            )
        ),
      ),
    );
  }
}
