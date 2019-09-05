import 'package:surprize/Helper/AppHelper.dart';
import 'package:surprize/Resources/FirestoreResources.dart';

class Activity {
  String id;
  ActivityType type;
  DateTime time;
  String reward;

  Activity(this.id, this.type, this.reward, this.time);

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map[FirestoreResources.fieldActivityId] = id;
    map[FirestoreResources.fieldActivityType] = _getStringFromEnum(type);
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
_getStringFromEnum(ActivityType activityType) {
  switch (activityType) {
    case ActivityType.EDITED_PROFILE:
      return "EDITED_PROFILE";
      break;
    case ActivityType.PLAYED_QUIZ:
      return "PLAYED_QUIZ";
      break;
    case ActivityType.SHARING_APP:
      return "SHARING_APP";
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
    case "SHARING_APP":
      return ActivityType.SHARING_APP;
      break;
    case "UNKNOWN":
      return ActivityType.UNKNOWN;
      break;
  }
}

enum ActivityType { SHARING_APP, PLAYED_QUIZ, EDITED_PROFILE, UNKNOWN }
