import "package:flutter/material.dart";
import 'package:surprize/Helper/AppColor.dart';
import 'package:surprize/Resources/ImageResources.dart';
import 'package:surprize/Resources/StringResources.dart';

class SplashScreen extends StatelessWidget{

  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
      home: Scaffold(
          body: Container(
            color:Colors.purple[800],
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(ImageResources.appMainLogo),
                  Center(child:Text("A product of silicon guys",
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Roboto',
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
