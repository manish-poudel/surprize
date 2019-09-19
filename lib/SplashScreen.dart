import 'package:Surprize/Dashboard.dart';
import 'package:Surprize/Helper/AppHelper.dart';
import 'package:Surprize/LoginPage.dart';
import 'package:Surprize/Memory/UserMemory.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:Surprize/Resources/ImageResources.dart';

class SplashScreen extends StatefulWidget {

  SplashScreen();

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  Image logoImage;

  @override
  void initState() {
    super.initState();
    logoImage = Image.asset(ImageResources.appMainLogo);
    checkIfUserLoggedIn(context);
  }


  /// Check if user is logged in
  checkIfUserLoggedIn(context){
    FirebaseAuth.instance.currentUser().then((user){
      if(user == null) {
        AppHelper.cupertinoRouteWithPushReplacement(context, LoginPage());
      } else{
        UserMemory().saveFirebaseUser(user);
        Dashboard(context,user).nav();
      }
    });
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(logoImage.image, context);
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(
          body: Container(
            decoration: BoxDecoration(
              color: Colors.purple[800],
                image:DecorationImage(image: AssetImage(ImageResources.appBackgroundImage), fit: BoxFit.cover)),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                logoImage,
                  Center(child:Text("A product of silicon guys",
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Raleway',
                          fontSize: 21,
                          fontWeight: FontWeight.w400)
                  )),
                ],
              ),
            ),
          )),
    );
  }
}
