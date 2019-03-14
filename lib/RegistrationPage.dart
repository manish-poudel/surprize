import 'package:flutter/material.dart';
import 'package:surprize/Helper/AppColor.dart';

import 'CustomWidgets/CustomLabelTextFieldWidget.dart';
import 'CustomWidgets/CustomPhoneNumberWidget.dart';
import 'CustomWidgets/CustomDatePickerWidget.dart';
import 'CustomWidgets/CustomMultiLineTextFieldWidget.dart';
import 'CustomWidgets/CustomTextButtonWidget.dart';
import 'CustomWidgets/CustomDropDownWidget.dart';
import 'Helper/AppHelper.dart';
import 'CustomWidgets/CustomELAWidget.dart';

class RegistrationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return RegistrationPageState();
  }
}

class RegistrationPageState extends State<RegistrationPage> {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: Scaffold(
        backgroundColor: AppColor.colorPrimary,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.only(top: 18.0, left: 16.0, right: 16.0),
                child: Center(
                  child: Row(
                    children: <Widget>[
                      IconButton(
                        icon:Icon(Icons.arrow_back, color: Colors.white),
                        tooltip: 'Go back',
                        onPressed: (){
                          AppHelper.pop(context);
                        }
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left:32.0),
                        child: Text("Create account",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 32.0,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.bold)),
                      ),
                    ],
                  )
                ),
              ),
              Divider(color: Colors.white, height: 12.0),
              Padding(
                padding: const EdgeInsets.only(top:8.0, left: 16.0, right: 16.0),
                child: Text("Login Information",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontFamily: 'Roboto')),
              ),
              Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: <Widget>[
                    CustomLabelTextFieldWidget("Email", Colors.white),
                    Padding(
                      padding: const EdgeInsets.only(top:8.0),
                      child: CustomLabelTextFieldWidget("Password", Colors.white),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top:8.0),
                      child: CustomLabelTextFieldWidget("Password Again", Colors.white),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0 ,left: 16.0, right: 16.0),
                child: Text("Personal Information",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontFamily: 'Roboto')),
              ),
              Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CustomLabelTextFieldWidget("Name", Colors.white),

                    Padding(
                      padding: const EdgeInsets.only(left: 1.0,top:8.0,right:1.0),
                      child: Container(
                        padding: EdgeInsets.all(16.0),
                          height: 58.0,
                          decoration: BoxDecoration(color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(4.0))
                          ),
                         child:  SizedBox(
                            width: double.infinity,
                            height: 48.0,
                            child:CustomDropDownWidget(['Male','Female','Other'],"Gender"),
                          )
                      ),
                    ),

                    Padding(
                        padding: const EdgeInsets.only(top:8.0),
                        child: CustomDatePickerWidget()
                    ),

                    Padding(
                        padding: const EdgeInsets.only(top:8.0),
                        child: CustomPhoneNumberWidget()
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top:8.0),
                      child:CustomMultiLineTextFieldWidget("Address", Colors.white)
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top:12.0),
                        child: CustomELAWidget(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 1.0,top:16.0,right:1.0),
                      child: SizedBox(
                        width: double.infinity,
                        height: 48.0,
                        child:CustomTextButtonWidget("Register", Colors.green, ()=> {}),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
