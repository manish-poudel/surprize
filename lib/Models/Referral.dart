import 'package:Surprize/Helper/AppHelper.dart';
import 'package:Surprize/Models/ReferralState.dart';
import 'package:Surprize/Resources/FirestoreResources.dart';

class Referral{
  String id;
  String code;
  DateTime createdAt;
  String createdBy;
  String usedBy;
  ReferralState referralState;
  ReferralAccountState referralAccountStateForSender;
  ReferralAccountState referralAccountStateForReceiver;

  Referral(this.id, this.code, this.createdAt, this.createdBy, this.referralState,this.usedBy, this.referralAccountStateForSender,this.referralAccountStateForReceiver);

  Referral.fromMap(Map<String, dynamic> map) {
    id = map[FirestoreResources.fieldReferralId];
    code = map[FirestoreResources.fieldReferralCode];
    createdAt = AppHelper.convertToDateTime(map[FirestoreResources.fieldReferralCreateDate]);
    createdBy = map[FirestoreResources.fieldReferralCreator];
    usedBy= map[FirestoreResources.fieldReferralUsedBy];
    referralAccountStateForSender = getEnumFromAccountStateString(map[FirestoreResources.fieldReferralAccountStateSender]);
    referralAccountStateForReceiver =getEnumFromAccountStateString(map[FirestoreResources.fieldReferralAccountStateReceiver]);
    referralState = getEnumFromString(map[FirestoreResources.fieldReferralState]);
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map[FirestoreResources.fieldReferralId] = id;
    map[FirestoreResources.fieldReferralCode] = code;
    map[FirestoreResources.fieldReferralCreateDate] = createdAt;
    map[FirestoreResources.fieldReferralCreator] = createdBy;
    map[FirestoreResources.fieldReferralUsedBy] = usedBy;
    map[FirestoreResources.fieldReferralAccountStateSender] = getStringFromAccountStateEnum(referralAccountStateForSender);
    map[FirestoreResources.fieldReferralAccountStateReceiver] = getStringFromAccountStateEnum(referralAccountStateForReceiver);
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
      case ReferralState.REWARDED:
        return "REWARDED";
        break;
      case ReferralState.UNKNOWN:
        return "UNKNOWN";
        break;
    }
  }

  /// Get string from enum
  getStringFromAccountStateEnum(ReferralAccountState referralState) {
    switch (referralState) {
      case ReferralAccountState.ACCOUNT_VERIFIED:
        return "ACCOUNT_VERIFIED";
        break;
      case ReferralAccountState.PENDING_VERIFICATION:
        return "PENDING_VERIFICATION";
        break;

      case ReferralAccountState.UNKNOWN:
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
      case "REWARDED":
        return ReferralState.REWARDED;
        break;
      case "UNKNOWN":
        return ReferralState.UNKNOWN;
        break;
    }
  }

  /// Get enum from string
  getEnumFromAccountStateString(String referralAccountState) {
    switch (referralAccountState) {
      case "ACCOUNT_VERIFIED":
        return ReferralAccountState.ACCOUNT_VERIFIED;
        break;
      case "PENDING_VERIFICATION":
        return ReferralAccountState.PENDING_VERIFICATION;
        break;
      case "UNKNOWN":
        return ReferralAccountState.UNKNOWN;
        break;
    }
  }
}