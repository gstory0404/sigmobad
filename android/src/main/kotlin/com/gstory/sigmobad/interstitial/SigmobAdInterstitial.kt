package com.gstory.sigmobad.interstitial

import com.gstory.sigmobad.SigmobAdEventPlugin
import com.gstory.sigmobad.utils.SigmobLogUtil
import com.sigmob.windad.WindAdError
import com.sigmob.windad.newInterstitial.WindNewInterstitialAd
import com.sigmob.windad.newInterstitial.WindNewInterstitialAdListener
import com.sigmob.windad.newInterstitial.WindNewInterstitialAdRequest


/**
 * @Author: gstory
 * @CreateDate: 2022/8/26 11:05
 * @Description: 激励广告
 */

object SigmobAdInterstitial {

    //参数
    private var mCodeId: String? = null
    private var userId: String? = null

    private var interstitialAd: WindNewInterstitialAd? = null


    fun init(params: Map<String?, Any?>) {
        this.mCodeId = params["androidId"] as String
        this.userId = params["userId"] as String
        loadInterstitialAd()
    }

    /**
     * 加载激励广告
     */
    private fun loadInterstitialAd() {
        val request = WindNewInterstitialAdRequest(mCodeId, userId, null)
        interstitialAd = WindNewInterstitialAd(request)
        interstitialAd?.setWindNewInterstitialAdListener(object : WindNewInterstitialAdListener {
            //仅sigmob渠道有回调，聚合其他平台无次回调
            override fun onInterstitialAdPreLoadSuccess(placementId: String?) {
                SigmobLogUtil.d("仅sigmob渠道有回调，聚合其他平台无次回调")
//                var map: MutableMap<String, Any?> =
//                    mutableMapOf("adType" to "interstitialAd", "onAdMethod" to "onReady")
//                SigmobAdEventPlugin.sendContent(map)
            }

            //仅sigmob渠道有回调，聚合其他平台无次回调
            override fun onInterstitialAdPreLoadFail(placementId: String?) {
                SigmobLogUtil.d("插屏广告填充失败")
                var map: MutableMap<String, Any?> = mutableMapOf(
                    "adType" to "interstitialAd", "onAdMethod" to "onFail", "message" to placementId
                )
                SigmobAdEventPlugin.sendContent(map)
            }

            override fun onInterstitialAdLoadSuccess(placementId: String?) {
                SigmobLogUtil.d("新插屏广告缓存加载成功,可以播放")
                var map: MutableMap<String, Any?> =
                    mutableMapOf("adType" to "interstitialAd", "onAdMethod" to "onReady")
                SigmobAdEventPlugin.sendContent(map)
            }

            override fun onInterstitialAdShow(placementId: String?) {
                SigmobLogUtil.d("插屏广告开始展示")
                var map: MutableMap<String, Any?> =
                    mutableMapOf("adType" to "interstitialAd", "onAdMethod" to "onShow")
                SigmobAdEventPlugin.sendContent(map)
            }


            override fun onInterstitialAdClicked(placementId: String?) {
                SigmobLogUtil.d("插屏广告被用户点击")
                var map: MutableMap<String, Any?> =
                    mutableMapOf("adType" to "interstitialAd", "onAdMethod" to "onClick")
                SigmobAdEventPlugin.sendContent(map)
            }

            override fun onInterstitialAdClosed(placementId: String?) {
                SigmobLogUtil.d("插屏广告关闭")
                var map: MutableMap<String, Any?> =
                    mutableMapOf("adType" to "interstitialAd", "onAdMethod" to "onClose")
                SigmobAdEventPlugin.sendContent(map)
            }

            /**
             * 加载广告错误回调
             * WindAdError 新插屏错误内容
             * placementId 广告位
             */
            override fun onInterstitialAdLoadError(
                windAdError: WindAdError?, placementId: String?
            ) {
                SigmobLogUtil.d("插屏广告加载失败 $windAdError")
                var map: MutableMap<String, Any?> = mutableMapOf(
                    "adType" to "interstitialAd",
                    "onAdMethod" to "onFail",
                    "message" to windAdError?.message
                )
                SigmobAdEventPlugin.sendContent(map)
            }

            /**
             * 播放错误回调
             * WindAdError 新插屏错误内容
             * placementId 广告位
             */
            override fun onInterstitialAdShowError(
                windAdError: WindAdError?, placementId: String?
            ) {
                SigmobLogUtil.d("插屏广告开始展示失败 $windAdError")
                var map: MutableMap<String, Any?> = mutableMapOf(
                    "adType" to "interstitialAd",
                    "onAdMethod" to "onFail",
                    "message" to windAdError?.message
                )
                SigmobAdEventPlugin.sendContent(map)
            }
        })
        //加载
        interstitialAd?.loadAd()
    }


    /**
     * 展示激励广告
     */
    fun showInterstitialAd() {
        if (interstitialAd == null || !interstitialAd!!.isReady) {
            var map: MutableMap<String, Any?> =
                mutableMapOf("adType" to "rewardAd", "onAdMethod" to "onUnReady")
            SigmobAdEventPlugin.sendContent(map)
            return
        }
        interstitialAd?.show(HashMap())
    }
}