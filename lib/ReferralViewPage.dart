import 'package:Surprize/AppShare/ShareApp.dart';
import 'package:Surprize/CustomWidgets/CustomAppBar.dart';
import 'package:Surprize/Memory/UserMemory.dart';
import 'package:Surprize/Models/Referral.dart' as prefix0;
import 'package:Surprize/Models/Referral.dart';
import 'package:Surprize/Models/ReferralState.dart';
import 'package:Surprize/Resources/FirestoreResources.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReferralViewPage extends StatefulWidget {
  @override
  _ReferralViewPageState createState() => _ReferralViewPageState();
}

class _ReferralViewPageState extends State<ReferralViewPage> {

  Map<String, Referral> userReferral= new Map();
  int activeReferralCode = 0;
  int completedReferralCode = 0;
  FirebaseUser user;

  @override
  void initState() {
    super.initState();
    getReferralCode();
    user = UserMemory().firebaseUser;
    user.reload();
  }

  /// Get referral code from database.
  getReferralCode(){
      Firestore.instance.collection(FirestoreResources.fieldReferralCollection).where(FirestoreResources.fieldReferralCreator,isEqualTo: UserMemory().firebaseUser.uid)
          .snapshots().listen((querySnapshot){
            activeReferralCode = 0;
            completedReferralCode = 0;
            querySnapshot.documents.forEach((documentSnapshot){
                Referral referral = prefix0.Referral.fromMap(documentSnapshot.data);
                if(referral.referralState == ReferralState.ACTIVE) {
                    activeReferralCode++;
                  }
                if(referral.referralState == ReferralState.REWARDED){
                  completedReferralCode++;
                }
                setState(() {
                  if(userReferral.containsKey(referral.id)){
                    userReferral[referral.id] = referral;
                  }
                  else {
                    userReferral.putIfAbsent(referral.id, () => referral);
                  }
                });
            });
      });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.purple[800]),
      home: Scaffold(
        appBar: CustomAppBar("Referral", context),
        body: referralBody(),
      ),
    );
  }

  /// Main referral body
  Widget referralBody(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Visibility(
              visible: userReferral.length != 0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                  Text("Pending: " + activeReferralCode.toString(), style: TextStyle(fontFamily: "Raleway", color:Colors.blueGrey[500],fontWeight: FontWeight.w700, fontSize: 18)),
                  Text("Completed: "+ completedReferralCode.toString(), style: TextStyle(fontFamily: "Raleway", color:Colors.blueGrey[500],fontWeight: FontWeight.w700, fontSize: 18))
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top:16.0, left:16.0),
              child: Text("Referral code generated by you", style: TextStyle(fontFamily: "Raleway", color:Colors.blueGrey[200],fontWeight: FontWeight.w700, fontSize: 18)),
            ),
            Padding(
              padding: const EdgeInsets.only(top:8.0, left:16.0),
              child: Text("Note: You will get point for your referral once account from both parties (sender and receiver) is verified", style: TextStyle(fontFamily: "Raleway", color:Colors.blueGrey[200],fontWeight: FontWeight.w700, fontSize: 14)),
            ),
            Padding(
              padding: const EdgeInsets.only(top:8.0, left:16.0,bottom: 16.0),
              child: Row(
                children: <Widget>[
                  Text("Your account status: ", style: TextStyle(fontFamily: "Raleway", color:Colors.blueGrey[200],fontWeight: FontWeight.w700, fontSize: 14)),
                  Text(user.isEmailVerified?" Verified ": " Not verified", style: TextStyle(fontFamily: "Raleway", color:user.isEmailVerified?Colors.green[200]:Colors.red[200],fontWeight: FontWeight.w700, fontSize: 14)),
                ],
              ),
            ),
            referralListView()
          ],
        ),
      ),
    );
  }

  /// Get referral state string
  Widget getReferralState(Referral referral){
    return Column(
      children: <Widget>[
        referralCodeStateDisplay(referral.usedBy.isNotEmpty?"Code used":"Waiting for code usage",referral.usedBy.isNotEmpty?Icons.check:Icons.fiber_manual_record, referral.usedBy.isNotEmpty?Colors.green:Colors.grey),
        referralCodeStateDisplay(referral.referralAccountStateForReceiver == ReferralAccountState.ACCOUNT_VERIFIED?"Receiver account verified":"Receiver account not verified",referral.referralAccountStateForReceiver == ReferralAccountState.ACCOUNT_VERIFIED?Icons.check:Icons.fiber_manual_record, referral.referralAccountStateForReceiver == ReferralAccountState.ACCOUNT_VERIFIED?Colors.green:Colors.grey),
        referralCodeStateDisplay(referral.referralState == ReferralState.REWARDED?"Rewarded point":"Not rewarded",referral.referralState == ReferralState.REWARDED?Icons.check:Icons.fiber_manual_record, referral.referralState == ReferralState.REWARDED?Colors.green:Colors.grey)
      ],
    );
  }

  Widget referralCodeStateDisplay(String text, IconData icon, Color color){
    return Row(
      children: <Widget>[
        Icon(icon,size: 12,color: color),
        Padding(
          padding: const EdgeInsets.only(left:4.0),
          child: Text(text,style: TextStyle(fontFamily: "Raleway", color: color)),
        ),
      ],
    );
  }

  /// Referral view
  Widget referralListTileView(Referral referral){
    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(referral.code),
          Padding(
            padding: const EdgeInsets.only(top:8.0),
            child: getReferralState(referral),
          ),
        ],
      ),
    );
  }

  /// Referral list view
  Widget referralListView(){
    List<Referral> referralList = userReferral.values.toList();

    if(referralList.length == 0) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Empty Referral. Share app with your friend to create referral code and earn point.",textAlign: TextAlign.center, style: TextStyle(
                  fontSize: 14, fontFamily: 'Raleway', color: Colors.grey)),
            ],
          ),
        ),
      );
    }

    return Container(
      child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount: referralList.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.only(left:8.0, right: 8.0),
              child: Card(child: Column(
                children: <Widget>[
                  referralListTileView(referralList[index]),
                  Visibility(visible: referralList[index].referralState == ReferralState.ACTIVE,
                      child: FlatButton(child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Share", style:TextStyle(fontSize:16,color:Colors.blueGrey))
                        ],
                      ),onPressed: () => ShareApp().shareCode(referralList[index].code))
                  )
                ],
              )),
            );
          }),
    );
  }

}
