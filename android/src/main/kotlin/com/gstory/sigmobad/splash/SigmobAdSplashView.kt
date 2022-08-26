package com.gstory.sigmobad.splash

import android.content.Context
import android.view.View
import android.widget.FrameLayout
import com.gstory.sigmobad.utils.SigmobLogUtil
import com.sigmob.windad.Splash.WindSplashAD
import com.sigmob.windad.Splash.WindSplashADListener
import com.sigmob.windad.Splash.WindSplashAdRequest
import com.sigmob.windad.WindAdError
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView


/**
 * @Author: gstory
 * @CreateDate: 2022/8/26 12:03
 * @Description: 开屏广告
 */

internal class SigmobAdSplashView(
    var context: Context,
    var messenger: BinaryMessenger,
    id: Int,
    params: Map<String?, Any?>
) :
    PlatformView {
    private var container: FrameLayout? = null

    //广告所需参数
    private val mCodeId: String?
    private val userId: String?
    private var width: Double
    private var height: Double
    private var fetchDelay: Int = 3

    private var channel: MethodChannel?

    private lateinit var splashAd: WindSplashAD

    init {
        mCodeId = params["androidId"] as String?
        userId = params["userId"] as String?
        width = params["width"] as Double
        height = params["height"] as Double
        fetchDelay = params["fetchDelay"] as Int
        container = FrameLayout(context)
        channel = MethodChannel(messenger, "com.gstory.sigmobad/SplashView_$id")
        loadSplashAd()
    }

    override fun getView(): View {
        return container!!
    }

    override fun dispose() {
        container?.removeAllViews()
        splashAd.destroy()
    }

    private fun loadSplashAd() {
        container?.removeAllViews()
        val splashAdRequest =
            WindSplashAdRequest(mCodeId, userId, HashMap())
        splashAdRequest.isDisableAutoHideAd = true
        //广告允许最大等待返回时间
        splashAdRequest.fetchDelay = fetchDelay
        splashAd = WindSplashAD(splashAdRequest, object : WindSplashADListener {

            /**
             * 广告开始展示成功，placementId 为回调广告位
             */
            override fun onSplashAdShow(p0: String?) {
                SigmobLogUtil.d("开屏广告开始展示成功")
                channel?.invokeMethod("onShow","开屏广告展示")
            }

            /**
             * 广告加载成功 ,placementId 为回调广告位
             */
            override fun onSplashAdLoadSuccess(p0: String?) {
                SigmobLogUtil.d("开屏广告加载成功")
            }

            /**
             * 广告加载失败, error 错误信息，placementId 为回调广告位
             */
            override fun onSplashAdLoadFail(p0: WindAdError?, p1: String?) {
                SigmobLogUtil.d("开屏广告加载失败 ${p0?.message}")
                channel?.invokeMethod("onFail",p0?.message)
            }

            /**
             * 广告开始展示失败, error 为错误码，placementId 为错误信息
             */
            override fun onSplashAdShowError(p0: WindAdError?, p1: String?) {
                SigmobLogUtil.d("开屏广告开始展示失败 ${p0?.message}")
                channel?.invokeMethod("onFail",p0?.message)
            }

            /**
             * 广告被用户点击 ，placementId 为回调广告位
             */
            override fun onSplashAdClick(p0: String?) {
                SigmobLogUtil.d("开屏广告被用户点击")
                channel?.invokeMethod("onClick","开屏广告展示")
            }

            /**
             * 广告关闭，placementId 为回调广告位
             */
            override fun onSplashAdClose(p0: String?) {
                SigmobLogUtil.d("开屏广告关闭")
                channel?.invokeMethod("onClose","开屏广告展示")
            }

            /**
             * 广告被跳过，placementId 为回调广告位
             */
            override fun onSplashAdSkip(p0: String?) {
                SigmobLogUtil.d("开屏广告被跳过")
            }

        })
        splashAd.loadAndShow(container)
    }
}