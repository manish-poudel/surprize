import 'package:flutter/material.dart';
import 'package:Surprize/Firestore/FirestoreOperations.dart';
import 'package:Surprize/Resources/ImageResources.dart';
import 'package:Surprize/Resources/StringResources.dart';
import 'CustomWidgets/CustomLabelTextFieldWidget.dart';
import 'CustomWidgets/CustomTextButtonWidget.dart';
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

    CustomLabelTextFieldWidget _emailField = CustomLabelTextFieldWidget("Email","", Colors.white);
    CustomLabelTextFieldWidget _passwordField = CustomLabelTextFieldWidget("Password","", Colors.white);
    CustomProgressbarWidget _customProgressBarWidget = CustomProgressbarWidget();

   /*
   Login user
    */
    void loginUser(){
      _customProgressBarWidget.startProgressBar(context, StringResources.loginProgressInformationDisplay, Colors.purple[800], Colors.white);
      FirestoreOperations().loginUser(_emailField.getValue(), _passwordField.getValue()).then((firebaseUser)  {
        _customProgressBarWidget.stopAndEndProgressBar(context);
        AppHelper.goToPage(context, true, '/playerDashboard');
      }).catchError((error){
        _customProgressBarWidget.stopAndEndProgressBar(context);
        AppHelper.showSnackBar(error.toString(), _scaffoldKey);
      });
    }

  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return MaterialApp(
      home:Scaffold(
        key: _scaffoldKey,
        body: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              image:DecorationImage(image: new AssetImage(ImageResources.appBackgroundImage), fit: BoxFit.cover)
            ),
            child: Column(
              children: <Widget>[
                Container(
                    child: Image.asset(ImageResources.appMainLogo),
                    padding: EdgeInsets.only(top:36.0),
                    alignment: FractionalOffset.center
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                  child: Container(
                    child: Column(
                      children: <Widget>[
                      Text(StringResources.loginHeadingDisplay,
                          style: TextStyle(color:Colors.white, decorationColor: Colors.deepPurpleAccent ,fontSize: 18.0, fontWeight: FontWeight.w500,fontFamily: 'Roboto' )
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top:16.0),
                        child: _emailField,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top:8.0),
                        child: _passwordField,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 1.0,top:8.0,right:1.0),
                        child: SizedBox(
                          width: double.infinity,
                          height: 48.0,
                          child:CustomTextButtonWidget(StringResources.buttonLoginText, Colors.deepPurple, ()=> loginUser()),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 24, left:16.0, right: 16.0),
                        child: GestureDetector(
                          child: Text(StringResources.buttonForgotPasswordText,
                              style: TextStyle(color:Colors.white, fontSize: 18.0, fontFamily: 'Roboto', decoration: TextDecoration.underline)
                          ),
                          onTap: (){

                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: CustomTextButtonWidget(StringResources.buttonRegisterAccountText, Colors.deepPurpleAccent,
                                ()=> AppHelper.goToPage(context, false, '/registrationPage')),
                      ),
                    ],),
                  ),
                )
              ],
            ),
          ),
        ),
      ) ,
    );

  }
}
