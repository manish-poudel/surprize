import 'dart:async';

import 'package:Surprize/AppIntroPage.dart';

import 'package:Surprize/CustomWidgets/CustomLabelTextFieldWidget.dart';

import 'package:Surprize/Helper/AppHelper.dart';
import 'package:Surprize/Leaderboard/LeaderboardManager.dart';

import 'package:Surprize/Models/Referral.dart';

import 'package:Surprize/Resources/FirestoreResources.dart';
import 'package:Surprize/Resources/ImageResources.dart';
import 'package:Surprize/Resources/StringResources.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class ProfileSetUpPage extends StatefulWidget {

  FirebaseUser _firebaseUser;

  ProfileSetUpPage(this._firebaseUser);

  @override
  _ProfileSetUpPageState createState() => _ProfileSetUpPageState();
}

class _ProfileSetUpPageState extends State<ProfileSetUpPage> {


  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  CustomLabelTextFieldWidget _customReferralLabelTextField;

  @override
  void initState() {
    super.initState();

    _customReferralLabelTextField = CustomLabelTextFieldWidget("Referral code","",Colors.black, false, enabled: true);
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.purple[800]),
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(title: Text("Referral code", style:TextStyle(fontFamily: 'Raleway'))),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                  decoration: BoxDecoration(
                      image:DecorationImage(image: AssetImage(ImageResources.appBackgroundImage), fit: BoxFit.cover)
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
          child: Text(StringResources.referralCodeText,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Raleway')),
        ),
        Padding(
          padding: const EdgeInsets.only(top:32.0, left:16.0,right:16.0),
          child: _customReferralLabelTextField,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 1.0, top: 32.0, right: 1.0),
          child: Center(child: FlatButton(color:Colors.green,child:Text(StringResources.buttonCreateAccountText,style: TextStyle(color:Colors.white, fontSize: 18,fontFamily: 'Raleway')),onPressed: () => enterReferralCode(),)),
        ),

        Padding(
          padding: const EdgeInsets.only(left: 1.0, top: 32.0, right: 1.0),
          child: Center(child: FlatButton(child:Text("Skip",style: TextStyle(color:Colors.grey, fontSize: 18,fontFamily: 'Raleway')),onPressed: () => skip())),
        ),
              ],
            );
  }

  enterReferralCode() async {
    if(_customReferralLabelTextField.getValue().isNotEmpty){
      if(await checkForReferralCode()) {
        deleteReferralCode();
        AppHelper.cupertinoRouteWithPushReplacement(context, AppIntroPage("FIRST_TIME_USER"));
      }
      else{
        AppHelper.showSnackBar("Referral code not found! Check uppercase and lowercase letters!", _scaffoldKey);
      }
    }
    else{
        AppHelper.showSnackBar("Empty referral code", _scaffoldKey);
    }
  }

  skip(){
    AppHelper.cupertinoRouteWithPushReplacement(context, AppIntroPage("FIRST_TIME_USER"));
  }

  Future<bool> checkForReferralCode() async {
   QuerySnapshot querySnapshot =  await Firestore.instance.collection(FirestoreResources.fieldReferralCollection).where(FirestoreResources.fieldReferralCode, isEqualTo:_customReferralLabelTextField.getValue())
        .getDocuments();
   return querySnapshot.documents.isNotEmpty;
  }

  /// Delete Referral code
  void deleteReferralCode() {
    Firestore.instance.collection(FirestoreResources.fieldReferralCollection).where(FirestoreResources.fieldReferralCode
    , isEqualTo: _customReferralLabelTextField.getValue()).getDocuments().then((snapshot){
      snapshot.documents.forEach((docSnapshot){
        Referral referral = Referral.fromMap(docSnapshot.data);
        updateScore(referral.createdBy);
        Firestore.instance.collection(FirestoreResources.fieldReferralCollection).document(docSnapshot.documentID).delete();
      });
    });
  }

  /// Update score
  void updateScore(String id) {
      LeaderboardManager().saveForAllTimeScore(id, 10, (value){

      });
      LeaderboardManager().saveForWeeklyScore(id, 10, (value){

      });
      LeaderboardManager().saveForAllTimeScore(widget._firebaseUser.uid, 5, (value){

      });
      LeaderboardManager().saveForWeeklyScore(widget._firebaseUser.uid,5, (value){

      });

  }

}
