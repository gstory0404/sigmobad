part of '../sigmobad.dart';

/// @Author: gstory
/// @CreateDate: 2022/8/25 10:07
/// @Email gstory0404@gmail.com
/// @Description: dart类作用描述

class SigmobAdNativeWidget extends StatefulWidget {
  final String androidId;
  final String iosId;
  final double width;
  final double height;
  final String? userId;
  final SigmobAdNativeCallBack? callBack;

  const SigmobAdNativeWidget(
      {Key? key,
      required this.androidId,
      required this.iosId,
      required this.width,
      required this.height,
      this.userId,
      this.callBack})
      : super(key: key);

  @override
  State<SigmobAdNativeWidget> createState() => _KSAdNativeWidgetState();
}

class _KSAdNativeWidgetState extends State<SigmobAdNativeWidget> {
  final String _viewType = "com.gstory.sigmobad/NativeView";

  MethodChannel? _channel;

  //广告是否显示
  bool _isShowAd = true;

  double _width = 0;
  double _height = 0;

  @override
  void initState() {
    super.initState();
    _width = widget.width;
    _height = widget.height;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (!_isShowAd) {
      return Container();
    }
    if (defaultTargetPlatform == TargetPlatform.android) {
      return Container(
        width: _width,
        height: _height,
        child: AndroidView(
          viewType: _viewType,
          creationParams: {
            "androidId": widget.androidId,
            "width": widget.width,
            "height": widget.height,
            "userId": widget.userId ?? "",
          },
          onPlatformViewCreated: _registerChannel,
          creationParamsCodec: const StandardMessageCodec(),
        ),
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return Container(
        width: _width,
        height: _height,
        child: UiKitView(
          viewType: _viewType,
          creationParams: {
            "iosId": widget.iosId,
            "width": widget.width,
            "height": widget.height,
            "userId": widget.userId ?? "",
          },
          onPlatformViewCreated: _registerChannel,
          creationParamsCodec: const StandardMessageCodec(),
        ),
      );
    } else {
      return Container();
    }
  }

  //注册cannel
  void _registerChannel(int id) {
    _channel = MethodChannel("${_viewType}_$id");
    _channel?.setMethodCallHandler(_platformCallHandler);
  }

  //监听原生view传值
  Future<dynamic> _platformCallHandler(MethodCall call) async {
    print("${call.method} == ${call.arguments}");
    switch (call.method) {
      //显示广告
      case SigmobAdMethod.onShow:
        if (widget.callBack?.onShow != null) {
          widget.callBack?.onShow!();
        }
        Map map = call.arguments;
        if (mounted) {
          setState(() {
            _width = map["width"];
            _height = map["height"];
            _isShowAd = true;
          });
        }
        break;
      //广告加载失败
      case SigmobAdMethod.onFail:
        widget.callBack?.onFail!(call.arguments);
        if (mounted) {
          setState(() {
            _isShowAd = false;
          });
        }
        break;
      //点击
      case SigmobAdMethod.onClick:
        widget.callBack?.onClick!();
        break;
      //关闭
      case SigmobAdMethod.onClose:
        widget.callBack?.onClose!();
        if (mounted) {
          setState(() {
            _isShowAd = false;
          });
        }
        break;
    }
  }
}
