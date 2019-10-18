import 'package:Surprize/CustomWidgets/CustomAppBar.dart';
import 'package:Surprize/CustomWidgets/CustomLabelTextFieldWidget.dart';
import 'package:Surprize/CustomWidgets/CustomProgressbarWidget.dart';
import 'package:Surprize/CustomWidgets/RegistrationPage/CustomRegPasswordEntryWidget.dart';
import 'package:Surprize/Firestore/FirestoreOperations.dart';
import 'package:Surprize/Memory/UserMemory.dart';
import 'package:Surprize/Resources/FirestoreResources.dart';
import 'package:Surprize/SendFeedbackPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'Helper/AppHelper.dart';

class ChangeCredentialPage extends StatefulWidget {

  String changeType;
  ChangeCredentialPage(this.changeType);
  @override
  _ChangeCredentialPageState createState() => _ChangeCredentialPageState();
}

class _ChangeCredentialPageState extends State<ChangeCredentialPage> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String determiningUserTypeText = "Please wait...";

  bool loading = true;

  bool allowChange = false;
  bool errorInChange = false;
  String errorString = "";

  bool emailChangedSuccess = false;
  bool passwordChangeSuccess = false;


  CustomProgressbarWidget _customProgressBarWidget = CustomProgressbarWidget();

  CustomLabelTextFieldWidget _emailField = CustomLabelTextFieldWidget("Enter new email address", "", Colors.black, false, validation: AppHelper.validateEmail);
  CustomLabelTextFieldWidget _currentPasswordField = CustomLabelTextFieldWidget("Current password", "", Colors.black, true);
  CustomRegPasswordEntryWidget _passwordField = CustomRegPasswordEntryWidget("Enter new password", "Enter new password again");

  static String _validatePassword(String value){
    if (value.length < 6)
      return 'Password must be more than 6 character';
    else
      return null;
  }

@override
  void initState() {
    super.initState();
    determineUserLoginType();
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(primaryColor: Colors.purple[800]),
        home: Scaffold(
          key: _scaffoldKey,
          appBar: CustomAppBar(widget.changeType == "EMAIL"?"Change email":"Change password", context),
          body: widget.changeType == "EMAIL"?displayUIForEmail():changePassword(),
        )
    );
  }

  determineUserLoginType(){
    FirebaseAuth.instance.currentUser().then((user) async {
      try{
       allowChange = user.providerData[1].providerId == "password";
      }
      catch(error){
        errorString = error.toString();
        errorInChange = true;
      }
      if(mounted) {
        setState(() {
          loading = false;
        });
      }
    });
  }
  /// Change email widget
  Widget displayUIForEmail(){
    if(loading){
      return Center(child:CircularProgressIndicator());
    }
    if(errorInChange){
      return cannotChangeMessage(Icons.error, "Error occured. Click send to report an issue!",errorString);
    }
    else{
     return allowChange?changeEmail():cannotChangeMessage(Icons.info, "Account created using Google cannot change their email address. Send us message for further information!","");
    }
  }


  /// Display UI For change password
  displayUIForChangePassword(){
    if(loading){
      return Center(child:CircularProgressIndicator());
    }
    if(errorInChange){
      return cannotChangeMessage(Icons.error, "Error occured. Click send to report an issue!",errorString);
    }
    else{
      return allowChange?changePassword():cannotChangeMessage(Icons.info, "Account created using Google cannot change their email address. Send us message for further information!","");
    }
  }


  /// Change password
  Widget changePassword(){
    return SingleChildScrollView(
      child: passwordChangeSuccess? Container(
          child: Column(children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top:16.0,left:16.0),
              child: Row(
                children: <Widget>[
                 Icon(Icons.check),
                  Padding(
                    padding: const EdgeInsets.only(left:8.0),
                    child: Text("Password change success",style: TextStyle(color: Colors.blueGrey,fontFamily: 'Raleway',fontWeight: FontWeight.w600,fontSize: 14)),
                  ),
                ],
              ),
            ),
          ])
      ):Container(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[

              Padding(
                padding: const EdgeInsets.only(top:16.0,left:16.0),
                child: Row(
                  children: <Widget>[
                    Text("Change password for: ",style: TextStyle(color: Colors.blueGrey,fontFamily: 'Raleway',fontWeight: FontWeight.w300,fontSize: 14)),
                    Text(UserMemory().getPlayer().email,style: TextStyle(color: Colors.blueGrey,fontFamily: 'Raleway',fontWeight: FontWeight.w600,fontSize: 14)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left:16.0,right: 16.0,top:16.0),
                child: _currentPasswordField,
              ),
              Padding(
                padding: const EdgeInsets.only(left:16.0,right:16.0, bottom: 16.0),
                child: _passwordField,
              ),

              Center(
                child: FlatButton(color:Colors.green,child: Text("Change", style: TextStyle(color:Colors.white,fontFamily: 'Raleway', fontSize: 18)),onPressed: (){
                  if(!_formKey.currentState.validate())
                    return;
                  changeToNewPassword();
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Change user password
  changeToNewPassword(){
    if (_currentPasswordField.getValue().isEmpty) {
      AppHelper.showSnackBar("Enter your current password!", _scaffoldKey);
      return;
    }

    _customProgressBarWidget.startProgressBar(
        context,
        "Changing your password",
        Colors.white,
        Colors.black);

    FirestoreOperations()
        .loginUser(UserMemory().firebaseUser.email, _currentPasswordField.getValue())
        .then((AuthResult authResult) {

      FirebaseUser user = authResult.user;
      /// Change email
      user.updatePassword(_passwordField.getPassword().trim()).then((_){

        _customProgressBarWidget.stopAndEndProgressBar(context);
        setState(() {
          passwordChangeSuccess = true;
        });

      }).catchError((error){
        _customProgressBarWidget.stopAndEndProgressBar(context);
        displayError(error);
      });


    }).catchError((error) {
      print("catching error");
      _customProgressBarWidget.stopAndEndProgressBar(context);
      displayError(error);
    });

  }

  Widget cannotChangeMessage(IconData icon, String message,String initialMessage){
    return Container(
      child:Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, color: Colors.blueGrey[300], size: 64),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(message, textAlign:TextAlign.center,style: TextStyle(color: Colors.blueGrey,fontFamily: 'Raleway',fontWeight: FontWeight.w300,fontSize: 14)),
            ),
            FlatButton(
                child: Text("Send",
                    style: TextStyle(color: Colors.grey,fontSize: 18)),
                onPressed: () =>
                    AppHelper.cupertinoRoute(context, SendFeedbackPage(initialMessage)))
          ],
        )),
      )
    );
  }
  Widget changeEmail(){
    return emailChangedSuccess? Container(
        child: Column(children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top:16.0,left:16.0),
            child: Row(
              children: <Widget>[
                Text("Email changed to: ",style: TextStyle(color: Colors.blueGrey,fontFamily: 'Raleway',fontWeight: FontWeight.w300,fontSize: 14)),
                Text(UserMemory().getPlayer().email,style: TextStyle(color: Colors.blueGrey,fontFamily: 'Raleway',fontWeight: FontWeight.w600,fontSize: 14)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Text("A verification link has been sent to your email address. Click on it to verify your account!",style: TextStyle(color: Colors.blueGrey,fontFamily: 'Raleway',fontWeight: FontWeight.w300,fontSize: 14)),
                Text("Note: if you are unable to find the email sent by us, please make sure to check your spam inbox",style: TextStyle(color: Colors.blueGrey,fontFamily: 'Raleway',fontWeight: FontWeight.w300,fontSize: 14)),
              ],
            ),
          ),

        ])
    ):Container(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top:16.0,left:16.0),
              child: Row(
                children: <Widget>[
                  Text("Your current email address: ",style: TextStyle(color: Colors.blueGrey,fontFamily: 'Raleway',fontWeight: FontWeight.w300,fontSize: 14)),
                  Text(UserMemory().getPlayer().email,style: TextStyle(color: Colors.blueGrey,fontFamily: 'Raleway',fontWeight: FontWeight.w600,fontSize: 14)),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left:16.0,right: 16.0,top:16.0),
              child: _currentPasswordField,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: _emailField,
            ),

            Center(
              child: FlatButton(color:Colors.green,child: Text("Change", style: TextStyle(color:Colors.white,fontFamily: 'Raleway', fontSize: 18)),onPressed: (){
                if(!_formKey.currentState.validate())
                  return;
                loginAndChangeEmail();
              }),
            ),
          ],
        ),
      ),
    );
  }

  /// Login user
  void loginAndChangeEmail() {
    if (_emailField.getValue().isEmpty || _currentPasswordField.getValue().isEmpty) {
      AppHelper.showSnackBar("Empty email or password", _scaffoldKey);
      return;
    }

    _customProgressBarWidget.startProgressBar(
        context,
        "Changing your email address",
        Colors.white,
        Colors.black);

    FirestoreOperations()
        .loginUser(UserMemory().firebaseUser.email, _currentPasswordField.getValue())
        .then((AuthResult authResult) {

          FirebaseUser user = authResult.user;
          /// Change email
          user.updateEmail(_emailField.getValue().trim()).then((_){

            FirebaseAuth.instance.currentUser().then((user){
              UserMemory().firebaseUser = user;
              UserMemory().firebaseUser.reload();
              UserMemory().firebaseUser.sendEmailVerification();
            });

            Firestore.instance.collection(FirestoreResources.userCollectionName).document(UserMemory().getPlayer().membershipId)
                .updateData({
               FirestoreResources.fieldPlayerEmail: _emailField.getValue().trim()
            }).then((value){
              AppHelper.showSnackBar("Email changed successfully. ", _scaffoldKey);
              setState(() {
                UserMemory().getPlayer().email = _emailField.getValue().toString();
                emailChangedSuccess = true;
              });

              _customProgressBarWidget.stopAndEndProgressBar(context);
            });
          }).catchError((error){
            _customProgressBarWidget.stopAndEndProgressBar(context);
            displayError(error);
          });


    }).catchError((error) {
      print("catching error");
      _customProgressBarWidget.stopAndEndProgressBar(context);
      displayError(error);
    });
  }

  displayError(error){
    if(error is PlatformException){
      try {
        PlatformException platformException = error;
        AppHelper.showSnackBar(AppHelper.getErrorCodeString(platformException.code), _scaffoldKey);
      }
      catch(error){
        AppHelper.showSnackBar("Error changing email.", _scaffoldKey);
      }
    }
  }

}
