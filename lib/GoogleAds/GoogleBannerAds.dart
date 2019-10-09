
import 'package:firebase_admob/firebase_admob.dart';

import 'GoogleAdFormats.dart';

class GoogleBannerAds implements GoogleAdFormats{

  AdSize _adSize;
  BannerAd _bannerAd;

  GoogleBannerAds(this._adSize);

  /// Method for initializing ad
  @override
  void initAd(String adUnitId, MobileAdTargetingInfo mobileAdTargetingInfo, Function listener) {
    if(_bannerAd == null) {
      _bannerAd = BannerAd(
          adUnitId: adUnitId,
          size: _adSize,
          targetingInfo: mobileAdTargetingInfo,
          listener: listener
      );
    }
  }

  /// Method for showing ad in certain position
  @override
  void showAd(double anchorOffSet, AnchorType anchorType) {
    if(_bannerAd != null) {
      _bannerAd
        ..load()
        ..show(
          /// Positions the banner ad from the bottom of the screen
          anchorOffset: anchorOffSet,

          /// Banner Position
          anchorType: anchorType
        );
    }
  }

  /// Dispose ad
  @override
  void dispose()  {
    _bannerAd?.dispose();
    _bannerAd = null;
  }

  @override
  void setListener(Function listener, Function onCLosed) {
    // TODO: implement setListener
  }


}