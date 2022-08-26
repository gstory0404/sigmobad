package com.gstory.sigmobad.interstitial

import android.app.Activity
import android.content.Context
import com.czhj.volley.Request.Method.OPTIONS
import com.gstory.sigmobad.SigmobAdEventPlugin
import com.gstory.sigmobad.utils.SigmobLogUtil
import com.sigmob.windad.WindAdError
import com.sigmob.windad.interstitial.WindInterstitialAd
import com.sigmob.windad.interstitial.WindInterstitialAdListener
import com.sigmob.windad.interstitial.WindInterstitialAdRequest
import com.sigmob.windad.rewardVideo.WindRewardAdRequest
import com.sigmob.windad.rewardVideo.WindRewardInfo
import com.sigmob.windad.rewardVideo.WindRewardVideoAd
import com.sigmob.windad.rewardVideo.WindRewardVideoAdListener


/**
 * @Author: gstory
 * @CreateDate: 2022/8/26 11:05
 * @Description: 激励广告
 */

object SigmobAdInterstitial {

    //参数
    private var mCodeId: String? = null
    private var userId: String? = null

    private var interstitialAd: WindInterstitialAd? = null


    fun init(params: Map<String?, Any?>) {
        this.mCodeId = params["androidId"] as String
        this.userId = params["userId"] as String
        loadInterstitialAd()
    }

    /**
     * 加载激励广告
     */
    private fun loadInterstitialAd() {
        val request = WindInterstitialAdRequest(mCodeId, userId, null)
        interstitialAd = WindInterstitialAd(request)
        interstitialAd?.setWindInterstitialAdListener(object : WindInterstitialAdListener {
            /**
             * 广告加载成功 ,placementId 为回调广告位
             */
            override fun onInterstitialAdLoadSuccess(p0: String?) {
                SigmobLogUtil.d("插屏广告加载成功")
                var map: MutableMap<String, Any?> = mutableMapOf("adType" to "interstitialAd", "onAdMethod" to "onReady")
                SigmobAdEventPlugin.sendContent(map)
            }

            /**
             * 广告服务填充成功，placementId 为回调广告位
             */
            override fun onInterstitialAdPreLoadSuccess(p0: String?) {
                SigmobLogUtil.d("插屏广告服务填充成功")
            }

            /**
             * 广告填充失败 ,placementId 为回调广告位
             */
            override fun onInterstitialAdPreLoadFail(p0: String?) {
                SigmobLogUtil.d("插屏广告填充失败")
                var map: MutableMap<String, Any?> = mutableMapOf(
                    "adType" to "interstitialAd",
                    "onAdMethod" to "onFail",
                    "message" to p0
                )
                SigmobAdEventPlugin.sendContent(map)
            }

            /**
             * 广告开始展示 ,placementId 为回调广告位
             */
            override fun onInterstitialAdPlayStart(p0: String?) {
                SigmobLogUtil.d("插屏广告开始展示")
                var map: MutableMap<String, Any?> = mutableMapOf("adType" to "interstitialAd", "onAdMethod" to "onShow")
                SigmobAdEventPlugin.sendContent(map)
            }

            /**
             * 广告视频播放结束, placementId 为回调广告位
             */
            override fun onInterstitialAdPlayEnd(p0: String?) {
                SigmobLogUtil.d("插屏广告视频播放结束")
            }

            /**
             * 广告被用户点击, placementId 为回调广告位
             */
            override fun onInterstitialAdClicked(p0: String?) {
                SigmobLogUtil.d("插屏广告被用户点击")
                var map: MutableMap<String, Any?> = mutableMapOf("adType" to "interstitialAd", "onAdMethod" to "onClick")
                SigmobAdEventPlugin.sendContent(map)
            }

            /**
             * 广告关闭， placementId 为回调广告位
             */
            override fun onInterstitialAdClosed(p0: String?) {
                SigmobLogUtil.d("插屏广告关闭")
                var map: MutableMap<String, Any?> = mutableMapOf("adType" to "interstitialAd", "onAdMethod" to "onClose")
                SigmobAdEventPlugin.sendContent(map)
            }

            /**
             * 广告加载失败, windAdError 为具体错误信息，placementId 为回调广告位
             */
            override fun onInterstitialAdLoadError(p0: WindAdError?, p1: String?) {
                SigmobLogUtil.d("插屏广告加载失败 $p0")
                var map: MutableMap<String, Any?> = mutableMapOf(
                    "adType" to "interstitialAd",
                    "onAdMethod" to "onFail",
                    "message" to p0?.message
                )
                SigmobAdEventPlugin.sendContent(map)
            }

            /**
             * 广告开始展示失败，windAdError 为具体错误信息，placementId 为回调广告位
             */
            override fun onInterstitialAdPlayError(p0: WindAdError?, p1: String?) {
                SigmobLogUtil.d("插屏广告开始展示失败 $p0")
                var map: MutableMap<String, Any?> = mutableMapOf(
                    "adType" to "interstitialAd",
                    "onAdMethod" to "onFail",
                    "message" to p0?.message
                )
                SigmobAdEventPlugin.sendContent(map)
            }

        })

        interstitialAd?.loadAd()
    }


    /**
     * 展示激励广告
     */
    fun showInterstitialAd() {
        if (interstitialAd == null || !interstitialAd!!.isReady) {
            var map: MutableMap<String, Any?> = mutableMapOf("adType" to "rewardAd", "onAdMethod" to "onUnReady")
            SigmobAdEventPlugin.sendContent(map)
            return
        }
        interstitialAd?.show(HashMap())
    }
}