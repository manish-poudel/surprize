import 'dart:async';

import 'package:surprize/Memory/UserMemory.dart';
import 'package:surprize/Models/Player.dart';

/// User bloc class to get all the profile.
class UserBLOC{

  final _playerStateController = StreamController<Player>.broadcast();
  StreamSink<Player> get _playerStream => _playerStateController.sink;
  Stream<Player> get player => _playerStateController.stream;

  final _playerEventController = StreamController<String>.broadcast();
  Sink get playerEventSink => _playerEventController.sink;

  /// Init controller
  init(){
    _playerEventController.stream.listen(_mapEventToState);
  }

  /// Map event to state
  _mapEventToState(String value){
    _playerStream.add(UserMemory().getPlayer());
  }

  /// Close all the controller
  dispose(){
    _playerStateController.close();
    _playerEventController.close();
  }
}