#import "SigmobadPlugin.h"
#import <WindSDK/WindSDK.h>
#import "SigmobLogUtil.h"
#import "SigmobAdEvent.h"
#import "SigmobRewardAd.h"
#import "SigmobAdNativeView.h"
#import "SigmobInterstitialAd.h"
#import "SigmobAdSplashView.h"

@implementation SigmobadPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"sigmobad"
                                     binaryMessenger:[registrar messenger]];
    SigmobadPlugin* instance = [[SigmobadPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
    //注册event
    [[SigmobAdEvent sharedInstance]  initEvent:registrar];
    //注册native
    [registrar registerViewFactory:[[SigmobAdNativeViewFactory alloc] initWithMessenger:registrar.messenger] withId:@"com.gstory.sigmobad/NativeView"];
    //注册splash
    [registrar registerViewFactory:[[SigmobAdSplashViewFactory alloc] initWithMessenger:registrar.messenger] withId:@"com.gstory.sigmobad/SplashView"];

}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    //初始化
    if ([@"register" isEqualToString:call.method]) {
        NSString *appId = call.arguments[@"iosId"];
        NSString *appKey = call.arguments[@"iosAppKey"];
        BOOL debug = [call.arguments[@"debug"] boolValue];
        BOOL personalized =  [call.arguments[@"personalized"] boolValue];
        [[SigmobLogUtil sharedInstance] debug:debug];
        [WindAds setDebugEnable:debug];
        WindAdOptions *option = [[WindAdOptions alloc] initWithAppId:appId appKey:appKey];
        //个性化推荐
        [WindAds setPersonalizedAdvertising:personalized ? WindPersonalizedAdvertisingOn : WindPersonalizedAdvertisingOff];
        [WindAds startWithOptions:option];
        //渠道id
        result(@YES);
        //sdk版本
    }else if([@"getSDKVersion" isEqualToString:call.method]){
        NSString *version = [WindAds sdkVersion];
        result(version);
        //预加载激励广告
    }else if([@"loadRewardAd" isEqualToString:call.method]){
        [[SigmobRewardAd sharedInstance] loadAd:call.arguments];
        result(@YES);
        //显示激励广告
    }else if([@"showRewardAd" isEqualToString:call.method]){
        [[SigmobRewardAd sharedInstance] showAd];
        result(@YES);
        //预加载插屏广告
    }else if([@"loadInterstitialAd" isEqualToString:call.method]){
        [[SigmobInterstitialAd sharedInstance] loadAd:call.arguments];
        result(@YES);
        //显示插屏广告
    }else if([@"showInterstitialAd" isEqualToString:call.method]){
        [[SigmobInterstitialAd sharedInstance] showAd];
        result(@YES);
    } else {
        result(FlutterMethodNotImplemented);
    }
}

@end
