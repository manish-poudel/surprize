import 'package:Surprize/Helper/AppHelper.dart';
import 'package:Surprize/SplashScreen.dart';
import 'package:flutter/material.dart';

class EmailChangeSuccess extends StatefulWidget {

  String email;
  EmailChangeSuccess(this.email);
  @override
  _EmailChangeSuccessState createState() => _EmailChangeSuccessState();
}

class _EmailChangeSuccessState extends State<EmailChangeSuccess> {
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
        theme: ThemeData(primaryColor: Colors.purple[800]),
        home: Scaffold(
        appBar: AppBar(
        title: Text("Email changed", style: TextStyle(fontFamily: 'Raleway'))),
            body: Container(
              height: MediaQuery.of(context).size.height,
              child: emailChangeSuccessMessage()
            )));
  }

  Widget emailChangeSuccessMessage() {
    return Container(
        child: Column(children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top:16.0,left:16.0),
            child: Row(
              children: <Widget>[
                Text("Email changed to: ",style: TextStyle(color: Colors.blueGrey,fontFamily: 'Raleway',fontWeight: FontWeight.w400,fontSize: 14)),
                Text(widget.email,style: TextStyle(color: Colors.blueGrey,fontFamily: 'Raleway',fontWeight: FontWeight.w600,fontSize: 14)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Text("A verification link has been sent to your email address. Click on it to verify your account!",style: TextStyle(color: Colors.blueGrey,fontFamily: 'Raleway',fontWeight: FontWeight.w400,fontSize: 14)),
                Padding(
                  padding: const EdgeInsets.only(top:8.0),
                  child: Text("Note: if you are unable to find the email sent by us, please make sure to check your spam folder",style: TextStyle(color: Colors.blueGrey,fontFamily: 'Raleway',fontWeight: FontWeight.w400,fontSize: 14)),
                ),
              ],
            ),
          ),

          FlatButton(color:Colors.green,child: Text("Login", style: TextStyle(fontSize: 18,fontFamily: 'Raleway',color: Colors.white)), onPressed: () => AppHelper.cupertinoRouteWithPushReplacement(context
              , SplashScreen()))

        ])
    );
  }
}
