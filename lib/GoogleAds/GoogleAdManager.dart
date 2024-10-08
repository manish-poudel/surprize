import 'package:Surprize/GoogleAds/CurrentAdDisplayPage.dart';
import 'package:Surprize/GoogleAds/GoogleAdFormats.dart';
import 'package:Surprize/GoogleAds/GoogleBannerAds.dart';
import 'package:Surprize/GoogleAds/GoogleInterstitialAds.dart';
import 'package:firebase_admob/firebase_admob.dart';

/// Handles all operation related to different google advertisement display mechanism.
class GoogleAdManager {

  static String appId = "ca-app-pub-6438481805852201~9665170019";

  static String interstitialAdId = "ca-app-pub-6438481805852201/9282026631";

  static String bannerAdId = "ca-app-pub-6438481805852201/2908189979";

  static String rewardedVideoAdId = "ca-app-pub-6438481805852201/8831628164";

  GoogleAdFormats _googleQuizLetterInterstitialAdId;
 // GoogleAdFormats _googleLeaderboardInterstitialAdId;
  //GoogleAdFormats _googleDQCExitInterstitialAdId;
  //GoogleAdFormats _quizGameInterstitialAd;

  //GoogleAdFormats _googleBannerAdForQuizLetters;
  GoogleAdFormats _googleBannerAdForNotice;

  CurrentPage currentPage;

  bool _hasInitialized = false;

  bool quizLetterBannerLoaded = false;
  bool noticeBannerLoaded = false;

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

  /// Show banner for notice
  showBannerForNotice(double offset, AnchorType anchorType){
    if(_googleBannerAdForNotice != null)
      return;
    try{
      init();
      _googleBannerAdForNotice = GoogleBannerAds(AdSize.smartBanner);
      _googleBannerAdForNotice.initAd(GoogleAdManager.bannerAdId, null, (MobileAdEvent event){
        if(event == MobileAdEvent.loaded) {
          noticeBannerLoaded = true;
        }
        if(event == MobileAdEvent.closed){
          noticeBannerLoaded = false;
        }
      });
      _googleBannerAdForNotice.showAd(offset,anchorType);
    }
    catch(error){

    }
  }

  /// Dispose banner ad id
  disposeNoticeBannerAd(){
    if(_googleBannerAdForNotice == null || noticeBannerLoaded == false){
      return;
    }
    _googleBannerAdForNotice.dispose();
    _googleBannerAdForNotice = null;
    noticeBannerLoaded = false;
  }


/*
  showBannerForQuizLetter(double offset, AnchorType anchorType){
    if(_googleBannerAdForQuizLetters != null)
      return;
    try{
      init();
      _googleBannerAdForQuizLetters = GoogleBannerAds(AdSize.smartBanner);
      _googleBannerAdForQuizLetters.initAd(GoogleAdManager.interstitialAdId, null, (MobileAdEvent event){
        if(event == MobileAdEvent.loaded) {
          quizLetterBannerLoaded = true;
        }
        if(event == MobileAdEvent.closed){
          quizLetterBannerLoaded = false;
        }
      });
      _googleBannerAdForQuizLetters.showAd(offset,anchorType);
    }
    catch(error){

    }
  }
*/


/*
  disposeQuizLetterBannerAd(){
    if(_googleBannerAdForQuizLetters == null || quizLetterBannerLoaded == false){
      return;
    }
    _googleBannerAdForQuizLetters.dispose();
    _googleBannerAdForQuizLetters = null;
    quizLetterBannerLoaded = false;

  }
*/

/*  /// Leaderboard interstitial ad
  showLeaderboardInterstitialAd(double offSet, AnchorType anchorType){
    try{
      init();
      _googleQuizLetterInterstitialAdId = GoogleInterstitialAds();
      _googleQuizLetterInterstitialAdId.initAd(InterstitialAd.testAdUnitId,
           null, (MobileAdEvent event) {});
      _googleQuizLetterInterstitialAdId.showAd(offSet, anchorType);
    }
    catch(error){
    }
  }*/

/*  /// Leaderboard interstitial ad
  showDQCExitInterstitialAd(double offSet, AnchorType anchorType){
    try{
      init();
      _googleDQCExitInterstitialAdId = GoogleInterstitialAds();
      _googleDQCExitInterstitialAdId.initAd(InterstitialAd.testAdUnitId,
          null, (MobileAdEvent event) {});
      _googleDQCExitInterstitialAdId.showAd(offSet, anchorType);
    }
    catch(error){
    }
  }*/

  /// Show Interstitial ad
  void showQuizLetterInterstitialAd(double offSet, AnchorType anchorType){
    try {
      init();
      _googleQuizLetterInterstitialAdId = GoogleInterstitialAds();
      _googleQuizLetterInterstitialAdId.initAd(
          GoogleAdManager.interstitialAdId, null, (MobileAdEvent event) {

      });
      _googleQuizLetterInterstitialAdId.showAd(offSet, anchorType);

    }
    catch(error){}
  }

  /// Dispose interstitial ad
  void disposeQuizLetterInterstitialAd(){
    _googleQuizLetterInterstitialAdId.dispose();
    _googleQuizLetterInterstitialAdId = null;
  }

/*  /// Show Interstitial ad
  void showQuizGameInterstitialAd(double offSet, AnchorType anchorType){
    try {
      init();
      _quizGameInterstitialAd = GoogleInterstitialAds();
      _quizGameInterstitialAd.initAd(
          GoogleAdManager.interstitialAdId, null, (MobileAdEvent event) {

      });
      _quizGameInterstitialAd.showAd(offSet, anchorType);

    }
    catch(error){}
  }*/



/*
  /// Dispose interstitial ad
  void disposeDQCInterstitialAd(){
    if(_googleDQCExitInterstitialAdId == null)
      return;
    _googleDQCExitInterstitialAdId.dispose();
    _googleDQCExitInterstitialAdId = null;
  }
*/

/*
  /// Dispose interstitial ad
  void disposeLeaderboardInterstitialAd(){
    _googleLeaderboardInterstitialAdId.dispose();
    _googleLeaderboardInterstitialAdId = null;
  }
*/
/*
  /// Dispose interstitial ad
  void disposeQuizGameInterstitialAd(){
    _quizGameInterstitialAd.dispose();
    _quizGameInterstitialAd = null;
  }*/

}