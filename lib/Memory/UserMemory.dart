
import 'package:Surprize/Models/Player.dart';

class UserMemory {
  static final UserMemory _userMemory =
  new UserMemory._internal();

  Player _player;


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
}