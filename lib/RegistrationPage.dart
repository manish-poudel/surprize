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
import 'CustomWidgets/CustomLoginCredentialRegWidget.dart';

class RegistrationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return RegistrationPageState();
  }
}

class RegistrationPageState extends State<RegistrationPage> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;


  // Form widgets
  CustomLoginCredentialRegWidget customLoginCredentialRegWidget=  CustomLoginCredentialRegWidget();
  CustomLabelTextFieldWidget _nameField = CustomLabelTextFieldWidget("Name", Colors.white, validation: AppHelper.validateName);
  CustomDropDownWidget _genderDropDownWidget=  CustomDropDownWidget(['Male', 'Female', 'Other'], "Gender");
  CustomDatePickerWidget _datePickerWidget = CustomDatePickerWidget();
  CustomPhoneNumberWidget _phoneNumberWidget = CustomPhoneNumberWidget();
  CustomMultiLineTextFieldWidget _multiLineTextFieldWidget = CustomMultiLineTextFieldWidget("Address", Colors.white);
  CustomELAWidget _customELAWidget = new CustomELAWidget();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: Scaffold(
        backgroundColor: AppColor.colorPrimary,
        body: SingleChildScrollView(
          child: new Form(
            key: _formKey,
            autovalidate: _autoValidate,
            child: registrationFormUI(context),
          ),
        ),
      ),
    );
  }

  Widget registrationFormUI(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding:
          const EdgeInsets.only(top: 18.0, left: 16.0, right: 16.0),
          child: Center(
              child: Row(
                children: <Widget>[
                  IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      tooltip: 'Go back',
                      onPressed: () {
                        AppHelper.pop(context);
                      }
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 32.0),
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
          padding: const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
          child: Text("Login Information",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontFamily: 'Roboto')),
        ),
        customLoginCredentialRegWidget,

        Padding(
          padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
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
              _nameField,
              Padding(
                padding: const EdgeInsets.only(left: 1.0, top: 8.0, right: 1.0),
                child: Container(
                    padding: EdgeInsets.all(16.0),
                    height: 58.0,
                    decoration: BoxDecoration(color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(4.0))
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: 48.0,
                      child: _genderDropDownWidget
                    )
                ),
              ),

              Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: _datePickerWidget
              ),

              Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: _phoneNumberWidget
              ),

              Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: _multiLineTextFieldWidget
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: _customELAWidget,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 1.0, top: 16.0, right: 1.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 48.0,
                  child: CustomTextButtonWidget("Create", Colors.green, () => validateInputs()),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /*
  Validate inputs
   */
  void validateInputs(){
    if(_datePickerWidget.isProperlyValidated()){

    }
    if(_formKey.currentState.validate()){
      _formKey.currentState.save();
    }
    else{
      setState(() {
        _autoValidate = true;
      });
    }
  }

}


