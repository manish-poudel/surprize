import 'package:Surprize/RegistrationOptionPage.dart';
import 'package:Surprize/SplashScreen.dart';
import 'package:flutter/material.dart';
import 'package:Surprize/Firestore/FirestoreOperations.dart';
import 'package:Surprize/Resources/ImageResources.dart';
import 'package:Surprize/Resources/StringResources.dart';
import 'CustomWidgets/CustomLabelTextFieldWidget.dart';
import 'Helper/AppHelper.dart';
import 'CustomWidgets/CustomProgressbarWidget.dart';

/*
Login page template
 */
class LoginPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return LoginPageState();
  }
}

  class LoginPageState extends State<LoginPage>{
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    CustomLabelTextFieldWidget _emailField = CustomLabelTextFieldWidget("Email","", Colors.black);
    CustomLabelTextFieldWidget _passwordField = CustomLabelTextFieldWidget("Password","", Colors.black);
    CustomProgressbarWidget _customProgressBarWidget = CustomProgressbarWidget();

   /*
   Login user
    */
    void loginUser(){
      _customProgressBarWidget.startProgressBar(context, StringResources.loginProgressInformationDisplay, Colors.white, Colors.black);
      FirestoreOperations().loginUser(_emailField.getValue(), _passwordField.getValue()).then((firebaseUser)  {
        _customProgressBarWidget.stopAndEndProgressBar(context);
        AppHelper.cupertinoRouteWithPushReplacement(context, SplashScreen());
      }).catchError((error){
        _customProgressBarWidget.stopAndEndProgressBar(context);
        AppHelper.showSnackBar(error.toString(), _scaffoldKey);
      });
    }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home:Scaffold(
        resizeToAvoidBottomPadding:false,
        key: _scaffoldKey,
        appBar: AppBar(title: Text('Sign in', style: TextStyle(fontFamily: 'Raleway')), backgroundColor: Colors.purple[800]),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
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
                padding: const EdgeInsets.only(left: 16.0, top:8, right: 16.0),
                child: Container(
                  child: Column(
                    children: <Widget>[
                     // Text("Sign in", style: TextStyle(fontFamily: 'Raleway', fontSize: 18,color: Colors.purple[800], fontWeight: FontWeight.w400),),
                    Padding(
                      padding: const EdgeInsets.only(top:8.0),
                      child: _emailField,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top:16.0),
                      child: _passwordField,
                    ),
                  Padding(
                    padding: const EdgeInsets.only(top:16.0),
                    child: Center(
                      child: GestureDetector(
                        child: Text(StringResources.buttonForgotPasswordText,
                            style: TextStyle(color:Colors.purple, fontSize: 18.0, fontFamily: 'Raleway', decoration: TextDecoration.underline)
                        ),
                        onTap: (){

                        },
                      ),
                    ),
                  ),
                    Padding(
                      padding: const EdgeInsets.only(top:16.0),
                      child: FlatButton(child:Text(StringResources.buttonLoginText, style: TextStyle(color: Colors.white, fontSize:18,fontFamily: 'Raleway')), color:Colors.purple[800],onPressed: ()=> loginUser()),
                    ),
                    Container(
                      padding: EdgeInsets.all(48),
                      child: Padding(
                        padding: const EdgeInsets.only(top:1.0),
                        child: FlatButton(color:Colors.green,onPressed:()=> AppHelper.cupertinoRoute(context, RegistrationOptionPage()),
                            child: Text("Create account",
                                style: TextStyle(color:Colors.white,fontSize: 18,fontFamily: 'Raleway', fontWeight:FontWeight.w300))),
                      ),
                    )
                  ],),
                ),
              )
            ],
          ),
        ),
        )
    );
  }
    @override
    void initState() {
      super.initState();
    }

  }
