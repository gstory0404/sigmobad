//
//  SigmobInterstitialAd.m
//  Masonry
//
//  Created by gstory on 2022/8/25.
//

#import "SigmobInterstitialAd.h"
#import <WindSDK/WindSDK.h>
#import "SigmobAdEvent.h"
#import "SigmobUIViewController+getCurrentVC.h"
#import "SigmobLogUtil.h"

@interface SigmobInterstitialAd()<WindNewIntersititialAdDelegate>

@property(nonatomic,strong) WindNewIntersititialAd *intersititialAd;
@property(nonatomic,strong) NSString *codeId;
@property(nonatomic,strong) NSString *userId;
@end

@implementation SigmobInterstitialAd

+ (instancetype)sharedInstance{
    static SigmobInterstitialAd *myInstance = nil;
    if(myInstance == nil){
        myInstance = [[SigmobInterstitialAd alloc]init];
    }
    return myInstance;
}

//预加载激励广告
-(void)loadAd:(NSDictionary*)arguments{
    NSDictionary *dic = arguments;
    self.codeId = dic[@"iosId"];
    self.userId = dic[@"userId"];
    WindAdRequest *request = [WindAdRequest request];
    request.userId = self.userId;
    request.placementId = self.codeId;
    self.intersititialAd = [[WindNewIntersititialAd alloc] initWithRequest:request];
    self.intersititialAd.delegate = self;
    [self.intersititialAd loadAdData];
}

- (void)showAd{
    if(self.intersititialAd == nil || !self.intersititialAd.ready){
        NSDictionary *dictionary = @{@"adType":@"interstitialAd",@"onAdMethod":@"onUnReady"};
        [[SigmobAdEvent sharedInstance] sentEvent:dictionary];
        return;
    }
    [self.intersititialAd showAdFromRootViewController:[UIViewController jsd_getCurrentViewController] options:nil];
}

#pragma mark - WindIntersititialAdDelegate

/**
 广告加载成功
 */
- (void)intersititialAdDidLoad:(WindNewIntersititialAd *)intersititialAd{
    [[SigmobLogUtil sharedInstance] print:(@"插屏广告加载成功")];
    NSDictionary *dictionary = @{@"adType":@"interstitialAd",@"onAdMethod":@"onReady"};
    [[SigmobAdEvent sharedInstance] sentEvent:dictionary];
}

/**
 广告加载失败
 @param error : the reason of error
 */
- (void)intersititialAdDidLoad:(WindNewIntersititialAd *)intersititialAd didFailWithError:(NSError *)error{
    [[SigmobLogUtil sharedInstance] print:([NSString stringWithFormat:@"激励广告加载失败 %@",error.description])];
    NSDictionary *dictionary = @{@"adType":@"interstitialAd",@"onAdMethod":@"onFail",@"message":[NSString stringWithFormat:@"%@",error]};
    [[SigmobAdEvent sharedInstance] sentEvent:dictionary];
}


/**
 广告即将展示
 */
- (void)intersititialAdWillVisible:(WindNewIntersititialAd *)intersititialAd{
    [[SigmobLogUtil sharedInstance] print:(@"插屏广告即将展示")];
}

/**
 广告展示
 */
- (void)intersititialAdDidVisible:(WindNewIntersititialAd *)intersititialAd{
    [[SigmobLogUtil sharedInstance] print:(@"插屏广告展示")];
    NSDictionary *dictionary = @{@"adType":@"interstitialAd",@"onAdMethod":@"onShow"};
    [[SigmobAdEvent sharedInstance] sentEvent:dictionary];
}

/**
 广告点击
 */
- (void)intersititialAdDidClick:(WindNewIntersititialAd *)intersititialAd{
    [[SigmobLogUtil sharedInstance] print:(@"插屏广告点击")];
    NSDictionary *dictionary = @{@"adType":@"interstitialAd",@"onAdMethod":@"onClick"};
    [[SigmobAdEvent sharedInstance] sentEvent:dictionary];
}

/**
 广告点击跳过
 */
- (void)intersititialAdDidClickSkip:(WindNewIntersititialAd *)intersititialAd{
    [[SigmobLogUtil sharedInstance] print:(@"插屏广告点击跳过")];
}

/**
 广告关闭
 */
- (void)intersititialAdDidClose:(WindNewIntersititialAd *)intersititialAd{
    [[SigmobLogUtil sharedInstance] print:(@"插屏广告关闭")];
    NSDictionary *dictionary = @{@"adType":@"intersititialAd",@"onAdMethod":@"onClose"};
    [[SigmobAdEvent sharedInstance] sentEvent:dictionary];
}

/**
 广告视频播放结束/错误
 @param error : the reason of error
 */
- (void)intersititialAdDidPlayFinish:(WindNewIntersititialAd *)intersititialAd didFailWithError:(NSError *)error{
    [[SigmobLogUtil sharedInstance] print:(@"插屏广告视频播放结束/错误")];
}

/**
 填充广告数据，此时不代表广告ready
 */
- (void)intersititialAdServerResponse:(WindNewIntersititialAd *)intersititialAd isFillAd:(BOOL)isFillAd{
    
}


@end
