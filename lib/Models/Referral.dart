import 'package:Surprize/Helper/AppHelper.dart';
import 'package:Surprize/Resources/FirestoreResources.dart';

class Referral{
  String id;
  String code;
  DateTime createdAt;
  String createdBy;

  Referral(this.id, this.code, this.createdAt, this.createdBy);

  Referral.fromMap(Map<String, dynamic> map) {
    id = map[FirestoreResources.fieldReferralId];
    code = map[FirestoreResources.fieldReferralCode];
    createdAt = AppHelper.convertToDateTime(map[FirestoreResources.fieldReferralCreateDate]);
    createdBy = map[FirestoreResources.fieldReferralCreator];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map[FirestoreResources.fieldReferralId] = id;
    map[FirestoreResources.fieldReferralCode] = code;
    map[FirestoreResources.fieldReferralCreateDate] = createdAt;
    map[FirestoreResources.fieldReferralCreator] = createdBy;

    return map;
  }
}