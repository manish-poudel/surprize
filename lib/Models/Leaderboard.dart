import 'package:Surprize/Models/Player.dart';

class Leaderboard{
  int _rank;
  Player _player;
  int _score;
  bool _isEmailVerified;

  Leaderboard(this._rank, this._player, this._score, this._isEmailVerified);

  int get rank => _rank;
  Player get player => _player;
  int get score => _score;
  bool get isEmailVerified => _isEmailVerified;

  set rank(int rank) => _rank = rank;
  set player(Player player) => _player = player;
  set score(int score) => _score = score;
  set isEmailVerified(bool verified) => _isEmailVerified = verified;
}