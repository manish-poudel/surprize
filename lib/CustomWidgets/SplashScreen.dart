import "package:flutter/material.dart";
import 'package:surprize/Helper/AppColor.dart';
import 'package:surprize/Resources/ImageResources.dart';
import 'package:surprize/Resources/StringResources.dart';

class SplashScreen extends StatelessWidget{

  @override
  Widget build(BuildContext context)
  {
    return new MaterialApp(
      home: Scaffold(
        backgroundColor: AppColor.colorPrimary,
          body: Center(
            child: (SingleChildScrollView(
              child: Center(
                child: (Card(child:Column(mainAxisAlignment:MainAxisAlignment.center,
                    children:<Widget> [
                      Container(padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0),child:
                      Image.asset(ImageResources.appMainLogo)),
                      Text(StringResources.appCreator)
                    ])
                )),
              ),
            )
            ),
          )
      ),
    );
  }
}
