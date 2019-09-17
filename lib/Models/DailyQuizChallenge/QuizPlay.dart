import 'package:Surprize/Helper/AppHelper.dart';
import 'package:Surprize/Models/DailyQuizChallenge/enums/PlayState.dart';
import 'package:Surprize/Resources/FirestoreResources.dart';

class QuizPlay{
  PlayState playState;
  DateTime playedOn;
  String playedQuizId;
  String playedQuizName;

  QuizPlay(this.playState, this.playedOn, this.playedQuizId, this.playedQuizName);

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map[FirestoreResources.fieldDailyQuizPlayState] = convertEnumToString(playState);
    map[FirestoreResources.fieldDailyQuizLastPlayed] = playedOn;
    map[FirestoreResources.fieldDailyQuizPlayedId] = playedQuizId;
    map[FirestoreResources.fieldDailyQuizPlayedName] = playedQuizName;
    return map;
  }

  QuizPlay.fromMap(Map<String, dynamic> map){
    playState =  convertStringToEnum(map[FirestoreResources.fieldDailyQuizPlayState]);
    playedOn =  AppHelper.convertToDateTime(map[FirestoreResources.fieldDailyQuizLastPlayed]);
    playedQuizId = map[FirestoreResources.fieldDailyQuizPlayedId];
    playedQuizName = map[FirestoreResources.fieldDailyQuizPlayedName];
  }

  /// Convert enum to string
  PlayState convertStringToEnum(String playState){
    switch(playState){
      case "WON":
        return PlayState.WON;
      case "LOST":
        return PlayState.LOST;
      default:
        return PlayState.UNKNOWN;
    }
  }

  /// Convert enum to string
  static String convertEnumToString(PlayState playState) {
    switch (playState) {
      case PlayState.WON:
        return "WON";
      case PlayState.LOST:
        return "LOST";
      default:
        return "UNKNOWN";
    }
  }
}