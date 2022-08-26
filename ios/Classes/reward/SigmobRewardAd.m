//
//  SigmobRewardAd.m
//  Pods-Runner
//
//  Created by gstory on 2022/8/25.
//

#import "SigmobRewardAd.h"
#import <WindSDK/WindSDK.h>
#import "SigmobAdEvent.h"
#import "SigmobUIViewController+getCurrentVC.h"
#import "SigmobLogUtil.h"

@interface SigmobRewardAd()<WindRewardVideoAdDelegate>

@property(nonatomic,strong) WindRewardVideoAd *reward;
@property(nonatomic,strong) NSString *codeId;
@property(nonatomic,strong) NSString *rewardName;
@property(nonatomic,strong) NSString *rewardAmount;
@property(nonatomic,strong) NSString *userId;
@property(nonatomic,strong) NSString *customData;

@end

@implementation SigmobRewardAd

+ (instancetype)sharedInstance{
    static SigmobRewardAd *myInstance = nil;
    if(myInstance == nil){
        myInstance = [[SigmobRewardAd alloc]init];
    }
    return myInstance;
}

//预加载激励广告
-(void)loadAd:(NSDictionary*)arguments{
    NSDictionary *dic = arguments;
    self.codeId = dic[@"iosId"];
    self.rewardName = dic[@"rewardName"];
    self.rewardAmount = dic[@"rewardAmount"];
    self.userId =dic[@"userId"];
    self.customData = dic[@"customData"];
    WindAdRequest *request = [WindAdRequest request];
    request.userId = self.userId;
    request.placementId = self.codeId;
    NSDictionary *data = @{@"data":self.customData};
    request.options = data;
    self.reward = [[WindRewardVideoAd alloc] initWithRequest:request];
    self.reward.delegate = self;
    [self.reward loadAdData];
    [[SigmobLogUtil sharedInstance] print:(@"激励广告开始加载")];
}

- (void)showAd{
    if(self.reward == nil || !self.reward.ready){
        NSDictionary *dictionary = @{@"adType":@"rewardAd",@"onAdMethod":@"onUnReady"};
        [[SigmobAdEvent sharedInstance] sentEvent:dictionary];
        return;
    }
    [self.reward showAdFromRootViewController:[UIViewController jsd_getCurrentViewController] options:nil];
}

#pragma mark - WindRewardVideoAdDelegate
/**
 奖励
 */
- (void)rewardVideoAd:(WindRewardVideoAd *)rewardVideoAd reward:(WindRewardInfo *)reward{
    [[SigmobLogUtil sharedInstance] print:([NSString stringWithFormat:@"激励广告发放奖励 %@",reward])];
    NSDictionary *dictionary = @{@"adType":@"rewardAd",@"onAdMethod":@"onVerify",@"hasReward":[NSNumber numberWithBool:reward.isCompeltedView ],@"rewardAmount":self.rewardAmount,@"rewardName":self.rewardName};
    [[SigmobAdEvent sharedInstance] sentEvent:dictionary];
}

/**
 广告加载成功（此时广告处于Ready状态，等待播放）
 */
- (void)rewardVideoAdDidLoad:(WindRewardVideoAd *)rewardVideoAd{
    [[SigmobLogUtil sharedInstance] print:(@"激励广告加载成功")];
    NSDictionary *dictionary = @{@"adType":@"rewardAd",@"onAdMethod":@"onReady"};
    [[SigmobAdEvent sharedInstance] sentEvent:dictionary];
}

/**
 广告加载失败
 @param error : 错误原因
 */
- (void)rewardVideoAdDidLoad:(WindRewardVideoAd *)rewardVideoAd didFailWithError:(NSError *)error{
    [[SigmobLogUtil sharedInstance] print:([NSString stringWithFormat:@"激励广告加载失败 %@",error.description])];
    NSDictionary *dictionary = @{@"adType":@"rewardAd",@"onAdMethod":@"onFail",@"message":error.description};
    [[SigmobAdEvent sharedInstance] sentEvent:dictionary];
}

/**
 此方法在视频广告位将要显示时调用。
 */
- (void)rewardVideoAdWillVisible:(WindRewardVideoAd *)rewardVideoAd{
    [[SigmobLogUtil sharedInstance] print:(@"激励广告将要显示")];
}

/**
 此方法在视频广告位已显示时调用。
 */
- (void)rewardVideoAdDidVisible:(WindRewardVideoAd *)rewardVideoAd{
    [[SigmobLogUtil sharedInstance] print:(@"激励广告显示")];
    NSDictionary *dictionary = @{@"adType":@"rewardAd",@"onAdMethod":@"onShow"};
    [[SigmobAdEvent sharedInstance] sentEvent:dictionary];
}

/**
 点击视频广告时调用此方法。
 */
- (void)rewardVideoAdDidClick:(WindRewardVideoAd *)rewardVideoAd{
    NSDictionary *dictionary = @{@"adType":@"rewardAd",@"onAdMethod":@"onClick"};
    [[SigmobAdEvent sharedInstance] sentEvent:dictionary];
}

/**
 当点击视频广告跳过按钮时调用此方法。
 */
- (void)rewardVideoAdDidClickSkip:(WindRewardVideoAd *)rewardVideoAd{
    [[SigmobLogUtil sharedInstance] print:(@"激励广告跳过")];
}

/**
 该方法在视频广告即将关闭时调用。
 */
- (void)rewardVideoAdDidClose:(WindRewardVideoAd *)rewardVideoAd{
    [[SigmobLogUtil sharedInstance] print:(@"激励广告即将关闭")];
}

/**
 当视频广告播放完成或发生错误时调用此方法。
 @param error : 错误原因
 */
- (void)rewardVideoAdDidPlayFinish:(WindRewardVideoAd *)rewardVideoAd didFailWithError:(NSError *)error{
    [[SigmobLogUtil sharedInstance] print:(@"激励广告关闭")];
    NSDictionary *dictionary = @{@"adType":@"rewardAd",@"onAdMethod":@"onClose"};
    [[SigmobAdEvent sharedInstance] sentEvent:dictionary];
}

/**
 从 sigmob 广告服务器返回广告时调用此方法。
 */
- (void)rewardVideoAdServerResponse:(WindRewardVideoAd *)rewardVideoAd isFillAd:(BOOL)isFillAd{
    [[SigmobLogUtil sharedInstance] print:(@"激励广告服务器返回广告")];
}

@end
