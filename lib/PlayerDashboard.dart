import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:surprize/CustomWidgets/CustomTextButtonWidget.dart';
import 'package:surprize/Helper/AppHelper.dart';

class PlayerDashboard extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return PlayerDashboardState();
  }

}

class PlayerDashboardState extends State<PlayerDashboard>{

  void logoutUser(){
    FirebaseAuth.instance.signOut().then((value){
      try {
        AppHelper.goToPage(context, true, '/loginPage');
      }
      catch(error){
        print(error);
      }
    }).catchError((error){
      print(error);
    });
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(child: Column(
          children: <Widget>[
            Text("Welcome"),
            CustomTextButtonWidget("Logout", Colors.blueAccent, ()=> logoutUser())
          ],
        ),)
      ),
    );
  }

}