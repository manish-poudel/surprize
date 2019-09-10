import 'package:flutter/services.dart';
import 'package:Surprize/Resources/ChannelResources.dart';


class FacebookShare{

  final MethodChannel platform =  MethodChannel(ChannelResources.channelFacebookShare);

  /// Get value
   shareToFacebook() async {
    return await platform.invokeMethod(ChannelResources.methodFacebookShareInvokeString);
  }

  /// Get value
  shareToFacebookWithScore(int value) async {
    return await platform.invokeMethod(ChannelResources.methodFacebookShareWithScoreInvokeString,{
      ChannelResources.passingScoreValueStringIndicator: value.toString()
    }
    );
  }

}