
import 'package:Surprize/Memory/UserMemory.dart';
import 'package:Surprize/Models/Referral.dart';
import 'package:Surprize/Resources/FirestoreResources.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';

class ShareApp{

  String referralId;
  String referralCode;

   shareAppToMedia(int score) async {
    String code = createReferralCode();
    String body = "Referral code: " + code + "\n" + "Use this code while registration to earn points! \n \n" + "A chance to win cash prize and many more. Download app by clicking on the link:";
    Share.text("Surprize", body, 'text/plain');
    saveReferralCode();
  }

  shareQuizLetter(String body) async {
     String code = createReferralCode();
     String finalBody  = "Referral code: " + code + "\n" + "Use this code while registration to earn points! " + "\n \n Did you know? \n" +body + "\n \n A chance to win cash prize and many more. Download app by clicking on the link:";
     Share.text("Surprize Fun Facts ", finalBody, 'text/plain');
     saveReferralCode();
  }


  /*
  Create referral code
   */
  String createReferralCode(){
    referralId = Firestore.instance.collection(FirestoreResources.fieldReferralCollection).document().documentID;
    String month = DateTime.now().month.toString();
    String day = DateTime.now().day.toString();
    String second = DateTime.now().second.toString();
    referralCode =  referralId.substring(1, 2) + referralId.substring(referralId.length - 4, referralId.length) + month + day  + second;
    referralCode =  referralCode.toUpperCase();
    return referralCode;
  }


  // Save referral code
  saveReferralCode(){
    Firestore.instance.collection(FirestoreResources.fieldReferralCollection).document(referralId).setData(
      Referral(referralId, referralCode, DateTime.now(), UserMemory().getPlayer().membershipId).toMap()
    );
  }
}