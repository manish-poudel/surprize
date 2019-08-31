import 'package:surprize/Models/Player.dart';

class Leaderboard{
  int _rank;
  Player _player;
  int _score;

  Leaderboard(this._rank, this._player, this._score);

  int get rank => _rank;
  Player get player => _player;
  int get score => _score;
}