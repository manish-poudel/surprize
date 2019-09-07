import 'package:Surprize/Helper/AppHelper.dart';
import 'package:Surprize/Resources/FirestoreResources.dart';

class Activity {
  String id;
  ActivityType type;
  DateTime time;
  String reward;

  Activity(this.id, this.type, this.reward, this.time);

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map[FirestoreResources.fieldActivityId] = id;
    map[FirestoreResources.fieldActivityType] = getStringFromEnum(type);
    map[FirestoreResources.fieldActivityReward] = reward;
    map[FirestoreResources.fieldActivityTime] = time;
    return map;
  }

  Activity.fromMap(Map<String, dynamic> map) {
    id = map[FirestoreResources.fieldActivityId];
    type = _getEnumFromString(map[FirestoreResources.fieldActivityType]);
    reward = map[FirestoreResources.fieldActivityReward];
    time = AppHelper.convertToDateTime(map[FirestoreResources.fieldActivityTime]);
  }
}

/// Get string from enum
  getStringFromEnum(ActivityType activityType) {
  switch (activityType) {
    case ActivityType.EDITED_PROFILE:
      return "EDITED_PROFILE";
      break;
    case ActivityType.PLAYED_QUIZ:
      return "PLAYED_QUIZ";
      break;
    case ActivityType.SHARING_APP_TO_OTHER_APPS:
      return "SHARING_APP_TO_OTHER_APPS";
      break;
    case ActivityType.SHARING_APP_TO_FACEBOOK:
      return "SHARING_APP_TO_FACEBOOK";
      break;
    case ActivityType.UNKNOWN:
      return "UNKNOWN";
      break;
  }
}

/// Get enum from string
_getEnumFromString(String activityType) {
  switch (activityType) {
    case "EDITED_PROFILE":
      return ActivityType.EDITED_PROFILE;
      break;
    case "PLAYED_QUIZ":
      return ActivityType.PLAYED_QUIZ;
      break;
    case "SHARING_APP_TO_OTHER_APPS":
      return ActivityType.SHARING_APP_TO_OTHER_APPS;
      break;
    case "SHARING_APP_TO_FACEBOOK":
      return ActivityType.SHARING_APP_TO_FACEBOOK;
      break;
    case "UNKNOWN":
      return ActivityType.UNKNOWN;
      break;
  }
}

enum ActivityType { SHARING_APP_TO_OTHER_APPS, PLAYED_QUIZ, EDITED_PROFILE, UNKNOWN, SHARING_APP_TO_FACEBOOK}
