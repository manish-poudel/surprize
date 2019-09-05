import 'package:flutter/material.dart';
import 'package:surprize/CustomWidgets/CustomProgressbarWidget.dart';
import 'package:surprize/Models/Player.dart';

import 'CustomWidgets/CustomAppBar.dart';
import 'CustomWidgets/CustomDatePickerWidget.dart';
import 'CustomWidgets/CustomDropDownWidget.dart';
import 'CustomWidgets/CustomLabelTextFieldWidget.dart';
import 'CustomWidgets/CustomMultiLineTextFieldWidget.dart';
import 'CustomWidgets/CustomPhoneNumberWidget.dart';
import 'CustomWidgets/CustomTextButtonWidget.dart';
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
    _nameField = CustomLabelTextFieldWidget("Name",_player.name, Colors.white, validation: AppHelper.validateName);
    _genderDropDownWidget = CustomDropDownWidget(['Male', 'Female', 'Other'], _player.gender, "Gender");

      List<int> dob = AppHelper.getDateListFromString(_player.dob, "/");
    _dobDatePickerWidget = CustomDatePickerWidget(dob[0],dob[1],dob[2]);

    List<String> phoneCodeAndNumber = _player.phoneNumber.split(" ");
    _phoneNumberWidget = CustomPhoneNumberWidget(phoneCodeAndNumber[0], phoneCodeAndNumber[1]);
    _multiLineAddressTextFieldWidget = CustomMultiLineTextFieldWidget("Address", _player.address, Colors.white);
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
                padding: const EdgeInsets.only(left: 1.0, top: 8.0, right: 1.0),
                child: Container(
                    padding: EdgeInsets.all(16.0),
                    height: 58.0,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                            Radius.circular(4.0))),
                    child: SizedBox(
                        width: double.infinity,
                        height: 48.0,
                        child: _genderDropDownWidget)),
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: _dobDatePickerWidget),
              Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: _phoneNumberWidget),
              Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: _multiLineAddressTextFieldWidget),
              Padding(
                padding: const EdgeInsets.only(left: 1.0, top: 32.0, right: 1.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 48.0,
                  child:
                      CustomTextButtonWidget("Update", Colors.green, () => validateAndUpdateProfile()),
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
     _player.country = _phoneNumberWidget.getCountryName();
     _player.address = _multiLineAddressTextFieldWidget.getValue();

     UserProfile().updateProfile(_player.membershipId, _player).then((value){
       UserMemory().savePlayer(_player);
       _customRegistrationProgressBar.stopAndEndProgressBar(context);
       Navigator.pop(context);
     });
  }
}
