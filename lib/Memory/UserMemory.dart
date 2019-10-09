
import 'package:Surprize/Models/Player.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserMemory {
  static final UserMemory _userMemory =
  new UserMemory._internal();

  Player _player;
  FirebaseUser firebaseUser;
  bool gamePlayed = false;
  bool adShown = false;

  factory UserMemory() {
    return _userMemory;
  }

  UserMemory._internal();

  /// Save player
   savePlayer(Player player) {
    this._player = player;
  }

  /// Get player
  Player getPlayer() {
    return this._player;
  }

  // Save firebase
  saveFirebaseUser(FirebaseUser firebaseUser){
     this.firebaseUser = firebaseUser;
  }
}