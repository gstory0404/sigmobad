//
//  SigmobAdNativeView.m
//  Pods-Runner
//
//  Created by gstory on 2022/8/25.
//

#import "SigmobAdNativeView.h"
#import <WindSDK/WindSDK.h>
#import "SigmobLogUtil.h"
#import "SigmobUIViewController+getCurrentVC.h"
#import "SigmobNativeAdCustomView.h"
#import "NativeAdViewStyle.h"

#pragma mark - SigmobAdNativeViewFactory
@implementation SigmobAdNativeViewFactory{
    NSObject<FlutterBinaryMessenger>*_messenger;
}

- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger> *)messager{
    self = [super init];
    if (self) {
        _messenger = messager;
    }
    return self;
}

-(NSObject<FlutterMessageCodec> *)createArgsCodec{
    return [FlutterStandardMessageCodec sharedInstance];
}

-(NSObject<FlutterPlatformView> *)createWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id)args{
    SigmobAdNativeView * nativeAd = [[SigmobAdNativeView alloc] initWithWithFrame:frame viewIdentifier:viewId arguments:args binaryMessenger:_messenger];
    return nativeAd;
}
@end

@interface SigmobAdNativeView()<WindNativeAdsManagerDelegate,WindNativeAdViewDelegate>

@property (nonatomic, strong) SigmobNativeAdCustomView *native;
@property (nonatomic, strong) WindNativeAdsManager *nativeAdsManager;
@property(nonatomic,strong) UIView *container;
@property(nonatomic,assign) CGRect frame;
@property(nonatomic,assign) NSInteger viewId;
@property(nonatomic,strong) FlutterMethodChannel *channel;
@property(nonatomic,strong) NSString *codeId;
@property(nonatomic,assign) NSInteger width;
@property(nonatomic,assign) NSInteger height;
@end

#pragma mark - SigmobAdNativeView
@implementation SigmobAdNativeView

- (instancetype)initWithWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id)args binaryMessenger:(NSObject<FlutterBinaryMessenger> *)messenger{
    if ([super init]) {
        NSDictionary *dic = args;
        self.viewId = viewId;
        self.codeId = dic[@"iosId"];
        self.width =[dic[@"viewWidth"] intValue];
        self.height =[dic[@"viewHeight"] intValue];
        NSString* channelName = [NSString stringWithFormat:@"com.gstory.sigmobad/NativeView_%lld", viewId];
        self.channel = [FlutterMethodChannel methodChannelWithName:channelName binaryMessenger:messenger];
        self.container = [[UIView alloc] initWithFrame:frame];
        [self loadNativeAd];
    }
    return self;
}

- (UIView*)view{
    return self.container;
}

-(void)loadNativeAd{
    [self.container removeFromSuperview];
    WindAdRequest *request = [WindAdRequest request];
    request.placementId = self.codeId;
    request.userId = @"";
    self.nativeAdsManager = [[WindNativeAdsManager alloc] initWithRequest:request];
    self.nativeAdsManager.delegate = self;
    [self.nativeAdsManager loadAdDataWithCount:1];
}

#pragma mark - WindNativeAdsManagerDelegate

//    广告加载成功
- (void)nativeAdsManagerSuccessToLoad:(WindNativeAdsManager *)adsManager nativeAds:(NSArray<WindNativeAd *> *)nativeAdDataArray{
    [[SigmobLogUtil sharedInstance] print:[NSString stringWithFormat:@"信息流广告加载成功 %d",nativeAdDataArray.count]];
    if(nativeAdDataArray.count == 0){
        return;
    }
    CGRect frame =self.frame;
    frame.size.width = self.width;
    self.native =  [[SigmobNativeAdCustomView alloc] initWithFrame:frame];
    //    self.native.frame = frame;
    self.native.delegate = self;
    self.native.viewController = [UIViewController jsd_getCurrentViewController];
    [self.container addSubview:self.native];
    [self.native refreshData:nativeAdDataArray[0]];
    [NativeAdViewStyle layoutWithModel:nativeAdDataArray[0] adView:self.native];
}

//广告加载失败
- (void)nativeAdsManager:(WindNativeAdsManager *)adsManager didFailWithError:(NSError *)error{
    [[SigmobLogUtil sharedInstance] print:([NSString stringWithFormat:@"信息流广告拉取失败 %@",error])];
    NSDictionary *dictionary = @{@"message":error.description};
    [_channel invokeMethod:@"onFail" arguments:dictionary result:nil];
}

#pragma mark - WindNativeAdViewDelegate
/**
 广告曝光回调
 
 @param nativeAdView WindNativeAdView 实例
 */
- (void)nativeAdViewWillExpose:(WindNativeAdView *)nativeAdView{
    [[SigmobLogUtil sharedInstance] print:@"信息流广告曝光"];
}


/**
 广告点击回调
 
 @param nativeAdView WindNativeAdView 实例
 */
- (void)nativeAdViewDidClick:(WindNativeAdView *)nativeAdView{
    [[SigmobLogUtil sharedInstance] print:@"信息流广告点击"];
    [_channel invokeMethod:@"onClick" arguments:nil result:nil];
}


/**
 广告详情页关闭回调
 
 @param nativeAdView WindNativeAdView 实例
 */
- (void)nativeAdDetailViewClosed:(WindNativeAdView *)nativeAdView{
    [[SigmobLogUtil sharedInstance] print:@"信息流广告详情页关闭回调"];
}


/**
 广告详情页面即将展示回调
 
 @param nativeAdView WindNativeAdView 实例
 */
- (void)nativeAdDetailViewWillPresentScreen:(WindNativeAdView *)nativeAdView{
    [[SigmobLogUtil sharedInstance] print:@"信息流广告详情页面即将展示"];
}


/**
 视频广告播放状态更改回调
 
 @param nativeAdView WindNativeAdView 实例
 @param status 视频广告播放状态
 @param userInfo 视频广告信息
 */
- (void)nativeAdView:(WindNativeAdView *)nativeAdView playerStatusChanged:(WindMediaPlayerStatus)status userInfo:(NSDictionary *)userInfo{
    [[SigmobLogUtil sharedInstance] print:@"信息流广告播放状态更改"];
}


/**
 点击dislike回调
 开发者需要在这个回调中移除视图，否则，会出现用户点击叉无效的情况
 
 @param filterWords : 选择不喜欢的原因
 */
- (void)nativeAdView:(WindNativeAdView *)nativeAdView dislikeWithReason:(NSArray<WindDislikeWords *> *)filterWords{
    [[SigmobLogUtil sharedInstance] print:@"信息流广告点击dislike"];
    [_channel invokeMethod:@"onClose" arguments:nil result:nil];
}

@end
