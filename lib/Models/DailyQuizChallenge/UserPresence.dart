import 'package:Surprize/Helper/AppHelper.dart';
import 'package:Surprize/Models/DailyQuizChallenge/enums/UserPresenceState.dart';
import 'package:Surprize/Resources/FirestoreResources.dart';

class UserPresence {
  UserPresenceState state;
  DateTime changedAt;

  UserPresence(this.state, this.changedAt);

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map[FirestoreResources.fieldUserPresenceState] = convertEnumToString(state);
    map[FirestoreResources.fieldUserPresenceStateChangedTime] = changedAt;
    return map;
  }

  UserPresence.fromMap(Map<String, dynamic> map){
    state = convertStringToEnum(map[FirestoreResources.fieldUserPresenceState]);
    changedAt = AppHelper.convertToDateTime(
        map[FirestoreResources.fieldUserPresenceStateChangedTime]);
  }


  /// Convert enum to string
  UserPresenceState convertStringToEnum(String userPresenceState) {
    switch (userPresenceState) {
      case "ONLINE":
        return UserPresenceState.ONLINE;
      case "PLAYED_GAME_AND_EXITED":
        return UserPresenceState.PLAYED_GAME_AND_EXITED;
      case "END_GAME_ABRUPTLY":
        return UserPresenceState.END_GAME_ABRUPTLY;
      default:
        return UserPresenceState.UNKNOWN;
    }
  }

  /// Convert enum to string
  static String convertEnumToString(UserPresenceState userPresenceState) {
    switch (userPresenceState) {
      case UserPresenceState.ONLINE:
        return "ONLINE";
      case UserPresenceState.PLAYED_GAME_AND_EXITED:
        return "PLAYED_GAME_AND_EXITED";
      case UserPresenceState.END_GAME_ABRUPTLY:
        return "END_GAME_ABRUPTLY";
      default:
        return "UNKNOWN";
    }
  }
}