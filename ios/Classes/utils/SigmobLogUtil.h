//
//  SigmobLogUtil.h
//  Pods-Runner
//
//  Created by gstory on 2022/8/25.
//

#ifdef DEBUG
#define GLog(...) NSLog(@"%s\n %@\n\n", __func__, [NSString stringWithFormat:__VA_ARGS__])
#else
#define GLog(...)
#endif

NS_ASSUME_NONNULL_BEGIN

@interface SigmobLogUtil : NSObject
+ (instancetype)sharedInstance;
- (void)debug:(BOOL)isDebug;
- (void)print:(NSString *)message;
@end

NS_ASSUME_NONNULL_END
