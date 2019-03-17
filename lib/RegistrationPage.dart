import 'package:flutter/material.dart';
import 'package:surprize/Firestore/FirestoreOperations.dart';
import 'package:surprize/Helper/AppColor.dart';
import 'package:surprize/Models/Player.dart';
import 'package:surprize/Resources/StringResources.dart';

import 'CustomWidgets/CustomLabelTextFieldWidget.dart';
import 'CustomWidgets/CustomPhoneNumberWidget.dart';
import 'CustomWidgets/CustomDatePickerWidget.dart';
import 'CustomWidgets/CustomMultiLineTextFieldWidget.dart';
import 'CustomWidgets/CustomTextButtonWidget.dart';
import 'CustomWidgets/CustomDropDownWidget.dart';
import 'Helper/AppHelper.dart';
import 'CustomWidgets/CustomELAWidget.dart';
import 'CustomWidgets/CustomLoginCredentialRegWidget.dart';
import 'CustomWidgets/CustomProgressbarWidget.dart';

class RegistrationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return RegistrationPageState();
  }
}

class RegistrationPageState extends State<RegistrationPage> {

  // keys
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _autoValidate = false;

  // Form widgets
  CustomLoginCredentialRegWidget _customLoginCredentialRegWidget=  CustomLoginCredentialRegWidget();
  CustomLabelTextFieldWidget _nameField = CustomLabelTextFieldWidget("Name", Colors.white, validation: AppHelper.validateName);
  CustomDropDownWidget _genderDropDownWidget=  CustomDropDownWidget(['Male', 'Female', 'Other'], "Gender");
  CustomDatePickerWidget _dobDatePickerWidget = CustomDatePickerWidget();
  CustomPhoneNumberWidget _phoneNumberWidget = CustomPhoneNumberWidget();
  CustomMultiLineTextFieldWidget _multiLineAddressTextFieldWidget = CustomMultiLineTextFieldWidget("Address", Colors.white);
  CustomELAWidget _customELAWidget = new CustomELAWidget();
  CustomProgressbarWidget _customRegistrationProgressBar = new CustomProgressbarWidget();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: Scaffold(
        key: _scaffoldKey,
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
                      tooltip: StringResources.goBackToolTipText,
                      onPressed: () {
                        AppHelper.pop(context);
                      }
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 32.0),
                    child: Text(StringResources.registrationPageCreateAccountTitleDisplay,
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
          child: Text(StringResources.registrationPageCreateAccountTitleDisplay,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontFamily: 'Roboto')),
        ),
        _customLoginCredentialRegWidget,

        Padding(
          padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
          child: Text(StringResources.registrationPagePersonalInformationHeaderDisplay,
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
                  child: _dobDatePickerWidget
              ),

              Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: _phoneNumberWidget
              ),

              Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: _multiLineAddressTextFieldWidget
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
                  child: CustomTextButtonWidget(StringResources.buttonCreateAccountText, Colors.green, () => validateAndRegisterPlayer()),
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
  void validateAndRegisterPlayer(){
    if(_formKey.currentState.validate() && _dobDatePickerWidget.isProperlyValidated()){
      _customRegistrationProgressBar.startProgressBar(context, StringResources.registrationProgressInformationDisplayMessage);
      registerUser(_customLoginCredentialRegWidget.getEmail(), _customLoginCredentialRegWidget.getPassword());
    }
    else{
      setState(() {
        _autoValidate = true;
      });
    }
  }

  /*
  Create authentication information
   */

  void registerUser(String email, String password){
    // Creating authentication
    FirestoreOperations().regUser(email, password).then((firebaseUser){

      // Save user profile information to the database
      registerPlayer(firebaseUser.uid, Player(
        firebaseUser.uid, // Player Id
        _nameField.getValue(), // Player Name
        _dobDatePickerWidget.getSelectedDate(), // Player DOB
        _multiLineAddressTextFieldWidget.getValue(), // Player Address
        _phoneNumberWidget.getCountryName(), // Player country
        _genderDropDownWidget.selectedItem(), // Player Gender
        email, // Player Email
        _phoneNumberWidget.getCountryCode() + " " + _phoneNumberWidget.getPhoneNumber(), // Player phone number
        DateTime.now(), // Player membership date
        "" // Player profile Image URL (To be updated later)
      ).toMap());

    }).catchError((error){
      _customRegistrationProgressBar.stopAndEndProgressBar(context);
      AppHelper.showSnackBar(error.toString(), _scaffoldKey);
    });
  }

  /*
  Register player information
   */
  void registerPlayer(String docId, Map playerMap){
      FirestoreOperations().createData(StringResources.userCollectionName, docId, playerMap).then((value){
        _customRegistrationProgressBar.stopAndEndProgressBar(context);
        AppHelper.showSnackBar(StringResources.snackBarRegistrationSuccessMessage, _scaffoldKey);
        AppHelper.goToPage(context, true, '/playerDashboard');
      }).catchError((error){
        _customRegistrationProgressBar.stopAndEndProgressBar(context);
        AppHelper.showSnackBar(error.toString(), _scaffoldKey);
      });
  }
}


