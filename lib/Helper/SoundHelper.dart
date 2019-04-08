import 'dart:async';
import 'dart:io';

import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class SoundHelper{
  AudioPlayer _audioPlayer;
  /*
  Loading assets.
   */
  Future<ByteData> loadAsset(String location) async {
    return await rootBundle.load(location);
  }

  Future<void> playBackgroundSound(String filename, String location) async{
    _audioPlayer = new AudioPlayer();
    try {
      final file = new File('${(await getTemporaryDirectory()).path}/$filename');
      await file.writeAsBytes((await loadAsset(location)).buffer.asUint8List());
      await _audioPlayer.play(file.path, isLocal: true);
    }
    catch(error){
      print(error);
    }
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