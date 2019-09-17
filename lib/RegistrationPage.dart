import 'package:Surprize/ProfileSetUpPage.dart';
import 'package:Surprize/SplashScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Surprize/Firestore/FirestoreOperations.dart';
import 'package:Surprize/Resources/ImageResources.dart';
import 'package:Surprize/Resources/StringResources.dart';

import 'CustomWidgets/CustomAppBar.dart';
import 'Helper/AppHelper.dart';
import 'package:Surprize/CustomWidgets/RegistrationPage/CustomELAWidget.dart';
import 'package:Surprize/CustomWidgets/LoginPage/CustomLoginCredentialRegWidget.dart';
import 'CustomWidgets/CustomProgressbarWidget.dart';

class RegistrationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return RegistrationPageState();
  }
}

class RegistrationPageState extends State<RegistrationPage> with SingleTickerProviderStateMixin  {

  // keys
  final GlobalKey<FormState> _formKeyForLoginInformation = GlobalKey<FormState>();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _autoValidateForLoginInformation = false;



  @override
  void initState() {
    super.initState();

  }

  // Form widgets
  CustomLoginCredentialRegWidget _customLoginCredentialRegWidget=  CustomLoginCredentialRegWidget();
  CustomProgressbarWidget _customLoginProgressbar = new CustomProgressbarWidget();

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.purple[800]),
      home: Scaffold(
        key: _scaffoldKey,
        appBar: CustomAppBar("Registration", context),
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
              registrationFormLoginInformation(),
            ],
          ),
        ),
      ),
    );
  }


  // Registration form login
  registrationFormLoginInformation(){
    return Form(
      key: _formKeyForLoginInformation,
      autovalidate: _autoValidateForLoginInformation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
            child: Text(StringResources.registrationPageLoginCredentialHeaderDisplay,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Raleway')),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: _customLoginCredentialRegWidget,
          ),
          Center(child: FlatButton(color:Colors.green,child:Text("Create", style: TextStyle(color:Colors.white,fontSize:18,fontFamily: 'Raleway')),onPressed: () => onPressedLoginInformationNextButton()))
        ],
      ),
    );
  }

  onPressedLoginInformationNextButton(){
    if(!_formKeyForLoginInformation.currentState.validate())
      return;

    _customLoginProgressbar.startProgressBar(context, "Registering ...", Colors.white, Colors.black);
    registerUser();
  }


  // Register user
  void registerUser(){
    FirestoreOperations().regUser(_customLoginCredentialRegWidget.getEmail(), _customLoginCredentialRegWidget.getPassword()).then((firebaseUser){
      _customLoginProgressbar.stopAndEndProgressBar(context);
      AppHelper.cupertinoRouteWithPushReplacement(context,ProfileSetUpPage(firebaseUser));
    }).catchError((error){
      _customLoginProgressbar.stopAndEndProgressBar(context);
      AppHelper.showSnackBar(error.toString(), _scaffoldKey);
    });
    // Creating authentication
  }



}


