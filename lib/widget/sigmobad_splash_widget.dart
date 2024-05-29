part of '../sigmobad.dart';

/// @Author: gstory
/// @CreateDate: 2022/8/25 16:49
/// @Email gstory0404@gmail.com
/// @Description: dart类作用描述
///
class SigmobAdSplashWidget extends StatefulWidget {
  final String androidId;
  final String iosId;
  final int? fetchDelay;
  final double width;
  final double height;
  final String? userId;
  final SigmobAdSplashCallBack? callBack;

  const SigmobAdSplashWidget(
      {Key? key,
      required this.androidId,
      required this.iosId,
      required this.width,
      required this.height,
      this.fetchDelay,
      this.userId,
      this.callBack})
      : super(key: key);

  @override
  State<SigmobAdSplashWidget> createState() => _SigmobAdSplashWidgetState();
}

class _SigmobAdSplashWidgetState extends State<SigmobAdSplashWidget> {
  final String _viewType = "com.gstory.sigmobad/SplashView";

  MethodChannel? _channel;

  //广告是否显示
  bool _isShowAd = true;

  @override
  void initState() {
    super.initState();
    print("宽 ${widget.width}  高${widget.height}");
  }

  @override
  Widget build(BuildContext context) {
    if (!_isShowAd) {
      return Container();
    }
    if (defaultTargetPlatform == TargetPlatform.android) {
      return SizedBox(
        width: widget.width,
        height: widget.height,
        child: AndroidView(
          viewType: _viewType,
          creationParams: {
            "androidId": widget.androidId,
            "fetchDelay": widget.fetchDelay,
            "width": widget.width,
            "height": widget.height,
            "userId": widget.userId ?? "",
          },
          onPlatformViewCreated: _registerChannel,
          creationParamsCodec: const StandardMessageCodec(),
        ),
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: UiKitView(
          viewType: _viewType,
          creationParams: {
            "iosId": widget.iosId,
            "fetchDelay": widget.fetchDelay,
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
    switch (call.method) {
      //显示广告
      case SigmobAdMethod.onShow:
        if (widget.callBack?.onShow != null) {
          widget.callBack?.onShow!();
        }
        if (mounted) {
          setState(() {
            _isShowAd = true;
          });
        }
        break;
      //广告加载失败
      case SigmobAdMethod.onFail:
        if (widget.callBack?.onFail != null) {
          widget.callBack?.onFail!(call.arguments);
        }
        if (mounted) {
          setState(() {
            _isShowAd = false;
          });
        }
        break;
      //点击
      case SigmobAdMethod.onClick:
        if (widget.callBack?.onClick != null) {
          widget.callBack?.onClick!();
        }
        break;
      //关闭
      case SigmobAdMethod.onClose:
        if (widget.callBack?.onClose != null) {
          widget.callBack?.onClose!();
        }
        if (mounted) {
          setState(() {
            _isShowAd = false;
          });
        }
        break;
    }
  }
}
