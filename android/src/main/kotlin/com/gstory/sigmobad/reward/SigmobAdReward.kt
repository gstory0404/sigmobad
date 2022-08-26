package com.gstory.sigmobad.reward

import android.app.Activity
import android.content.Context
import com.czhj.volley.Request.Method.OPTIONS
import com.gstory.sigmobad.SigmobAdEventPlugin
import com.gstory.sigmobad.utils.SigmobLogUtil
import com.sigmob.windad.WindAdError
import com.sigmob.windad.rewardVideo.WindRewardAdRequest
import com.sigmob.windad.rewardVideo.WindRewardInfo
import com.sigmob.windad.rewardVideo.WindRewardVideoAd
import com.sigmob.windad.rewardVideo.WindRewardVideoAdListener


/**
 * @Author: gstory
 * @CreateDate: 2022/8/26 11:05
 * @Description: 激励广告
 */

object SigmobAdReward {

    //参数
    private var mCodeId: String? = null
    private var rewardName: String? = null
    private var rewardAmount: Int? = 0
    private var userId: String? = null
    private var customData: String? = null

    private var rewardAd: WindRewardVideoAd? = null


    fun init(params: Map<String?, Any?>) {
        this.mCodeId = params["androidId"] as String
        this.rewardName = params["rewardName"] as String
        this.rewardAmount = params["rewardAmount"] as Int
        this.userId = params["userId"] as String
        this.customData = params["customData"] as String
        loadRewardAd()
    }

    /**
     * 加载激励广告
     */
    private fun loadRewardAd() {
        var map: MutableMap<String, Any?> = mutableMapOf("data" to customData)
        val request = WindRewardAdRequest(mCodeId, userId, map)
        rewardAd = WindRewardVideoAd(request)
        rewardAd?.setWindRewardVideoAdListener(object : WindRewardVideoAdListener {
            /**
             * 激励视频广告数据返回成功
             */
            override fun onRewardAdLoadSuccess(p0: String?) {
                SigmobLogUtil.d("激励视频广告数据返回成功")
            }

            /**
             * 激励视频广告缓存加载成功,可以播放
             */
            override fun onRewardAdPreLoadSuccess(p0: String?) {
                SigmobLogUtil.d("激励视频广告缓存加载成功")
                var map: MutableMap<String, Any?> = mutableMapOf("adType" to "rewardAd", "onAdMethod" to "onReady")
                SigmobAdEventPlugin.sendContent(map)
            }

            /**
             * 激励视频广告数据返回失败
             */
            override fun onRewardAdPreLoadFail(p0: String?) {
                SigmobLogUtil.d(" 激励视频广告数据返回失败 $p0")
                var map: MutableMap<String, Any?> = mutableMapOf(
                    "adType" to "rewardAd",
                    "onAdMethod" to "onFail",
                    "message" to p0
                )
                SigmobAdEventPlugin.sendContent(map)
            }

            /**
             * 激励视频广告播放开始
             */
            override fun onRewardAdPlayStart(p0: String?) {
                SigmobLogUtil.d("激励视频广告播放开始")
                var map: MutableMap<String, Any?> =
                    mutableMapOf("adType" to "rewardAd", "onAdMethod" to "onShow")
                SigmobAdEventPlugin.sendContent(map)
            }

            /**
             * 激励视频广告播放结束
             */
            override fun onRewardAdPlayEnd(p0: String?) {
                SigmobLogUtil.d("激励视频广告播放结束 $p0")
            }

            /**
             * 激励视频广告CTA点击事件监听
             */
            override fun onRewardAdClicked(p0: String?) {
                SigmobLogUtil.d("激励视频广告CTA点击事件监听 $p0")
                var map: MutableMap<String, Any?> =
                    mutableMapOf("adType" to "rewardAd", "onAdMethod" to "onClick")
                SigmobAdEventPlugin.sendContent(map)
            }

            /**
             * 激励视频广告关闭
             */
            override fun onRewardAdClosed(p0: String?) {
                SigmobLogUtil.d("激励视频广告关闭 $p0")
                var map: MutableMap<String, Any?> =
                    mutableMapOf("adType" to "rewardAd", "onAdMethod" to "onClose")
                SigmobAdEventPlugin.sendContent(map)
            }

            /**
             * 激励视频广告完整播放，给予奖励
             */
            override fun onRewardAdRewarded(p0: WindRewardInfo?, p1: String?) {
                SigmobLogUtil.d("激励视频广告完整播放，给予奖励 $p0 $p1")
                var map: MutableMap<String, Any?> = mutableMapOf("adType" to "rewardAd",
                    "onAdMethod" to "onVerify",
                    "hasReward" to p0?.isReward,
                    "rewardAmount" to rewardAmount,
                    "rewardName" to rewardName)
                SigmobAdEventPlugin.sendContent(map)
            }

            /**
             * 加载广告错误回调
             * WindAdError 激励视频错误内容
             * placementId 广告位
             */
            override fun onRewardAdLoadError(p0: WindAdError?, p1: String?) {
                SigmobLogUtil.d("激励视频加载广告错误 $p0 $p1")
                var map: MutableMap<String, Any?> = mutableMapOf(
                    "adType" to "rewardAd",
                    "onAdMethod" to "onFail",
                    "message" to p0?.message
                )
                SigmobAdEventPlugin.sendContent(map)
            }

            /**
             * 播放错误回调
             * WindAdError 激励视频错误内容
             * placementId 广告位
             */
            override fun onRewardAdPlayError(p0: WindAdError?, p1: String?) {
                SigmobLogUtil.d("激励视频播放错误 $p0 $p1")
                var map: MutableMap<String, Any?> = mutableMapOf(
                    "adType" to "rewardAd",
                    "onAdMethod" to "onFail",
                    "message" to p0?.message
                )
                SigmobAdEventPlugin.sendContent(map)
            }

        })
        rewardAd?.loadAd()
    }


    /**
     * 展示激励广告
     */
    fun showRewardAd() {
        if (rewardAd == null || !rewardAd!!.isReady) {
            var map: MutableMap<String, Any?> = mutableMapOf("adType" to "rewardAd", "onAdMethod" to "onUnReady")
            SigmobAdEventPlugin.sendContent(map)
            return
        }
        rewardAd?.show(HashMap())
    }
}