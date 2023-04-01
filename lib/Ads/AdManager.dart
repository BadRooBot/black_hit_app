import 'package:flutter/foundation.dart';

class  AdManager {
  static String get gameId {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return '4615890';
    }
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return '4615891';
    }
    return '';
  }

  static String get bannerAdPlacementId {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'Banner_Android';
    }
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return 'Banner_iOS';
    }
    return '';
  }

  static String get interstitialVideoAdPlacementId {
    return 'Interstitial_Android';
  }

  static String get rewardedVideoAdPlacementId {
    return 'Rewarded_Android';
  }
}