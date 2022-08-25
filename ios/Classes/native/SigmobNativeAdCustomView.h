//
//  SigmobNativeAdCustomView.h
//  Pods-Runner
//
//  Created by gstory on 2022/8/25.
//

#import <Foundation/Foundation.h>
#import <WindSDK/WindSDK.h>

@interface SigmobNativeAdCustomView : WindNativeAdView
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIButton *CTAButton;
@property (nonatomic, strong) UIImageView *mainImageView;
@end
