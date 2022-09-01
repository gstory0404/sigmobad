package com.gstory.sigmobad.native

import android.content.Context
import android.text.TextUtils
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.*
import com.bumptech.glide.Glide
import com.gstory.sigmobad.R
import com.sigmob.windad.natives.NativeADEventListener
import com.sigmob.windad.natives.NativeAdPatternType
import com.sigmob.windad.natives.WindNativeAdData
import com.sigmob.windad.natives.WindNativeAdData.NativeADMediaListener


/**
 * @Author: gstory
 * @CreateDate: 2022/8/26 14:05
 * @Description: 描述
 */

class NativeAdRender {
    /**
     * 多布局根据adPatternType复用不同的根视图
     */
    private val developViewMap: MutableMap<Int, View?> = HashMap()
    private var img_logo: ImageView? = null
    private var ad_logo: ImageView? = null
    private var img_dislike: ImageView? = null
    private var text_desc: TextView? = null
    private var mButtonsContainer: View? = null
    private var mPlayButton: Button? = null
    private var mPauseButton: Button? = null
    private var mStopButton: Button? = null
    private var mMediaViewLayout: FrameLayout? = null
    private var mImagePoster: ImageView? = null
    private var native_3img_ad_container: LinearLayout? = null
    private var img_1: ImageView? = null
    private var img_2: ImageView? = null
    private var img_3: ImageView? = null
    private var text_title: TextView? = null
    private var mCTAButton: Button? = null
    fun getNativeAdView(
        context: Context?, adData: WindNativeAdData,
        nativeADEventListener: NativeADEventListener?,
        nativeADMediaListener: NativeADMediaListener?
    ): View? {
        val adPatternType = adData.adPatternType
        Log.d("windSDK", "---------createView----------$adPatternType")
        var nativeAdView: View? = developViewMap[adPatternType]
        if (nativeAdView == null) {
            nativeAdView =
                LayoutInflater.from(context).inflate(R.layout.native_ad_item, null)
            developViewMap[adPatternType] = nativeAdView
        }
        if (nativeAdView?.parent != null) {
            (nativeAdView.parent as ViewGroup).removeView(nativeAdView)
        }
        Log.d("windSDK", "renderAdView:" + adData.title)
        img_logo = nativeAdView?.findViewById(R.id.img_logo)
        ad_logo = nativeAdView?.findViewById(R.id.channel_ad_logo)
        img_dislike = nativeAdView?.findViewById(R.id.iv_dislike)
        text_desc = nativeAdView?.findViewById(R.id.text_desc)
        mButtonsContainer = nativeAdView?.findViewById(R.id.video_btn_container)
        mPlayButton = nativeAdView?.findViewById(R.id.btn_play)
        mPauseButton = nativeAdView?.findViewById(R.id.btn_pause)
        mStopButton = nativeAdView?.findViewById(R.id.btn_stop)
        mMediaViewLayout = nativeAdView?.findViewById(R.id.media_layout)
        mImagePoster = nativeAdView?.findViewById(R.id.img_poster)
        native_3img_ad_container = nativeAdView?.findViewById(R.id.native_3img_ad_container)
        img_1 = nativeAdView?.findViewById(R.id.img_1)
        img_2 = nativeAdView?.findViewById(R.id.img_2)
        img_3 = nativeAdView?.findViewById(R.id.img_3)
        text_title = nativeAdView?.findViewById(R.id.text_title)
        mCTAButton = nativeAdView?.findViewById(R.id.btn_cta)

        //渲染UI
        if (!TextUtils.isEmpty(adData.iconUrl)) {
            img_logo?.visibility = View.VISIBLE
            Glide.with(context!!).load(adData.iconUrl).into(img_logo!!)
        } else {
            img_logo?.visibility = View.GONE
        }
        if (!TextUtils.isEmpty(adData.title)) {
            text_title!!.text = adData.title
        } else {
            text_title!!.text = "点开有惊喜"
        }
        if (!TextUtils.isEmpty(adData.desc)) {
            text_desc!!.text = adData.desc
        } else {
            text_desc!!.text = "听说点开它的人都交了好运!"
        }
        if (adData.adLogo != null) {
            ad_logo?.visibility = View.VISIBLE
            ad_logo?.setImageBitmap(adData.adLogo)
        } else {
            ad_logo?.visibility = View.GONE
        }

        //clickViews数量必须大于等于1
        val clickableViews: MutableList<View?> = ArrayList()
        //可以被点击的view, 也可以把convertView放进来意味item可被点击
        clickableViews.add(nativeAdView)
        ////触发创意广告的view（点击下载或拨打电话）
        val creativeViewList: MutableList<View?> = ArrayList()
        // 所有广告类型，注册mDownloadButton的点击事件
        creativeViewList.add(mCTAButton)
        //        clickableViews.add(mDownloadButton);
        val imageViews: MutableList<ImageView?> = ArrayList()
        val patternType = adData.adPatternType
        Log.d("windSDK", "patternType:$patternType")


        //重要! 这个涉及到广告计费，必须正确调用。convertView必须使用ViewGroup。
        //作为creativeViewList传入，点击不进入详情页，直接下载或进入落地页，视频和图文广告均生效
        adData.bindViewForInteraction(
            nativeAdView,
            clickableViews,
            creativeViewList,
            img_dislike,
            nativeADEventListener
        )

        //需要等到bindViewForInteraction后再去添加media
        if (patternType == NativeAdPatternType.NATIVE_BIG_IMAGE_AD) {
            // 双图双文、单图双文：注册mImagePoster的点击事件
            mImagePoster?.visibility = View.VISIBLE
            mButtonsContainer?.visibility = View.GONE
            native_3img_ad_container!!.visibility = View.GONE
            mMediaViewLayout!!.visibility = View.GONE
            clickableViews.add(mImagePoster)
            imageViews.add(mImagePoster)
            adData.bindImageViews(imageViews, 0)
        } else if (patternType == NativeAdPatternType.NATIVE_VIDEO_AD) {
            // 视频广告，注册mMediaView的点击事件
            mImagePoster?.visibility = View.GONE
            native_3img_ad_container!!.visibility = View.GONE
            mMediaViewLayout!!.visibility = View.VISIBLE
            adData.bindMediaView(mMediaViewLayout, nativeADMediaListener)
            mButtonsContainer?.visibility = View.VISIBLE
            val listener: View.OnClickListener = View.OnClickListener { v ->
                if (v === mPlayButton) {
                    adData.startVideo()
                } else if (v === mPauseButton) {
                    adData.pauseVideo()
                } else if (v === mStopButton) {
                    adData.stopVideo()
                }
            }
            mPlayButton?.setOnClickListener(listener)
            mPauseButton?.setOnClickListener(listener)
            mStopButton?.setOnClickListener(listener)
        }
        /**
         * 营销组件
         * 支持项目：智能电话（点击跳转拨号盘），外显表单
         * bindCTAViews 绑定营销组件监听视图，注意：bindCTAViews的视图不可调用setOnClickListener，否则SDK功能可能受到影响
         * ad.getCTAText 判断拉取广告是否包含营销组件，如果包含组件，展示组件按钮，否则展示download按钮
         */
        val ctaText = adData.ctaText //获取组件文案
        Log.d("windSDK", "ctaText:$ctaText")
        updateAdAction(ctaText)
        return nativeAdView
    }

    private fun updateAdAction(ctaText: String) {
        if (!TextUtils.isEmpty(ctaText)) {
            //如果拉取广告包含CTA组件，则渲染该组件
            mCTAButton?.text = ctaText
            mCTAButton?.visibility = View.VISIBLE
        } else {
            mCTAButton?.visibility = View.INVISIBLE
        }
    }
}