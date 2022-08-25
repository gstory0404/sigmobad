# Sigmob广告 Flutter版本

<p>
<a href="https://pub.flutter-io.cn/packages/sigmobad"><img src=https://img.shields.io/badge/sigmobad-v0.0.1-success></a>
</p>

## 官方文档
* [Android](https://doc.sigmob.com/#/Sigmob%E4%BD%BF%E7%94%A8%E6%8C%87%E5%8D%97/SDK%E9%9B%86%E6%88%90%E8%AF%B4%E6%98%8E/Android/SDK%E6%8E%A5%E5%85%A5%E9%85%8D%E7%BD%AE/)
* [IOS](https://doc.sigmob.com/#/Sigmob%E4%BD%BF%E7%94%A8%E6%8C%87%E5%8D%97/SDK%E9%9B%86%E6%88%90%E8%AF%B4%E6%98%8E/iOS/SDK%E6%8E%A5%E5%85%A5%E9%85%8D%E7%BD%AE/)

## 版本更新

[更新日志](https://github.com/gstory0404/sigmobad/blob/master/CHANGELOG.md)

## 本地开发环境
```
[✓] Flutter (Channel stable, 3.0.4, on macOS 12.5 21G72 darwin-x64, locale zh-Hans-CN)
[✓] Android toolchain - develop for Android devices (Android SDK version 33.0.0-rc1)
[✓] Xcode - develop for iOS and macOS (Xcode 13.4.1)
[✓] Chrome - develop for the web
[✓] Android Studio (version 2021.2)
[✓] IntelliJ IDEA Ultimate Edition (version 2022.1.1)
[✓] VS Code (version 1.69.2)
[✓] Connected device (3 available)
[✓] HTTP Host Availability
```

## 集成步骤
#### 1、pubspec.yaml
```Dart
sigmobad: ^0.0.1
```
引入
```Dart
import 'package:sigmobad/sigmobad.dart';
```

## 使用

### 1、SDK初始化
```dart
await SigmobAd.register(
    //androidId
    androidId: "6878",
    //iosId
    iosId: "6877",
    //androidAppKey
    androidAppKey: "8ebc1fd1c27e650c",
    //iosAppKey
    iosAppKey: "eccdcdbd9adbd4a7",
    //是否显示日志log
    debug: true,
    //是否显示个性化推荐广告
    personalized: true,
);
```

### 2、获取SDK版本
```Dart
await SigmobAd.getSDKVersion();
```

### 3、信息流广告（自渲染）
```dart
SigmobAdNativeWidget(
    //andorid广告位id
    androidId: "ed70b4760ff",
    //ios广告位id
    iosId: "ed70b3615a5",
    //广告宽
    viewWidth: 400,
    //广告高 加载成功后会自动修改为sdk返回广告高
    viewHeight: 200,
    //广告回调
    callBack: SigmobAdNativeCallBack(
        onShow: () {
          print("信息流广告显示");
        },
        onClose: () {
          print("信息流广告关闭");
        },
        onFail: (message) {
          print("信息流广告出错 $message");
        },
        onClick: () {
          print("信息流广告点击");
        },
    ),
),
```

### 4、激励广告
预加载广告
```dart
await SigmobAd.loadRewardAd(
    //android广告id
    androidId: "ea1f8ea2d90",
    //ios广告id
    iosId: "ea1f8f7b662",
    //用户id
    userID: "123",
    //奖励
    rewardName: "100金币",
    //奖励数
    rewardAmount: 100,
    //扩展参数 服务器回调使用
    customData: "",
);
```
显示广告

```dart
await SigmobAd.showRewardAd();
```

广告监听
```dart
SigmobAdStream.initAdStream(
    //激励广告
    rewardCallBack: SigmobAdRewardCallBack(
        onShow: () {
          print("激励广告显示");
        },
        onClick: () {
          print("激励广告点击");
        },
        onFail: (message) {
          print("激励广告失败 $message");
        },
        onClose: () {
          print("激励广告关闭");
        },
        onReady: () async {
          print("激励广告预加载准备就绪");
          await SigmobAd.showRewardAd();
        },
        onUnReady: () {
          print("激励广告预加载未准备就绪");
        },
        onVerify: (hasReward, rewardName, rewardAmount) {
          print("激励广告奖励  $hasReward   $rewardName   $rewardAmount");
        },
    ),
);
```

### 5、开屏广告
```dart
SigmobAdSplashWidget(
        //android广告位id
        androidId: "ea1f8f21300",
        //ios广告位id
        iosId: "ea1f8f9bd12",
        //宽
        width: MediaQuery.of(context).size.width,
        //高
        height: MediaQuery.of(context).size.height,
        //超时时间
        fetchDelay: 5,
        callBack: SigmobAdSplashCallBack(
          onShow: () {
            print("开屏广告显示");
          },
          onClose: () {
            print("开屏广告关闭");
            Navigator.pop(context);
          },
          onFail: (message) {
            print("开屏广告出错 $message");
          },
          onClick: () {
            print("开屏广告点击");
          },
        ),
      ),
```

### 6、插屏广告
预加载广告
```dart
await SigmobAd.loadInterstitialAd(
    //android广告id
    androidId: "ea1f8f45d80",
    //ios广告id
    iosId: "ea1f8fb93fb",
);
```
显示广告

```dart
 await SigmobAd.showInterstitialAd();
```

广告监听
```dart
SigmobAdStream.initAdStream(
    interstitialCallBack: SigmobAdInterstitialCallBack(
        onShow: () {
          print("插屏广告显示");
        },
        onClick: () {
          print("插屏广告点击");
        },
        onFail: (message) {
          print("插屏广告失败 $message");
        },
        onClose: () {
          print("插屏广告关闭");
        },
        onReady: () async {
            print("插屏广告预加载准备就绪");
            await SigmobAd.showInterstitialAd();
        },
        onUnReady: () {
          print("插屏广告预加载未准备就绪");
        },
    ),
);
```