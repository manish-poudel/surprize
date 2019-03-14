import 'package:flutter/material.dart';
import 'LoginPage.dart';
import 'RegistrationPage.dart';

void main() => runApp(EntryPoint());

class EntryPoint extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
      home:handleCurrentScreen(),
      routes: <String, WidgetBuilder>{
        '/loginPage': (BuildContext context) => LoginPage(),
        '/registrationPage': (BuildContext context) => RegistrationPage()
      },
    );
  }

  Widget handleCurrentScreen(){
    if(true){
      return LoginPage();
    }
  }
}