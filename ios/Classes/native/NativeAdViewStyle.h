//
//  NativeAdViewStyle.h
//  sigmobad
//
//  Created by gstory on 2022/8/25.
//

#import <Foundation/Foundation.h>

@class WindNativeAd;
@class NativeAdCustomView;

@interface NativeAdViewStyle : NSObject

+ (void)layoutWithModel:(WindNativeAd *)nativeAd adView:(NativeAdCustomView *)adView;

+ (CGFloat)cellHeightWithModel:(WindNativeAd *)model width:(CGFloat)width;

@end
