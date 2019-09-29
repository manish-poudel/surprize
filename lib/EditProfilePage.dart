import 'package:Surprize/CustomWidgets/CustomCountryPickerWidget.dart';
import 'package:flutter/material.dart';
import 'package:Surprize/CustomWidgets/CustomProgressbarWidget.dart';
import 'package:Surprize/Models/Player.dart';

import 'CustomWidgets/CustomAppBar.dart';
import 'CustomWidgets/CustomDatePickerWidget.dart';
import 'CustomWidgets/CustomDropDownWidget.dart';
import 'CustomWidgets/CustomLabelTextFieldWidget.dart';
import 'CustomWidgets/CustomMultiLineTextFieldWidget.dart';
import 'CustomWidgets/CustomPhoneNumberWidget.dart';
import 'Helper/AppHelper.dart';
import 'Memory/UserMemory.dart';
import 'UserProfileManagement/UserProfile.dart';

class EditProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return EditProfilePageState();
  }
}

class EditProfilePageState extends State<EditProfilePage> {

  Player _player;
  CustomLabelTextFieldWidget _nameField;
  CustomDropDownWidget _genderDropDownWidget;
  CustomDatePickerWidget _dobDatePickerWidget;
  CustomCountryPickerWidget _countryPickerWidget;
  CustomPhoneNumberWidget _phoneNumberWidget;
  CustomMultiLineTextFieldWidget _multiLineAddressTextFieldWidget;

  CustomProgressbarWidget _customRegistrationProgressBar;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _autoValidate = false;

  @override
  initState()  {
    initWidgets();
    super.initState();
  }


  /// Init player widgets
  initWidgets(){
    _player = UserMemory().getPlayer();
    _nameField = CustomLabelTextFieldWidget("Name",_player.name, Colors.black, false, validation: AppHelper.validateName);
    _genderDropDownWidget = CustomDropDownWidget(['Male', 'Female', 'Other'], _player.gender, "Gender", Colors.black, Colors.white);

    try {
      List<int> dob = AppHelper.getDateListFromString(_player.dob, "/");
      _dobDatePickerWidget =
          CustomDatePickerWidget(dob[0], dob[1], dob[2], Colors.black);
    }
    catch(error){
      _dobDatePickerWidget =
          CustomDatePickerWidget(1992, 12, 9, Colors.black);
    }
    _countryPickerWidget = CustomCountryPickerWidget(_player.country);
    try {
      List phoneNumber = _player.phoneNumber.split(" ");
      _phoneNumberWidget = CustomPhoneNumberWidget(
          phoneNumber[0], phoneNumber[1], Colors.black,validation: AppHelper.validatePhone);
    }
    catch(error){
      _phoneNumberWidget = CustomPhoneNumberWidget(
          "+61", "", Colors.black);
    }
    _multiLineAddressTextFieldWidget = CustomMultiLineTextFieldWidget("Address", _player.address, Colors.black,100);
    _customRegistrationProgressBar = new CustomProgressbarWidget();
  }


  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        theme: ThemeData(primaryColor: Colors.purple[800]),
        home: Scaffold(
            key:_scaffoldKey,
            appBar: CustomAppBar("Edit Profile", context),
            body: SingleChildScrollView(
              child: Form(
                  autovalidate: _autoValidate,
                  key: _formKey,
                  child: editProfileWidget()),
            )));
  }

  /// Edit profile widget
  Widget editProfileWidget() {
    return Card(
      child: Container(
          color:Colors.grey[100],
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _nameField,
              Padding(
                padding: const EdgeInsets.only(left: 1.0, top: 16.0, right: 1.0),
                child: SizedBox(
                    width: double.infinity,
                    height: 48.0,
                    child: _genderDropDownWidget),
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 24.0),
                  child: _dobDatePickerWidget),
              Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: _countryPickerWidget),
              Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: _phoneNumberWidget),
              Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: _multiLineAddressTextFieldWidget),
              Padding(
                padding: const EdgeInsets.only(left: 1.0, top: 32.0, right: 1.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 48.0,
                  child:
                  FlatButton(color:Colors.green,child: Text("Update",style: TextStyle(fontFamily: 'Raleway', color: Colors.white)), onPressed: () => validateAndUpdateProfile()),
                ),
              ),
            ],
          )),
    );
  }

  /// Validate profile and then edit
  validateAndUpdateProfile(){
    if(_formKey.currentState.validate()){
      _customRegistrationProgressBar.startProgressBar(context, "Updating ...", Colors.white, Colors.black);
      updateProfile();
    }
    else{
      setState(() {
        _autoValidate = true;
      });
    }
  }
  /// Update user profile
  updateProfile(){
    _player.name = _nameField.getValue();
    _player.gender = _genderDropDownWidget.selectedItem();
    _player.dob = _dobDatePickerWidget.getSelectedDate();
    _player.phoneNumber = _phoneNumberWidget.getCountryCode() + " " + _phoneNumberWidget.getPhoneNumber();
    _player.country = _countryPickerWidget.getValue();
    _player.address = _multiLineAddressTextFieldWidget.getValue();

    UserProfile().updateProfile(_player.membershipId, _player).then((value){
      UserMemory().savePlayer(_player);
      _customRegistrationProgressBar.stopAndEndProgressBar(context);
      Navigator.pop(context);
    });
  }

}
