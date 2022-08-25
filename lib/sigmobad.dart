
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

part 'sigmobad_callback.dart';
part 'sigmobad_code.dart';
part 'sigmobad_native_widget.dart';
part 'sigmobad_stream.dart';
part 'sigmobad_splash_widget.dart';

class SigmobAd {
  static const MethodChannel _channel = MethodChannel('sigmobad');

  ///
  /// # SDK注册初始化
  ///
  /// [androidId] androidId 必填
  ///
  /// [iosId] iosId 必填
  ///
  /// [androidAppKey] androidAppKey 必填
  ///
  /// [iosId] iosId 必填
  ///
  /// [debug] debug日志
  ///
  /// [personalized] personalized 是否开启个性化广告
  ///
  static Future<bool> register({
    required String androidId,
    required String iosId,
    required String androidAppKey,
    required String iosAppKey,
    bool? personalized,
    bool? debug,
  }) async {
    return await _channel.invokeMethod("register", {
      "androidId": androidId,
      "iosId": iosId,
      "androidAppKey": androidAppKey,
      "iosAppKey": iosAppKey,
      "debug": debug ?? false,
      "personalized": personalized ?? true,
    });
  }

  ///
  /// # 获取SDK版本号
  ///
  static Future<String> getSDKVersion() async {
    return await _channel.invokeMethod("getSDKVersion");
  }

  ///
  /// # 激励视频广告预加载
  ///
  /// [androidId] android广告ID
  ///
  /// [iosId] ios广告ID
  ///
  /// [rewardName] 奖励名称
  ///
  /// [rewardAmount] 奖励金额
  ///
  /// [userID] 用户id
  ///
  /// [customData] 扩展参数，服务器回调使用
  ///
  static Future<bool> loadRewardAd({
    required String androidId,
    required String iosId,
    required String rewardName,
    required int rewardAmount,
    required String userID,
    String? customData,
  }) async {
    return await _channel.invokeMethod("loadRewardAd", {
      "androidId": androidId,
      "iosId": iosId,
      "rewardName": rewardName,
      "rewardAmount": rewardAmount,
      "userID": userID,
      "customData": customData ?? "",
    });
  }

  ///
  /// # 显示激励广告
  ///
  static Future<bool> showRewardAd() async {
    return await _channel.invokeMethod("showRewardAd", {});
  }

  ///
  /// # 预加载插屏广告
  ///
  /// [androidId] android广告ID
  ///
  /// [iosId] ios广告ID
  ///
  static Future<bool> loadInterstitialAd({
    required String androidId,
    required String iosId,
  }) async {
    return await _channel.invokeMethod("loadInterstitialAd", {
      "androidId": androidId,
      "iosId": iosId,
    });
  }

  ///
  /// # 显示插屏广告
  ///
  static Future<bool> showInterstitialAd() async {
    return await _channel.invokeMethod("showInterstitialAd", {});
  }
}
