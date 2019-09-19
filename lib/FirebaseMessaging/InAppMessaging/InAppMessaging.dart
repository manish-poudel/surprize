class InAppMessaging {

  static final InAppMessaging _inAppMessaging =
  new InAppMessaging._internal();

  factory InAppMessaging() {
    return _inAppMessaging;
  }

  InAppMessaging._internal();
}