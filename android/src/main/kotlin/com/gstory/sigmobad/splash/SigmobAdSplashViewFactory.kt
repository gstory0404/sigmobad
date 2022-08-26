package com.gstory.sigmobad.splash

import android.content.Context
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

/**
 * @Author: gstory
 * @CreateDate: 2022/8/26 12:02
 * @Description: 描述
 */

class SigmobAdSplashViewFactory(private val messenger: BinaryMessenger) : PlatformViewFactory(
    StandardMessageCodec.INSTANCE) {
    override fun create(context: Context?, id: Int, args: Any?): PlatformView {
        val params = args as Map<String?, Any?>
        return SigmobAdSplashView(context!!, messenger, id, params)
    }
}