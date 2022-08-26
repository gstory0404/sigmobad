import 'package:flutter/material.dart';
import 'package:sigmobad/sigmobad.dart';

/// @Author: gstory
/// @CreateDate: 2022/8/25 16:55
/// @Email gstory0404@gmail.com
/// @Description: dart类作用描述

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SigmobAdSplashWidget(
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
        //用户id
        userId: "123",
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
    );
  }
}
