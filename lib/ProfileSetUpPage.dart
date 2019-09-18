import 'package:Surprize/CustomWidgets/CustomCountryPickerWidget.dart';
import 'package:Surprize/CustomWidgets/CustomDatePickerWidget.dart';
import 'package:Surprize/CustomWidgets/CustomDropDownWidget.dart';
import 'package:Surprize/CustomWidgets/CustomLabelTextFieldWidget.dart';
import 'package:Surprize/CustomWidgets/CustomMultiLineTextFieldWidget.dart';
import 'package:Surprize/CustomWidgets/CustomPhoneNumberWidget.dart';
import 'package:Surprize/CustomWidgets/CustomProgressbarWidget.dart';
import 'package:Surprize/Firestore/FirestoreOperations.dart';
import 'package:Surprize/Helper/AppHelper.dart';
import 'package:Surprize/LoginPage.dart';
import 'package:Surprize/Memory/UserMemory.dart';
import 'package:Surprize/Models/Player.dart';
import 'package:Surprize/PlayerDashboard.dart';
import 'package:Surprize/Resources/FirestoreResources.dart';
import 'package:Surprize/Resources/ImageResources.dart';
import 'package:Surprize/Resources/StringResources.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileSetUpPage extends StatefulWidget {

  FirebaseUser _firebaseUser;

  ProfileSetUpPage(this._firebaseUser);

  @override
  _ProfileSetUpPageState createState() => _ProfileSetUpPageState();
}

class _ProfileSetUpPageState extends State<ProfileSetUpPage> {


  final GlobalKey<FormState> _formKeyForPersonalInformation = GlobalKey<FormState>();
  bool _autoValidateForPersonalInformation = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  CustomLabelTextFieldWidget _nameField;
  CustomLabelTextFieldWidget _emailField;
  CustomDropDownWidget _genderDropDownWidget;
  CustomDatePickerWidget _dobDatePickerWidget;

  CustomCountryPickerWidget _countryPickerWidget;
  CustomPhoneNumberWidget _phoneNumberWidget;

  CustomProgressbarWidget _customRegistrationProgressBar = new CustomProgressbarWidget();


  @override
  void initState() {
    super.initState();
    _nameField = CustomLabelTextFieldWidget("Name", widget._firebaseUser.displayName != null?widget._firebaseUser.displayName:"",Colors.black, validation: AppHelper.validateName);
    _emailField = CustomLabelTextFieldWidget("Email", "",Colors.black, validation: AppHelper.validateEmail);
    _genderDropDownWidget=  CustomDropDownWidget(['Male', 'Female', 'Other'], "Male", "Gender",Colors.black, Colors.white);
    _dobDatePickerWidget = CustomDatePickerWidget(0,0,0, Colors.black);
    _countryPickerWidget = CustomCountryPickerWidget("Australia");
    _phoneNumberWidget = CustomPhoneNumberWidget("+61", "", Colors.black, validation: AppHelper.validatePhone);
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.purple[800]),
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(title: Text("Profile set up", style:TextStyle(fontFamily: 'Raleway'))),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                  decoration: BoxDecoration(
                    color: Colors.purple[800],
                  ),
                  height: 180,
                  child: Image.asset(ImageResources.appMainLogo),
                  alignment: FractionalOffset.center
              ),
              registrationFormPersonalInformation(),
            ],
          ),
        ),
      ),
    );
  }

  registrationFormPersonalInformation(){
    return Form(
      key: _formKeyForPersonalInformation,
      autovalidate: _autoValidateForPersonalInformation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
            child: Text(StringResources.registrationPagePersonalInformationHeaderDisplay,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Raleway')),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _nameField,
                  Visibility(visible:widget._firebaseUser.email == null, child: Padding(
                    padding: const EdgeInsets.only(top:16.0),
                    child: _emailField,
                  )),
                  Padding(
                    padding: const EdgeInsets.only(left: 1.0, top: 16.0,right: 1.0),
                    child: SizedBox(
                        width: double.infinity,
                        height: 48.0,
                        child: _genderDropDownWidget
                    ),
                  ),

                  Padding(
                      padding: const EdgeInsets.only(top: 24.0),
                      child: _dobDatePickerWidget
                  ),

                  Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: _countryPickerWidget
                  ),
                Visibility(
                  visible: widget._firebaseUser.phoneNumber == null,
                  child: Padding(
                    padding: const EdgeInsets.only(top:8.0),
                    child: _phoneNumberWidget,
                  ),
                ),
                  Padding(
                    padding: const EdgeInsets.only(left: 1.0, top: 32.0, right: 1.0),
                    child: Center(child: FlatButton(color:Colors.green,child:Text(StringResources.buttonCreateAccountText,style: TextStyle(color:Colors.white, fontSize: 18,fontFamily: 'Raleway')),onPressed: () => validateAndRegisterPlayer(),)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 1.0,top:4.0, right: 1.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 48.0,
                      child: FlatButton(child:Text("Log out",style: TextStyle(color:Colors.black, fontFamily: 'Raleway')),onPressed: (){
                          FirebaseAuth.instance.signOut().then((_){
                              AppHelper.cupertinoRouteWithPushReplacement(context, LoginPage());
                          });
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  validateDate(){
  return( _dobDatePickerWidget.m !=0 && _dobDatePickerWidget.d !=0 && _dobDatePickerWidget.y != 0);
  }
  /*
  Validate inputs
   */
  void validateAndRegisterPlayer(){

  if(!validateDate()){
    _dobDatePickerWidget.isProperlyValidated();
  }

  if(_formKeyForPersonalInformation.currentState.validate() && validateDate()) {
      _customRegistrationProgressBar.startProgressBar(context, "Setting up profile ...", Colors.white, Colors.black);
      registerPlayer();
    }
  }

  // Register player
  registerPlayer(){
    // Save user profile information to the database
    Player player = Player(
        widget._firebaseUser.uid, // Player Id
        _nameField.getValue(), // Player Name
        _dobDatePickerWidget.getSelectedDate(), // Player DOB
        "", // Player Address
        _countryPickerWidget.getValue(), // Player country
        _genderDropDownWidget.selectedItem(), // Player Gender
        widget._firebaseUser.email != null? widget._firebaseUser.email:_emailField.getValue(), // Player Email
        widget._firebaseUser.phoneNumber != null?widget._firebaseUser.phoneNumber:_phoneNumberWidget.getCountryCode() + " " + _phoneNumberWidget.getPhoneNumber(), // Player phone number
        DateTime.now(), // Player membership date
        widget._firebaseUser.photoUrl != null?widget._firebaseUser.displayName:""// Player profile Image URL (To be updated later)
    );


    FirestoreOperations().createData(FirestoreResources.userCollectionName, player.membershipId, player.toMap()).then((value){
      _customRegistrationProgressBar.stopAndEndProgressBar(context);
      UserMemory().savePlayer(player);
      Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) =>
              PlayerDashboard()));

    }).catchError((error){
      _customRegistrationProgressBar.stopAndEndProgressBar(context);
      AppHelper.showSnackBar(error.toString(), _scaffoldKey);
    });
  }
}
