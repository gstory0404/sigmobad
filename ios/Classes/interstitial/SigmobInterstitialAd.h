//
//  SigmobInterstitialAd.h
//  Masonry
//
//  Created by gstory on 2022/8/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SigmobInterstitialAd : NSObject

+ (instancetype)sharedInstance;
- (void)loadAd:(NSDictionary *)arguments;
- (void)showAd;

@end

NS_ASSUME_NONNULL_END
