import 'package:Surprize/CustomWidgets/CustomLabelTextFieldWidget.dart';

import 'package:Surprize/FirebaseMessaging/PushNotification/PushNotification.dart';

import 'package:Surprize/Memory/UserMemory.dart';
import 'package:Surprize/Models/Player.dart';

import 'package:Surprize/ProfileSetUpPage.dart';
import 'package:Surprize/Resources/FirestoreResources.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Surprize/Firestore/FirestoreOperations.dart';
import 'package:Surprize/Resources/ImageResources.dart';
import 'package:Surprize/Resources/StringResources.dart';

import 'CustomWidgets/CustomAppBar.dart';
import 'Helper/AppHelper.dart';
import 'package:Surprize/CustomWidgets/LoginPage/CustomLoginCredentialRegWidget.dart';
import 'CustomWidgets/CustomProgressbarWidget.dart';

class RegistrationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return RegistrationPageState();
  }
}

class RegistrationPageState extends State<RegistrationPage>
    with SingleTickerProviderStateMixin {
  CustomLabelTextFieldWidget _nameField;


  // keys
  final GlobalKey<FormState> _formKeyForLoginInformation =
  GlobalKey<FormState>();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _autoValidateForLoginInformation = false;

  FirebaseUser _firebaseUser;

  BuildContext _context;

  @override
  void initState() {
    super.initState();
    _nameField = CustomLabelTextFieldWidget("Name", "", Colors.black, false,
        validation: AppHelper.validateName);
  }

  // Form widgets
  CustomLoginCredentialRegWidget _customLoginCredentialRegWidget =
  CustomLoginCredentialRegWidget();
  CustomProgressbarWidget _customLoginProgressbar =
  new CustomProgressbarWidget();

  @override
  Widget build(BuildContext context) {
    this._context = context;
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.purple[800]),
      home: Scaffold(
        key: _scaffoldKey,
        appBar: CustomAppBar("Registration", context),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(ImageResources.appBackgroundImage),
                          fit: BoxFit.cover)),
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.3,
                  child: Image.asset(ImageResources.appMainLogo),
                  alignment: FractionalOffset.center),
              registrationFormLoginInformation(),
            ],
          ),
        ),
      ),
    );
  }

  // Registration form login
  registrationFormLoginInformation() {
    return Form(
      key: _formKeyForLoginInformation,
      autovalidate: _autoValidateForLoginInformation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
            child: Text(
                StringResources.registrationPageLoginCredentialHeaderDisplay,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Raleway')),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
            child: _nameField,
          ),
          _customLoginCredentialRegWidget,

          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Center(
                child: FlatButton(
                    color: Colors.green,
                    child: Text("Create",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontFamily: 'Raleway')),
                    onPressed: () => onPressedLoginInformationNextButton())),
          )
        ],
      ),
    );
  }

  onPressedLoginInformationNextButton() async {
    if (!_formKeyForLoginInformation.currentState.validate()) return;

    _customLoginProgressbar.startProgressBar(
        context, "Registering...", Colors.white, Colors.black);
    registerPlayer();
  }


  // Register user
  void registerPlayer() {
    FirestoreOperations()
        .regUser(_customLoginCredentialRegWidget.getEmail(),
        _customLoginCredentialRegWidget.getPassword())
        .then((firebaseUser) {
      _firebaseUser = firebaseUser;
      registerProfileInformation();
    }).catchError((error) {
      _customLoginProgressbar.stopAndEndProgressBar(context);
      AppHelper.showSnackBar(error.toString(), _scaffoldKey);
    });
    // Creating authentication
  }

  /// Register profile information
  registerProfileInformation() {
    // Save user profile information to the database
    Player player = Player(
        _firebaseUser.uid,
        // Player Id
        _nameField.getValue(),
        // Player Name
        "",
        // Player DOB
        "",
        // Player Address
        "",
        // Player country
        "",
        // Player Gender
        _customLoginCredentialRegWidget.getEmail(),
        // Player Email
        "",
        DateTime.now(),
        // Player membership date
        "" // Player profile Image URL (To be updated later)
    );

    FirestoreOperations()
        .createData(FirestoreResources.userCollectionName, player.membershipId,
        player.toMap())
        .then((value) {
      _customLoginProgressbar.stopAndEndProgressBar(context);

      UserMemory().savePlayer(player);
      UserMemory().saveFirebaseUser(_firebaseUser);

      PushNotification().configure(context);
      PushNotification().saveToken(UserMemory().getPlayer().membershipId);

      Navigator.of(context).popUntil((route) => route.isFirst);
      AppHelper.cupertinoRouteWithPushReplacement(_context, ProfileSetUpPage(_firebaseUser));
    }).catchError((error) {
      _customLoginProgressbar.stopAndEndProgressBar(context);
      AppHelper.showSnackBar(error.toString(), _scaffoldKey);
    });
  }
}
