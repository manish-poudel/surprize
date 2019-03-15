import 'package:flutter/material.dart';
import 'package:surprize/Helper/AppHelper.dart';
import 'CustomLabelTextFieldWidget.dart';
import 'CustomRegPasswordEntryWidget.dart';

class CustomLoginCredentialRegWidget extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CustomLoginCredentialRegWidgetState();
  }
}

class CustomLoginCredentialRegWidgetState extends State<CustomLoginCredentialRegWidget>{

  String getEmail(){
    return _emailField.getValue();
  }

  String getPassword(){
    return _passwordField.getPassword();
  }

  String getPasswordAgain(){
    return _passwordField.getRepassword();
  }

  CustomLabelTextFieldWidget _emailField = CustomLabelTextFieldWidget("Email", Colors.white, validation: AppHelper.validateEmail);
  CustomRegPasswordEntryWidget _passwordField = CustomRegPasswordEntryWidget();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: <Widget>[
          Container(
              child: _emailField),
          _passwordField
        ],
      ),
    );
  }


}

