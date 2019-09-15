import 'package:Surprize/CustomWidgets/CustomAppBar.dart';
import 'package:Surprize/CustomWidgets/RegistrationPage/CustomELAWidget.dart';
import 'package:Surprize/Helper/AppHelper.dart';
import 'package:Surprize/RegistrationPage.dart';
import 'package:Surprize/Resources/ImageResources.dart';
import 'package:flutter/material.dart';

class RegistrationOptionPage extends StatefulWidget {
  @override
  _RegistrationOptionPageState createState() => _RegistrationOptionPageState();
}

class _RegistrationOptionPageState extends State<RegistrationOptionPage> {

  CustomELAWidget _customELAWidget = new CustomELAWidget();

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
        theme: ThemeData(primaryColor: Colors.purple[800]),
        home:Scaffold(
          resizeToAvoidBottomPadding:false,
          appBar: CustomAppBar("Registration", context),
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[

                Container(
                    decoration: BoxDecoration(
                      color: Colors.purple[800],
                    ),
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: Image.asset(ImageResources.appMainLogo),
                    alignment: FractionalOffset.center
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
                  child: Text("Choose sign up method",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Raleway')),
                ),

                Padding(
                  padding: const EdgeInsets.only(top:32.0),
                  child: Center(
                    child: FlatButton(color:Colors.green,onPressed:()=> AppHelper.cupertinoRouteWithPushReplacement(context, RegistrationPage()),
                        child: Text("Create account",
                            style: TextStyle(color:Colors.white,fontSize: 18,fontFamily: 'Raleway', fontWeight:FontWeight.w300))),
                  )),

                Center(
                  child: Text("or sign up using",
                      style: TextStyle(color:Colors.black,fontSize: 18.0, fontWeight: FontWeight.w400,fontFamily: 'Raleway' )
                  ),
                ),

                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        FlatButton(color:Colors.blueAccent,onPressed:()=> AppHelper.goToPage(context, false, '/registrationPage'),
                            child: Text("facebook",
                                style: TextStyle(color:Colors.white,fontSize: 18,fontFamily: 'Raleway', fontWeight:FontWeight.w300))),
                        FlatButton(color:Colors.red,onPressed:()=> AppHelper.cupertinoRoute(context, RegistrationPage()),
                            child: Text("Gmail",
                                style: TextStyle(color:Colors.white,fontSize: 18,fontFamily: 'Raleway', fontWeight:FontWeight.w300)))
                      ],
                    ),
                  ),
                ),

                Center(
                  child: _customELAWidget,
                ),

              ],
            ),
          ),
        )
    );
  }
}
