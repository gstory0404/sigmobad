part of 'sigmobad.dart';

/// @Author: gstory
/// @CreateDate: 2022/8/25 10:09
/// @Email gstory0404@gmail.com
/// @Description: sigmob广告监听

const EventChannel tencentAdEventEvent =
    EventChannel("com.gstory.sigmobad/adevent");

class SigmobAdStream {
  static StreamSubscription initAdStream(
      {SigmobAdRewardCallBack? rewardCallBack,
      SigmobAdInterstitialCallBack? interstitialCallBack}) {
    return tencentAdEventEvent.receiveBroadcastStream().listen((data) {
      switch (data[SigmobAdType.adType]) {

        ///激励广告
        case SigmobAdType.rewardAd:
          switch (data[SigmobAdMethod.onAdMethod]) {
            case SigmobAdMethod.onShow:
              if (rewardCallBack?.onShow != null) {
                rewardCallBack?.onShow!();
              }
              break;
            case SigmobAdMethod.onClose:
              if (rewardCallBack?.onClose != null) {
                rewardCallBack?.onClose!();
              }
              break;
            case SigmobAdMethod.onFail:
              if (rewardCallBack?.onFail != null) {
                rewardCallBack?.onFail!(data["message"]);
              }
              break;
            case SigmobAdMethod.onClick:
              if (rewardCallBack?.onClick != null) {
                rewardCallBack?.onClick!();
              }
              break;
            case SigmobAdMethod.onVerify:
              if (rewardCallBack?.onVerify != null) {
                rewardCallBack?.onVerify!(data["hasReward"], data["rewardName"],
                    data["rewardAmount"]);
              }
              break;
            case SigmobAdMethod.onReady:
              if (rewardCallBack?.onReady != null) {
                rewardCallBack?.onReady!();
              }
              break;
            case SigmobAdMethod.onUnReady:
              if (rewardCallBack?.onUnReady != null) {
                rewardCallBack?.onUnReady!();
              }
              break;
          }
          break;
        ///插屏广告
        case SigmobAdType.interstitialAd:
          switch (data[SigmobAdMethod.onAdMethod]) {
            case SigmobAdMethod.onShow:
              if (interstitialCallBack?.onShow != null) {
                interstitialCallBack?.onShow!();
              }
              break;
            case SigmobAdMethod.onClose:
              if (interstitialCallBack?.onClose != null) {
                interstitialCallBack?.onClose!();
              }
              break;
            case SigmobAdMethod.onFail:
              if (interstitialCallBack?.onFail != null) {
                interstitialCallBack?.onFail!(data["message"]);
              }
              break;
            case SigmobAdMethod.onClick:
              if (interstitialCallBack?.onClick != null) {
                interstitialCallBack?.onClick!();
              }
              break;
            case SigmobAdMethod.onReady:
              if (interstitialCallBack?.onReady != null) {
                interstitialCallBack?.onReady!();
              }
              break;
            case SigmobAdMethod.onUnReady:
              if (interstitialCallBack?.onUnReady != null) {
                interstitialCallBack?.onUnReady!();
              }
              break;
          }
          break;
      }
    });
  }
}
