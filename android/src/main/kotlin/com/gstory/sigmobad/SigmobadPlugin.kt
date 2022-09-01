package com.gstory.sigmobad

import android.app.Activity
import android.content.Context
import androidx.annotation.NonNull
import com.gstory.sigmobad.interstitial.SigmobAdInterstitial
import com.gstory.sigmobad.native.SigmobAdNativeViewFactory
import com.gstory.sigmobad.reward.SigmobAdReward
import com.gstory.sigmobad.splash.SigmobAdSplashViewFactory
import com.gstory.sigmobad.utils.SigmobLogUtil
import com.sigmob.windad.WindAdOptions
import com.sigmob.windad.WindAds
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result


/** SigmobadPlugin */
class SigmobadPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    private lateinit var channel: MethodChannel

    private var applicationContext: Context? = null
    private var mActivity: Activity? = null
    private var mFlutterPluginBinding: FlutterPlugin.FlutterPluginBinding? = null

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        mActivity = binding.activity
        //注册开屏广告
        mFlutterPluginBinding?.platformViewRegistry?.registerViewFactory(
            "com.gstory.sigmobad/SplashView",
            SigmobAdSplashViewFactory(mFlutterPluginBinding!!.binaryMessenger)
        )
        //注册信息流广告
        mFlutterPluginBinding?.platformViewRegistry?.registerViewFactory(
            "com.gstory.sigmobad/NativeView",
            SigmobAdNativeViewFactory(mFlutterPluginBinding!!.binaryMessenger)
        )
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        mActivity = binding.activity
    }

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel =
            MethodChannel(flutterPluginBinding.binaryMessenger, "sigmobad")
        channel.setMethodCallHandler(this)
        applicationContext = flutterPluginBinding.applicationContext
        mFlutterPluginBinding = flutterPluginBinding
        SigmobAdEventPlugin().onAttachedToEngine(flutterPluginBinding)
//        FlutterUnionadViewPlugin.registerWith(flutterPluginBinding,mActivity!!)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        mActivity = null
    }

    override fun onDetachedFromActivity() {
        mActivity = null
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        //注册初始化
        when (call.method) {
            "register" -> {
                val appId = call.argument<String>("androidId")
                val appKey = call.argument<String>("androidAppKey")
                val debug = call.argument<Boolean>("debug")
                val personalized = call.argument<Boolean>("personalized")
                val ads = WindAds.sharedAds()
                   // 是否显示日志
                SigmobLogUtil.setAppName("sigmobad")
                SigmobLogUtil.setShow(debug!!)
                ads.isDebugEnable = debug
                //个性化推荐开关
                ads.isPersonalizedAdvertisingOn = personalized!!
                ads.startWithOptions(applicationContext, WindAdOptions(appId, appKey))
                result.success(ads.isInit)
            }
            //sdk版本
            "getSDKVersion" -> {
                result.success(WindAds.getVersion())
//                result.success("123")
            }
            //预加载激励广告
            "loadRewardAd" -> {
                SigmobAdReward.init(call.arguments as Map<String?, Any?>)
                result.success(true)
            }
            //展示激励广告
            "showRewardAd" -> {
                SigmobAdReward.showRewardAd()
                result.success(true)
            }
            //预加载插屏广告
            "loadInterstitialAd" -> {
                SigmobAdInterstitial.init(call.arguments as Map<String?, Any?>)
                result.success(true)
            }
            //展示插屏广告
            "showInterstitialAd" -> {
                SigmobAdInterstitial.showInterstitialAd()
                result.success(true)
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
