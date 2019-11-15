import 'package:Surprize/Helper/AppHelper.dart';
import 'package:Surprize/Resources/FirestoreResources.dart';

class DLeaderboard{


  String id;
  String playerId;
  String playerName;
  String playerUrl;
  bool won;
  bool emailVerified;
  DateTime playedOn;
  int score;


  DLeaderboard(this.id,this.playerId, this.playerName, this.playerUrl,this.playedOn,this.score, this.won, this.emailVerified);

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map[FirestoreResources.fieldDQCid] = id;
    map[FirestoreResources.fieldDQCPlayerId] = playerId;
    map[FirestoreResources.fieldDQCPlayerName] = playerName;
    map[FirestoreResources.fieldPlayerProfileURL] = playerUrl;
    map[FirestoreResources.fieldDQCPlayerScore] = score;
    map[FirestoreResources.fieldDQCPlayerEmailVerified] = emailVerified;
    map[FirestoreResources.fieldDQCHasPlayerWon] = won;
    map[FirestoreResources.fieldDQCPlayedOn] = playedOn;
    return map;
  }

  DLeaderboard.fromMap(Map<String, dynamic> map){
    id = map[FirestoreResources.fieldDQCid];
    playerId = map[FirestoreResources.fieldDQCPlayerId];
    playerName = map[FirestoreResources.fieldDQCPlayerName];
    playerUrl = map[FirestoreResources.fieldPlayerProfileURL];
    score = map[FirestoreResources.fieldDQCPlayerScore];
    emailVerified = map[FirestoreResources.fieldDQCPlayerEmailVerified];
    won = map[FirestoreResources.fieldDQCHasPlayerWon];
    playedOn = AppHelper.convertToDateTime(map[FirestoreResources.fieldDQCPlayedOn]);
  }
}