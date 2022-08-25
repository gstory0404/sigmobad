//
//  SigmobAdEvent.h
//  Pods-Runner
//
//  Created by gstory on 2022/8/25.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

@interface SigmobAdEvent : NSObject
+ (instancetype)sharedInstance;
- (void)initEvent:(NSObject<FlutterPluginRegistrar>*)registrar;
- (void)sentEvent:(NSDictionary*)arguments;
@end

NS_ASSUME_NONNULL_END
