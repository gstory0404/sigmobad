part of 'sigmobad.dart';

/// @Author: gstory
/// @CreateDate: 2022/8/25 10:04
/// @Email gstory0404@gmail.com
/// @Description: Sigmob广告回调

///显示
typedef SigmobOnShow = void Function();

///失败
typedef SigmobOnFail = void Function(dynamic message);

///点击
typedef SigmobOnClick = void Function();

///跳过
typedef SigmobOnSkip = void Function();

///关闭
typedef SigmobOnClose = void Function();

///加载超时
typedef SigmobOnTimeOut = void Function();

///广告预加载完成
typedef SigmobOnReady = void Function();

///广告预加载未完成
typedef SigmobOnUnReady = void Function();

///广告奖励验证
typedef SigmobOnVerify = void Function(
    bool hasReward, String rewardName, int rewardAmount);

///激励广告回调
class SigmobAdRewardCallBack {
  SigmobOnShow? onShow;
  SigmobOnClose? onClose;
  SigmobOnFail? onFail;
  SigmobOnClick? onClick;
  SigmobOnVerify? onVerify;
  SigmobOnReady? onReady;
  SigmobOnUnReady? onUnReady;

  SigmobAdRewardCallBack(
      {this.onShow,
      this.onClick,
      this.onClose,
      this.onFail,
      this.onVerify,
      this.onReady,
      this.onUnReady});
}

///信息流广告回调
class SigmobAdNativeCallBack {
  SigmobOnShow? onShow;
  SigmobOnClose? onClose;
  SigmobOnFail? onFail;
  SigmobOnClick? onClick;

  SigmobAdNativeCallBack(
      {this.onShow, this.onClick, this.onClose, this.onFail});
}

///信息流广告回调
class SigmobAdInterstitialCallBack {
  SigmobOnShow? onShow;
  SigmobOnClose? onClose;
  SigmobOnFail? onFail;
  SigmobOnClick? onClick;
  SigmobOnReady? onReady;
  SigmobOnUnReady? onUnReady;

  SigmobAdInterstitialCallBack(
      {this.onShow,
      this.onClick,
      this.onClose,
      this.onFail,
      this.onReady,
      this.onUnReady});
}


///开屏广告回调
class SigmobAdSplashCallBack {
  SigmobOnShow? onShow;
  SigmobOnClose? onClose;
  SigmobOnFail? onFail;
  SigmobOnClick? onClick;

  SigmobAdSplashCallBack(
      {this.onShow, this.onClick, this.onClose, this.onFail});
}
