//
//  SigmobLogUtil.m
//  Pods-Runner
//
//  Created by gstory on 2022/8/25.
//

#import <Foundation/Foundation.h>
#import "SigmobLogUtil.h"

@interface SigmobLogUtil()
@property(nonatomic,assign) BOOL isDebug;
@end


@implementation SigmobLogUtil

+ (instancetype)sharedInstance{
    static SigmobLogUtil *myInstance = nil;
    if(myInstance == nil){
        myInstance = [[SigmobLogUtil alloc]init];
    }
    return myInstance;
}

- (void)debug:(BOOL)isDebug{
    _isDebug = isDebug;
}

- (void)print:(NSString *)message{
    if(_isDebug){
        GLog(@"%@", message);
    }
}

@end


