import 'package:flutter/material.dart';
import 'package:Surprize/Helper/AppHelper.dart';
import '../CustomLabelTextFieldWidget.dart';
import 'package:Surprize/CustomWidgets/RegistrationPage/CustomRegPasswordEntryWidget.dart';

class CustomLoginCredentialRegWidget extends StatefulWidget{

  CustomLoginCredentialRegWidgetState _state;
  @override
  State<StatefulWidget> createState() {

    _state =  CustomLoginCredentialRegWidgetState();
    return _state;
  }

  String getEmail(){
    return _state.getEmail().trim();
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

  CustomLabelTextFieldWidget _emailField = CustomLabelTextFieldWidget("Email","", Colors.black, false, validation: AppHelper.validateEmail);
  CustomRegPasswordEntryWidget _passwordField = CustomRegPasswordEntryWidget("Enter password", "Enter password again");

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: <Widget>[
          Container(
              child:
              _emailField),
              _passwordField
        ],
      ),
    );
  }


}

