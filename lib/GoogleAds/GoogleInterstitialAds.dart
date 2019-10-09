
import 'package:Surprize/GoogleAds/GoogleAdFormats.dart';
import 'package:firebase_admob/firebase_admob.dart';

/// Class for handling google interstitial ads
class GoogleInterstitialAds implements GoogleAdFormats{

  InterstitialAd _interstitialAd;


  /// Method for initializing ad
  @override
  void initAd(String adUnitId, MobileAdTargetingInfo mobileAdTargetingInfo, Function listener) {
    if(_interstitialAd == null) {
      _interstitialAd = InterstitialAd(
          adUnitId: adUnitId,
          listener: listener
      );
    }
  }


  /// Method for showing ad in certain position
  @override
  void showAd(double anchorOffSet, AnchorType anchorType) {
    if( _interstitialAd != null) {
      _interstitialAd
        ..load()
        ..show(
          anchorType: anchorType,
          anchorOffset: anchorOffSet,
        );
    }
  }

  /// Dispose ad
  @override
  void dispose() {
    _interstitialAd?.dispose();
    _interstitialAd = null;
  }

  @override
  void setListener(Function listener, Function onCLosed) {
    // TODO: implement setListener
  }
}
