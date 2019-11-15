import 'package:flutter/material.dart';

import 'Resources/ImageResources.dart';

class TimesUpPage extends StatefulWidget {
  @override
  _TimesUpPageState createState() => _TimesUpPageState();
}

class _TimesUpPageState extends State<TimesUpPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: new AssetImage(ImageResources.appBackgroundImage),
                  fit: BoxFit.fill)),
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.timer_off,color: Colors.white,size: 120),
                        Text("Times up",style: TextStyle(color: Colors.white, fontFamily: 'Raleway',fontSize: 32)),
                        Text("Come back again for next game!",textAlign:TextAlign.center,style: TextStyle(color: Colors.white, fontFamily: 'Raleway',fontSize: 18)),
                      ],
                    ),
                  ),
                  RaisedButton(color:Colors.redAccent,child: Text("Exit",style: TextStyle(fontFamily: 'Raleway',color: Colors.white)), onPressed: () => Navigator.of(context).pop())
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
