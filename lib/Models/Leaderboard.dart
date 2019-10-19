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
}