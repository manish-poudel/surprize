import 'package:Surprize/GoogleAds/GoogleAdFormats.dart';
import 'package:Surprize/GoogleAds/GoogleBannerAds.dart';
import 'package:Surprize/GoogleAds/GoogleInterstitialAds.dart';
import 'package:Surprize/GoogleAds/GoogleRewardedVideoAds.dart';
import 'package:firebase_admob/firebase_admob.dart';

/// Handles all operation related to different google advertisement display mechanism.
class GoogleAdManager {

  static String appId = "ca-app-pub-6479462275480576~8584686975";

  static String quizLetterInterstitialAdId = "ca-app-pub-6479462275480576/2749411520";
  static String leaderboardInterstitialAdId = "ca-app-pub-6479462275480576/5483880913";

  static String quizLetterBannerAdId = "ca-app-pub-6479462275480576/7118248985";
  static String noticeBannerAdId = "ca-app-pub-6479462275480576/3979227559";

  static String rewardedVideoAdId = "ca-app-pub-6479462275480576/9556710066";

  GoogleAdFormats _googleQuizLetterInterstitialAdId;
  GoogleAdFormats _googleLeaderboardInterstitialAdId;

  GoogleAdFormats _googleBannerAdForQuizLetters;
  GoogleAdFormats _googleBannerAdForNotice;

  GoogleAdFormats _googleRewardedVideoAd;

  bool _hasInitialized = false;

  static final GoogleAdManager _googleAdManager = new GoogleAdManager
      ._internal();

  factory GoogleAdManager(){
    return _googleAdManager;
  }

  GoogleAdManager._internal();

  /// Init app
  void init(){
    if(!_hasInitialized) {
      FirebaseAdMob.instance.initialize(
          appId: appId);
      _hasInitialized = true;
    }
  }


  showBannerForNotice(double offset, AnchorType anchorType){
    if(_googleBannerAdForNotice != null)
      return;
    try{
      init();
      _googleBannerAdForNotice = GoogleBannerAds(AdSize.smartBanner);
      _googleBannerAdForNotice.initAd(BannerAd.testAdUnitId, null, (MobileAdEvent event){
      });
      _googleBannerAdForNotice.showAd(offset,anchorType);
    }
    catch(error){

    }
  }

  showBannerForQuizLetter(double offset, AnchorType anchorType){
    if(_googleBannerAdForQuizLetters != null)
      return;
    try{
      init();
      _googleBannerAdForQuizLetters = GoogleBannerAds(AdSize.smartBanner);
      _googleBannerAdForQuizLetters.initAd(BannerAd.testAdUnitId, null, (MobileAdEvent event){
      });
      _googleBannerAdForQuizLetters.showAd(offset,anchorType);
    }
    catch(error){

    }
  }

  disposeNoticeBannerAd(){
    _googleBannerAdForNotice.dispose();
    _googleBannerAdForNotice = null;
  }

  disposeQuizLetterBannerAd(){
    if(_googleBannerAdForQuizLetters != null) {
      _googleBannerAdForQuizLetters.dispose();
    }
    _googleBannerAdForQuizLetters = null;

  }


  showLeaderboardInterstitialAd(double offSet, AnchorType anchorType){
    try{
      init();
      _googleQuizLetterInterstitialAdId = GoogleInterstitialAds();
      _googleQuizLetterInterstitialAdId.initAd(
          InterstitialAd.testAdUnitId, null, (MobileAdEvent event) {});
      _googleQuizLetterInterstitialAdId.showAd(offSet, anchorType);
    }
    catch(error){
    }
  }

  /// Show Interstitial ad
  void showInterstitialAd(double offSet, AnchorType anchorType){
    try {
      init();
      _googleQuizLetterInterstitialAdId = GoogleInterstitialAds();
      _googleQuizLetterInterstitialAdId.initAd(
          InterstitialAd.testAdUnitId, null, (MobileAdEvent event) {});
      _googleQuizLetterInterstitialAdId.showAd(offSet, anchorType);

    }
    catch(error){}
  }

  /// Dispose interstitial ad
  void disposeQuizLetterInterstitialAd(){
    _googleQuizLetterInterstitialAdId.dispose();
    _googleQuizLetterInterstitialAdId = null;
  }

  /// Dispose interstitial ad
  void disposeLeaderboardInterstitialAd(){
    _googleLeaderboardInterstitialAdId.dispose();
    _googleLeaderboardInterstitialAdId = null;
  }


  /// Show video ad
  showVideoAd(Function onReward,Function onClosed) async {
    try{
      init();

    }
    catch(error){

    }
  }

}