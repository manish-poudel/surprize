import "package:flutter/material.dart";
import 'package:Surprize/Helper/AppColor.dart';
import 'package:Surprize/Resources/ImageResources.dart';
import 'package:Surprize/Resources/StringResources.dart';

class SplashScreen extends StatelessWidget{

  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
      home: Scaffold(
          body: Container(
            decoration: BoxDecoration(
                image:DecorationImage(image: new AssetImage(ImageResources.appBackgroundImage), fit: BoxFit.cover)),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(ImageResources.appMainLogo),
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
