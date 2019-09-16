
import 'dart:io';
import 'dart:typed_data';

import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:Surprize/Resources/ImageResources.dart';
import 'package:social_share_plugin/social_share_plugin.dart';

class ShareApp{

  Future<String> shareAfterGamePlay(int score) async {
    final ByteData bytes = await rootBundle.load(ImageResources.appMainLogo);
    await Share.file('Surprize image', 'appMainLogo.png', bytes.buffer.asUint8List(), 'image/png', text: ''
        'Share code: xyz ) \n'
        'Applicable for sharer only: Go to app>share> and past this code to get point for your work \n \n'
        'Play and earn money! \n'
        'https://play.google.com/store/apps/details?id=com.talkmydoc.blyaank.barunste&hl=en \n'
        'Click the link above');

    return "SUCCESS";
  }

  Future shareQuizLetter(String url, String body) async {
    var request = await HttpClient().getUrl(Uri.parse(url));
    var response = await request.close();
    Uint8List bytes = await consolidateHttpClientResponseBytes(response);
    await Share.file("Fun facts", 'amlog.jpg', bytes, 'image/jpg',text: body);
  }

  shareToFacebook(int score) async {
    File file = await ImagePicker.pickImage(source:ImageSource.gallery);
    await SocialSharePlugin.shareToFeedFacebook('Surprize', file.path);
  }


}