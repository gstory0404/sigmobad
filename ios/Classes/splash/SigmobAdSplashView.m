//
//  SigmobAdSplashView.m
//  sigmobad
//
//  Created by gstory on 2022/8/25.
//

#import "SigmobAdSplashView.h"
#import <WindSDK/WindSDK.h>
#import "SigmobLogUtil.h"
#import "SigmobUIViewController+getCurrentVC.h"
#import "SigmobNativeAdCustomView.h"
#import "NativeAdViewStyle.h"

#pragma mark - SigmobAdSplashViewFactory
@implementation SigmobAdSplashViewFactory{
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
    SigmobAdSplashView * nativeAd = [[SigmobAdSplashView alloc] initWithWithFrame:frame viewIdentifier:viewId arguments:args binaryMessenger:_messenger];
    return nativeAd;
}
@end

@interface SigmobAdSplashView()<WindSplashAdViewDelegate>

@property (nonatomic, strong) WindSplashAdView *splashView;
@property(nonatomic,strong) UIView *container;
@property(nonatomic,assign) CGRect frame;
@property(nonatomic,assign) NSInteger viewId;
@property(nonatomic,strong) FlutterMethodChannel *channel;
@property(nonatomic,strong) NSString *codeId;
@property(nonatomic,assign) NSInteger fetchDelay;
@property(nonatomic,assign) NSInteger width;
@property(nonatomic,assign) NSInteger height;
@property(nonatomic,strong) NSString *userId;
@end

#pragma mark - SigmobAdSplashView
@implementation SigmobAdSplashView

- (instancetype)initWithWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id)args binaryMessenger:(NSObject<FlutterBinaryMessenger> *)messenger{
    if ([super init]) {
        NSDictionary *dic = args;
        self.viewId = viewId;
        self.codeId = dic[@"iosId"];
        self.userId = dic[@"userId"];
        self.fetchDelay =[dic[@"fetchDelay"] intValue];
        self.width =[dic[@"width"] intValue];
        self.height =[dic[@"height"] intValue];
        NSString* channelName = [NSString stringWithFormat:@"com.gstory.sigmobad/SplashView_%lld", viewId];
        self.channel = [FlutterMethodChannel methodChannelWithName:channelName binaryMessenger:messenger];
        self.container = [[UIView alloc] initWithFrame:frame];
        [self loadSplashAd];
    }
    return self;
}

- (UIView*)view{
    return self.container;
}

-(void)loadSplashAd{
    [self.container removeFromSuperview];
    WindAdRequest *request = [WindAdRequest request];
    request.placementId = self.codeId;
    request.userId = self.userId;
    self.splashView = [[WindSplashAdView alloc] initWithRequest:request];
    self.splashView.frame = CGRectMake(0, 0,self.width, self.height);
    self.splashView.delegate = self;
    self.splashView.fetchDelay = self.fetchDelay;
    self.splashView.rootViewController =[UIViewController jsd_getCurrentViewController];
    [self.splashView loadAdData];
}


#pragma mark - WindSplashAdViewDelegate

/**
 *  ??????????????????????????????
 */
- (void)onSplashAdDidLoad:(WindSplashAdView *)splashAdView{
    [[SigmobLogUtil sharedInstance] print:@"??????????????????????????????"];
    [self.container addSubview:self.splashView];
}

/**
 *  ??????????????????
 */
-(void)onSplashAdLoadFail:(WindSplashAdView *)splashAdView error:(NSError *)error{
    [[SigmobLogUtil sharedInstance] print:([NSString stringWithFormat:@"???????????????????????? %@",error])];
    NSDictionary *dictionary = @{@"message":error.description};
    [_channel invokeMethod:@"onFail" arguments:dictionary result:nil];
}

/**
 *  ????????????????????????
 */
-(void)onSplashAdSuccessPresentScreen:(WindSplashAdView *)splashAdView{
    [[SigmobLogUtil sharedInstance] print:@"????????????????????????"];
    [_channel invokeMethod:@"onShow" arguments:nil result:nil];
}

/**
 *  ????????????????????????
 */
-(void)onSplashAdFailToPresent:(WindSplashAdView *)splashAdView withError:(NSError *)error{
    [[SigmobLogUtil sharedInstance] print:([NSString stringWithFormat:@"???????????????????????? %@",error])];
    NSDictionary *dictionary = @{@"message":error.description};
    [_channel invokeMethod:@"onFail" arguments:dictionary result:nil];
}


/**
 *  ????????????????????????
 */
- (void)onSplashAdClicked:(WindSplashAdView *)splashAdView{
    [[SigmobLogUtil sharedInstance] print:@"??????????????????"];
    [_channel invokeMethod:@"onClick" arguments:nil result:nil];
}


/**
 *  ????????????????????????
 */
- (void)onSplashAdSkiped:(WindSplashAdView *)splashAdView{
    [[SigmobLogUtil sharedInstance] print:@"????????????????????????"];
}

/**
 *  ????????????????????????
 */
- (void)onSplashAdClosed:(WindSplashAdView *)splashAdView{
    [[SigmobLogUtil sharedInstance] print:@"??????????????????"];
    [_channel invokeMethod:@"onClose" arguments:nil result:nil];
}
@end

