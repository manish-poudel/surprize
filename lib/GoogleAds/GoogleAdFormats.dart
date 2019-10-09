
import 'package:firebase_admob/firebase_admob.dart';

/// Interface class for various google ad formats.

abstract class GoogleAdFormats{
  void initAd(String adUnitId, MobileAdTargetingInfo mobileAdTargetingInfo, Function listener);
  void showAd(double anchorOffSet, AnchorType anchorType);
  void dispose();
  void setListener(Function listener, Function onClosed);
}