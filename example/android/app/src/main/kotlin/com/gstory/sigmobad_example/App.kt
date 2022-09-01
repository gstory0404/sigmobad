package com.gstory.sigmobad_example

import android.content.Context
import androidx.multidex.MultiDex
import io.flutter.app.FlutterApplication

/**
 * @Author: gstory
 * @CreateDate: 2022/9/1 12:26
 * @Description: 描述
 */

class App  : FlutterApplication() {

    override fun attachBaseContext(base: Context?) {
        super.attachBaseContext(base)
        MultiDex.install(this)
    }
}