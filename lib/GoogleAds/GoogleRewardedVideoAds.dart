import 'package:Surprize/Leaderboard/LeaderboardManager.dart';
import 'package:Surprize/Memory/UserMemory.dart';
import 'package:firebase_admob/firebase_admob.dart';

import 'GoogleAdFormats.dart';

class GoogleVideoAds implements GoogleAdFormats{

  @override
  void dispose() {

  }

  @override
  Future initAd(String adUnitId, MobileAdTargetingInfo mobileAdTargetingInfo, Function listener) async {
    await RewardedVideoAd.instance.load(adUnitId: adUnitId, targetingInfo: mobileAdTargetingInfo);
  }

  @override
  Future showAd(double anchorOffSet, AnchorType anchorType) async {
    await RewardedVideoAd.instance.show();
  }

  @override
  void setListener(Function listener, Function onClosed) {
    RewardedVideoAd.instance.listener =
        (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
     if (event == RewardedVideoAdEvent.rewarded) {
         UserMemory().adShown = true;
      }
     if(event == RewardedVideoAdEvent.closed){
        onClosed();
     }
     if(event == RewardedVideoAdEvent.failedToLoad){

     }
     if(event == RewardedVideoAdEvent.loaded){
       RewardedVideoAd.instance.show();
     }
     if(event == RewardedVideoAdEvent.completed){
      UserMemory().adShown = true;
     }
     if(event == RewardedVideoAdEvent.opened){
       UserMemory().adShown = true;
     }
    };
  }



}