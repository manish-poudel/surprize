
import 'package:Surprize/Memory/UserMemory.dart';
import 'package:Surprize/Models/Referral.dart';
import 'package:Surprize/Models/ReferralState.dart';
import 'package:Surprize/Resources/FirestoreResources.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ShareApp{

  String referralId;
  String referralCode;

  /// Share app
   shareAppToMedia() async {
    String code = createReferralCode();
    String body = "Referral code: " + code + "\n" + "Use this code while registration to earn points! \n \n" + "A chance to win cash prize and many more. Download app by clicking on the link: \n https://play.google.com/store/apps/details?id=com.siliconguy.surprize";
    Share.text("Surprize", body, 'text/plain');
    saveReferralCode();
  }

  /// Share code only
  shareCode(String code){
    String body = "Referral code: " + code + "\n" + "Use this code while registration to earn points! \n \n" + "A chance to win cash prize and many more. Download app by clicking on the link: \n https://play.google.com/store/apps/details?id=com.siliconguy.surprize";
    Share.text("Surprize", body, 'text/plain');
  }

  shareAppFromDQC(){
    String code = createReferralCode();
    String body = "Yay!!! I just won cash prize by playing Surprize Challenge!\nYou can win too! \n\nDownload app by clicking on the link below and don't forget to use referral code to earn points! \n\nReferral code: " + code + "\n" +"https://play.google.com/store/apps/details?id=com.siliconguy.surprize";
    Share.text("Surprize", body, 'text/plain');
    saveReferralCode();
  }

  shareQuizLetter(String body) async {
     String code = createReferralCode();
     String finalBody  = "Referral code: " + code + "\n" + "Use this code while registration to earn points! " + "\n \n Did you know? \n" +body + "\n \n A chance to win cash prize and many more. Download app by clicking on the link: \n https://play.google.com/store/apps/details?id=com.siliconguy.surprize";
     Share.text("Surprize Fun Facts ", finalBody, 'text/plain');
     saveReferralCode();
  }


 /// Create referral code
  String createReferralCode(){
    referralId = Firestore.instance.collection(FirestoreResources.fieldReferralCollection).document().documentID;
    String month = DateTime.now().month.toString();
    String day = DateTime.now().day.toString();
    String second = DateTime.now().second.toString();
    referralCode =  referralId.substring(1, 2) + referralId.substring(referralId.length - 4, referralId.length) + month + day  + second;
    referralCode =  referralCode.toUpperCase();
    return referralCode;
  }


  /// Save referral code
  saveReferralCode(){
     FirebaseUser firebaseUser = UserMemory().firebaseUser;
     firebaseUser.reload();

    Firestore.instance.collection(FirestoreResources.fieldReferralCollection).document(referralId).setData(
      Referral(referralId, referralCode, DateTime.now(), UserMemory().getPlayer().membershipId, ReferralState.ACTIVE,"",firebaseUser.isEmailVerified?ReferralAccountState.ACCOUNT_VERIFIED:ReferralAccountState.PENDING_VERIFICATION, ReferralAccountState.UNKNOWN).toMap()
    );
  }
}