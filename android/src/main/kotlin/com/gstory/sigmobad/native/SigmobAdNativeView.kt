package com.gstory.sigmobad.native

import android.app.Activity
import android.content.Context
import android.view.View
import android.view.ViewTreeObserver
import android.view.ViewTreeObserver.OnGlobalLayoutListener
import android.widget.FrameLayout
import com.gstory.sigmobad.*
import com.gstory.sigmobad.utils.SigmobLogUtil
import com.sigmob.windad.WindAdError
import com.sigmob.windad.natives.NativeADEventListener
import com.sigmob.windad.natives.WindNativeAdData
import com.sigmob.windad.natives.WindNativeAdRequest
import com.sigmob.windad.natives.WindNativeUnifiedAd
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView


/**
 * @Author: gstory
 * @CreateDate: 2022/8/26 12:27
 * @Description: 描述
 */

internal class SigmobAdNativeView(
    var context: Context,
    var messenger: BinaryMessenger,
    id: Int,
    params: Map<String?, Any?>
) :
    PlatformView {
    private var container: FrameLayout? = null

    //广告所需参数
    private val mCodeId: String?
    private var width: Double
    private var height: Double
    private var userId: String? = null

    private var channel: MethodChannel?

    private lateinit var nativeAd: WindNativeUnifiedAd

    init {
        mCodeId = params["androidId"] as String?
        width = params["width"] as Double
        height = params["height"] as Double
        userId =  params["userId"] as String?
        container = FrameLayout(context)
        channel = MethodChannel(messenger, "com.gstory.sigmobad/NativeView_$id")
        loadNativeAd()
    }

    override fun getView(): View {
        return container!!
    }

    override fun dispose() {
        container?.removeAllViews()
        nativeAd.destroy()
    }

    private fun loadNativeAd() {
        val request =
            WindNativeAdRequest(mCodeId, userId, HashMap())

        nativeAd = WindNativeUnifiedAd(request)
        nativeAd.setNativeAdLoadListener(object : WindNativeUnifiedAd.WindNativeAdLoadListener {
            /**
             * 广告加载失败。参数说明：error（报错信息，具体可看其内部code和message）
             */
            override fun onAdError(p0: WindAdError?, p1: String?) {
                SigmobLogUtil.d("信息流广告加载失败 ${p0?.message}")
                channel?.invokeMethod("onFail",p0?.message)
            }

            /**
             * 广告加载成功。
             */
            override fun onAdLoad(p0: MutableList<WindNativeAdData>?, p1: String?) {
                SigmobLogUtil.d("信息流广告加载成功 ${p0?.size}")
                if (p0 == null || p0.size == 0) {
                    channel?.invokeMethod("onFail","未拉取到广告")
                    return
                }
                //渲染广告
                showNativeView(p0[0])
            }

        })
        nativeAd.loadAd(1)
    }

    private fun showNativeView(data: WindNativeAdData) {
        //媒体自渲染的View
        val adRender = NativeAdRender()
        data.setDislikeInteractionCallback(context as Activity?,object :WindNativeAdData.DislikeInteractionCallback{
            override fun onShow() {

            }

            override fun onSelected(p0: Int, p1: String?, p2: Boolean) {
                SigmobLogUtil.d("信息流广告点击不感兴趣 $p0  $p1  $p2")
                if(p2){
                    channel?.invokeMethod("onClose",p1)
                }
            }

            override fun onCancel() {

            }

        })
        var nativeAdView = adRender.getNativeAdView(context, data, object : NativeADEventListener {
            /**
             * 广告曝光。
             */
            override fun onAdExposed() {
                SigmobLogUtil.d("信息流广告曝光")
            }

            /**
             * 广告点击。
             */
            override fun onAdClicked() {
                SigmobLogUtil.d("信息流广告点击")
                channel?.invokeMethod("onClick","")
            }

            override fun onAdDetailShow() {
                SigmobLogUtil.d("信息流广告详情显示")
            }

            override fun onAdDetailDismiss() {
                SigmobLogUtil.d("信息流广告详情关闭")

            }

            /**
             * 广告展示失败。参数说明：error（报错信息，具体可看其内部code和message）
             */
            override fun onAdError(p0: WindAdError?) {
                SigmobLogUtil.d("信息流广告展示失败 ${p0?.errorCode} ${p0?.message}")
                channel?.invokeMethod("onFail",p0?.message)
            }
        },object : WindNativeAdData.NativeADMediaListener{
            /**
             * 视频加载成功。
             */
            override fun onVideoLoad() {
                SigmobLogUtil.d("信息流广告视频加载成功")
            }

            /**
             * 视频播放失败。参数说明：error（报错信息，具体可看其内部code和message）。
             */
            override fun onVideoError(p0: WindAdError?) {
                SigmobLogUtil.d("信息流广告视频播放失败 ${p0?.errorCode} ${p0?.message}")
            }

            /**
             * 视频开始播放。
             */
            override fun onVideoStart() {
                SigmobLogUtil.d("信息流广告视频开始播放")
            }

            /**
             * 视频暂停播放。
             */
            override fun onVideoPause() {
                SigmobLogUtil.d("信息流广告视频暂停播放")
            }

            /**
             * 视频恢复播放。
             */
            override fun onVideoResume() {
                SigmobLogUtil.d("信息流广告视频恢复播放")
            }

            /**
             * 视频完成播放。
             */
            override fun onVideoCompleted() {
                SigmobLogUtil.d("信息流广告视频完成播放")
            }

        })
        nativeAdView?.viewTreeObserver?.addOnGlobalLayoutListener(object : OnGlobalLayoutListener {
            override fun onGlobalLayout() {
                nativeAdView.viewTreeObserver?.removeOnGlobalLayoutListener(this)
                var map: MutableMap<String, Any?> =
                    mutableMapOf("width" to nativeAdView.measuredWidth, "height" to nativeAdView.measuredHeight)
                channel?.invokeMethod("onShow",map)
            }
        })
        container?.addView(nativeAdView)
    }
}