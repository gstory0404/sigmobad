import 'package:flutter/material.dart';
import 'package:sigmobad/sigmobad.dart';

/// @Author: gstory
/// @CreateDate: 2022/8/25 10:12
/// @Email gstory0404@gmail.com
/// @Description: dart类作用描述

class NativePage extends StatefulWidget {
  const NativePage({Key? key}) : super(key: key);

  @override
  State<NativePage> createState() => _NativePageState();
}

class _NativePageState extends State<NativePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("信息流"),
      ),
      body: Container(
        child: Column(
          children: [
            SigmobAdNativeWidget(
              //andorid广告位id
              androidId: "ed70b4760ff",
              //ios广告位id
              iosId: "ed70b3615a5",
              //用户id
              userId: "123",
              //广告宽
              width: 400,
              //广告高 加载成功后会自动修改为sdk返回广告高
              height: 200,
              //广告回调
              callBack: SigmobAdNativeCallBack(
                onShow: () {
                  print("信息流广告显示");
                },
                onClose: () {
                  print("信息流广告关闭");
                },
                onFail: (message) {
                  print("信息流广告出错 $message");
                },
                onClick: () {
                  print("信息流广告点击");
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
