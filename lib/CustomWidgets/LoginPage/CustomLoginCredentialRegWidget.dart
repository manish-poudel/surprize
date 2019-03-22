import 'package:flutter/material.dart';
import 'package:surprize/Helper/AppHelper.dart';
import '../CustomLabelTextFieldWidget.dart';
import 'package:surprize/CustomWidgets/RegistrationPage/CustomRegPasswordEntryWidget.dart';

class CustomLoginCredentialRegWidget extends StatefulWidget{

  CustomLoginCredentialRegWidgetState _state;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    _state =  CustomLoginCredentialRegWidgetState();
    return _state;
  }

  String getEmail(){
    return _state.getEmail();
  }

  String getPassword(){
    return _state.getPassword();
  }

  String getPasswordAgain(){
    return _state.getPasswordAgain();
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

