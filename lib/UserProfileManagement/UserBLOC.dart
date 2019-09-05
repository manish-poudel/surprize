import 'dart:async';

import 'package:surprize/Memory/UserMemory.dart';
import 'package:surprize/Models/Player.dart';


class UserBLOC{

  Player _player;

  final _playerStateController = StreamController<Player>.broadcast();
  StreamSink<Player> get _playerStream => _playerStateController.sink;
  Stream<Player> get player => _playerStateController.stream;

  final _playerEventController = StreamController<String>.broadcast();
  Sink get playerEventSink => _playerEventController.sink;

  init(){
    _playerEventController.stream.listen(_mapEventToState);
  }

  _mapEventToState(String value){
    _playerStream.add(UserMemory().getPlayer());
  }


  dispose(){
    _playerStateController.close();
    _playerEventController.close();
  }
}