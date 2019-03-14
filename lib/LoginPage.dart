import 'package:flutter/material.dart';
import 'package:surprize/Helper/AppColor.dart';
import 'CustomWidgets/CustomLabelTextFieldWidget.dart';
import 'CustomWidgets/CustomTextButtonWidget.dart';
import 'Helper/AppHelper.dart';

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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home:Scaffold(
        backgroundColor: AppColor.colorPrimary,
        body: Container(
          child: Column(
            children: <Widget>[
              Container(
                  child: Image.asset('assets/images/gift_colorful.png'),
                  padding: EdgeInsets.only(top:48.0),
                  alignment: FractionalOffset.center
              ),
              Text("Surprize !",
                  style: TextStyle(color:Colors.white, fontSize: 32.0, fontFamily: 'Roboto')
              ),
              Padding(
                padding: const EdgeInsets.only(top: 32.0, left: 16.0, right: 16.0),
                child: Container(
                  child: Column(
                    children: <Widget>[
                    Text("Enter your login information",
                        style: TextStyle(color:Colors.white, fontSize: 16.0, fontFamily: 'Roboto' )
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top:16.0),
                      child: CustomLabelTextFieldWidget("Email", Colors.white),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top:8.0),
                      child: CustomLabelTextFieldWidget("Password", Colors.white),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 1.0,top:8.0,right:1.0),
                      child: SizedBox(
                        width: double.infinity,
                        height: 48.0,
                        child:CustomTextButtonWidget("Login", Colors.blueAccent, ()=> {}),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: GestureDetector(
                        child: Text("Forgot my password",
                            style: TextStyle(color:Colors.white, fontSize: 18.0, fontFamily: 'Roboto', decoration: TextDecoration.underline)
                        ),
                        onTap: (){

                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: CustomTextButtonWidget("Haven't Registered? Create account", Colors.green,
                              ()=> AppHelper.goToPage(context, false, '/registrationPage')),
                    ),
                  ],),
                ),
              )
            ],
          ),
        ),
      ) ,
    );
  }

}
