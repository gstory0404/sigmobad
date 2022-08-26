import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:sigmobad/sigmobad.dart';
import 'package:sigmobad_example/native_page.dart';
import 'package:sigmobad_example/splash_page.dart';

void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isRegister = false;
  String _sdkVersion = "";

  StreamSubscription? _adStream;

  @override
  void initState() {
    super.initState();
    _register();
    _adStream = SigmobAdStream.initAdStream(
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
  }

  ///初始化
  Future<void> _register() async {
    _isRegister = await SigmobAd.register(
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
    print("初始化==》$_isRegister");
    _sdkVersion = await SigmobAd.getSDKVersion();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('快手广告插件'),
      ),
      body: Center(
        child: Column(
          children: [
            Text('快手SDK初始化: $_isRegister\n'),
            Text('SDK版本: $_sdkVersion\n'),
            //激励广告
            MaterialButton(
              color: Colors.blue,
              textColor: Colors.white,
              child: const Text('激励广告'),
              onPressed: () async {
                await SigmobAd.loadRewardAd(
                  //android广告id
                  androidId: "ea1f8ea2d90",
                  //ios广告id
                  iosId: "ea1f8f7b662",
                  //用户id
                  userId: "123",
                  //奖励
                  rewardName: "100金币",
                  //奖励数
                  rewardAmount: 100,
                  //扩展参数 服务器回调使用
                  customData: "",
                );
              },
            ),
            //信息流广告
            MaterialButton(
              color: Colors.blue,
              textColor: Colors.white,
              child: const Text('信息流广告'),
              onPressed: () async {
                Navigator.push(context, MaterialPageRoute(builder: (_) {
                  return const NativePage();
                }));
              },
            ),
            //插屏广告
            MaterialButton(
              color: Colors.blue,
              textColor: Colors.white,
              child: const Text('插屏广告'),
              onPressed: () async {
                await SigmobAd.loadInterstitialAd(
                  //android广告id
                  androidId: "ea1f8f45d80",
                  //ios广告id
                  iosId: "ea1f8fb93fb",
                  //用户id
                  userId: "123",
                );
              },
            ),
            //开屏广告
            MaterialButton(
              color: Colors.blue,
              textColor: Colors.white,
              child: const Text('开屏广告'),
              onPressed: () async {
                Navigator.push(context, MaterialPageRoute(builder: (_) {
                  return const SplashPage();
                }));
              },
            ),
          ],
        ),
      ),
    );
  }
}