import 'dart:async';
import 'dart:io';

import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class SoundHelper{
  AudioPlayer _audioPlayer;
  String _filename;
  String _location;
  bool _loop = false;
  /*
  Loading assets.
   */
  Future<ByteData> loadAsset(String location) async {
    return await rootBundle.load(location);
  }

  loop(bool loop){
    _loop = loop;
  }

  Future<void> playBackgroundSound(String filename, String location) async{
    this._filename = filename;
    this._location = location;
    _audioPlayer = new AudioPlayer();
    try {
      final file = new File('${(await getTemporaryDirectory()).path}/$filename');
      await file.writeAsBytes((await loadAsset(location)).buffer.asUint8List());
      await _audioPlayer.play(file.path, isLocal: true);
      if(_loop){
        loopSound();
      }
    }
    catch(error){
      print(error);
    }
  }

  /// Loop sound
  void loopSound(){
    _audioPlayer.onPlayerStateChanged.listen((val){
      if(val == AudioPlayerState.COMPLETED){
        playBackgroundSound(_filename, _location);
      }
    });
  }

  void stopSound(){
    if(_audioPlayer != null) {
      try {
        _audioPlayer.stop();
      }
      catch(error){
        print(error);
      }
    }
  }
}