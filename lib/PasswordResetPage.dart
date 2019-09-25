import 'package:Surprize/CustomWidgets/CustomAppBar.dart';
import 'package:Surprize/CustomWidgets/CustomLabelTextFieldWidget.dart';
import 'package:Surprize/Helper/AppHelper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PasswordResetPage extends StatefulWidget {
  @override
  _PasswordResetPageState createState() => _PasswordResetPageState();
}

class _PasswordResetPageState extends State<PasswordResetPage> {
  CustomLabelTextFieldWidget _customLabelTextFieldWidget;
  final GlobalKey<FormState> _formKeyForPasswordResetPage= GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _customLabelTextFieldWidget = CustomLabelTextFieldWidget("Enter email", "", Colors.black, false);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.purple[800]),
      home: Scaffold(
        key: _scaffoldKey,
        appBar: CustomAppBar("Reset password", context),
        body: Form(
          key: _formKeyForPasswordResetPage,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Text("Enter valid email id which you used to create your account to receive a link for resetting your password.",
                style: TextStyle(fontFamily: 'Raleway'),),
                Padding(
                  padding: const EdgeInsets.only(top:16.0),
                  child: _customLabelTextFieldWidget,
                ),
                FlatButton(child: Text("Send link", style: TextStyle(fontFamily: 'Raleway', fontSize: 18),),onPressed: (){

                  if(!_formKeyForPasswordResetPage.currentState.validate())
                    return;

                  FirebaseAuth.instance.sendPasswordResetEmail(email: _customLabelTextFieldWidget.getValue().trim()).then((_){
                      AppHelper.showSnackBar("Email sent", _scaffoldKey);
                      }).catchError((error){
                          AppHelper.showSnackBar("Error sending mail:" + error.toString(), _scaffoldKey);
                      });
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
