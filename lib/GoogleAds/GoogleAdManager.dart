import 'package:Surprize/GoogleAds/CurrentAdDisplayPage.dart';
import 'package:Surprize/GoogleAds/GoogleAdFormats.dart';
import 'package:Surprize/GoogleAds/GoogleBannerAds.dart';
import 'package:Surprize/GoogleAds/GoogleInterstitialAds.dart';
import 'package:firebase_admob/firebase_admob.dart';

/// Handles all operation related to different google advertisement display mechanism.
class GoogleAdManager {

  static String appId = "ca-app-pub-2130188164225142~4388816314";

  static String quizLetterInterstitialAdId = "ca-app-pub-2130188164225142/4408997619";
  static String leaderboardInterstitialAdId = "ca-app-pub-2130188164225142/8895037531";

  static String dashboardBannerId = "ca-app-pub-2130188164225142/9852895986";
  static String quizLetterBannerAdId = "ca-app-pub-2130188164225142/3287487633";
  static String noticeBannerAdId = "ca-app-pub-2130188164225142/9745084773";

  static String rewardedVideoAdId = "ca-app-pub-2130188164225142/4381077450";

  GoogleAdFormats _googleQuizLetterInterstitialAdId;
  GoogleAdFormats _googleLeaderboardInterstitialAdId;

  GoogleAdFormats _googleBannerAdForQuizLetters;
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


  showBannerForNotice(double offset, AnchorType anchorType){
    if(_googleBannerAdForNotice != null)
      return;
    try{
      init();
      _googleBannerAdForNotice = GoogleBannerAds(AdSize.smartBanner);
      _googleBannerAdForNotice.initAd(BannerAd.testAdUnitId, null, (MobileAdEvent event){
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

  showBannerForQuizLetter(double offset, AnchorType anchorType){
    if(_googleBannerAdForQuizLetters != null)
      return;
    try{
      init();
      _googleBannerAdForQuizLetters = GoogleBannerAds(AdSize.smartBanner);
      _googleBannerAdForQuizLetters.initAd(BannerAd.testAdUnitId, null, (MobileAdEvent event){
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

  disposeNoticeBannerAd(){
    if(_googleBannerAdForNotice == null || noticeBannerLoaded == false){
      return;
    }
    _googleBannerAdForNotice.dispose();
    _googleBannerAdForNotice = null;
      noticeBannerLoaded = false;
  }

  disposeQuizLetterBannerAd(){
    if(_googleBannerAdForQuizLetters == null || quizLetterBannerLoaded == false){
      return;
    }
    _googleBannerAdForQuizLetters.dispose();
    _googleBannerAdForQuizLetters = null;
    quizLetterBannerLoaded = false;

  }


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
  }

  /// Show Interstitial ad
  void showQuizLetterInterstitialAd(double offSet, AnchorType anchorType){
    try {
      init();
      _googleQuizLetterInterstitialAdId = GoogleInterstitialAds();
      _googleQuizLetterInterstitialAdId.initAd(
          InterstitialAd.testAdUnitId, null, (MobileAdEvent event) {

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

  /// Dispose interstitial ad
  void disposeLeaderboardInterstitialAd(){
    _googleLeaderboardInterstitialAdId.dispose();
    _googleLeaderboardInterstitialAdId = null;
  }

}