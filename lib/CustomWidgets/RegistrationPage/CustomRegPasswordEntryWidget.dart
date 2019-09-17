import 'package:flutter/material.dart';

class CustomRegPasswordEntryWidget extends StatefulWidget{

  CustomRegPasswordEntryWidgetState _state;

  String getPassword(){
    return _state.getPassword();
  }

  String getRepassword(){
    return _state.getRePassword();
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    _state = CustomRegPasswordEntryWidgetState();
    return _state;
  }

}

class CustomRegPasswordEntryWidgetState extends State<CustomRegPasswordEntryWidget>{

  String _passwordValue;
  String _rePasswordValue;

  TextEditingController passwordController = TextEditingController();
  TextEditingController rePasswordController = TextEditingController();

  String getPassword(){
    return passwordController.text;
  }

  String getRePassword(){
    return rePasswordController.text;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: passwordField(),
          ),
          Padding(
              padding: const EdgeInsets.only(top: 16.0),
            child: passwordAgainField(),
          )
        ],
      ),
    );
  }

  Widget passwordField(){
    return TextFormField(
      style: TextStyle(fontFamily: 'Raleway', color: Colors.black),
      controller: passwordController,
      keyboardType: TextInputType.emailAddress,
      validator: _validatePassword,
      onSaved: (String val){
        _passwordValue = val;
      },
      decoration: InputDecoration(
        hintText: "Enter password",
        hintStyle: TextStyle(color:Colors.grey),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
    );
  }

  Widget passwordAgainField(){
    return Container(
        child: Row(children: <Widget>[
          Flexible(
              child: TextFormField(
                style: TextStyle(fontFamily: 'Raleway', color: Colors.black),
                controller: rePasswordController,
                keyboardType: TextInputType.emailAddress,
                validator: _validatePasswordAgain,
                onSaved: (String val){
                  _passwordValue = val;
                },
                decoration: InputDecoration(
                  hintText: "Password again",
                  hintStyle: TextStyle(color:Colors.grey),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.purple),
                  ),
                ),
              ))
        ]));
  }


 /*
 Validate password
  */
  String _validatePassword(String value){
    if (value.length < 6)
      return 'Password must be more than 6 character';
    else
      return null;
  }

  /*
  Validate password again
   */
  String _validatePasswordAgain(String value){
    if(value == passwordController.text){
      return null;
    }
    return "Password didn't match";
  }

}