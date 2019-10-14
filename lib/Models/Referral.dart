import 'package:Surprize/Helper/AppHelper.dart';
import 'package:Surprize/Models/ReferralState.dart';
import 'package:Surprize/Resources/FirestoreResources.dart';

class Referral{
  String id;
  String code;
  DateTime createdAt;
  String createdBy;
  ReferralState referralState;

  Referral(this.id, this.code, this.createdAt, this.createdBy, this.referralState);

  Referral.fromMap(Map<String, dynamic> map) {
    id = map[FirestoreResources.fieldReferralId];
    code = map[FirestoreResources.fieldReferralCode];
    createdAt = AppHelper.convertToDateTime(map[FirestoreResources.fieldReferralCreateDate]);
    createdBy = map[FirestoreResources.fieldReferralCreator];
    referralState = getEnumFromString(map[FirestoreResources.fieldReferralState]);
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map[FirestoreResources.fieldReferralId] = id;
    map[FirestoreResources.fieldReferralCode] = code;
    map[FirestoreResources.fieldReferralCreateDate] = createdAt;
    map[FirestoreResources.fieldReferralCreator] = createdBy;
    map[FirestoreResources.fieldReferralState] = getStringFromEnum(referralState);

    return map;
  }


  /// Get string from enum
  getStringFromEnum(ReferralState referralState) {
    switch (referralState) {
      case ReferralState.ACTIVE:
        return "ACTIVE";
        break;
      case ReferralState.COMPLETED:
        return "COMPLETED";
        break;
      case ReferralState.UNKNOWN:
        return "UNKNOWN";
        break;
    }
  }

  /// Get enum from string
  getEnumFromString(String referralState) {
    switch (referralState) {
      case "ACTIVE":
        return ReferralState.ACTIVE;
        break;
      case "COMPLETED":
        return ReferralState.COMPLETED;
        break;
      case "UNKNOWN":
        return ReferralState.UNKNOWN;
        break;
    }
  }
}