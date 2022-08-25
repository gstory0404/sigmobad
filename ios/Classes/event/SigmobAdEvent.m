//
//  SigmobEvent.m
//  Pods-Runner
//
//  Created by gstory on 2022/8/25.
//

#import "SigmobAdEvent.h"
#import <Flutter/Flutter.h>

@interface SigmobAdEvent()<FlutterStreamHandler>
@property(nonatomic,strong) FlutterEventSink eventSink;
@end

@implementation SigmobAdEvent

+ (instancetype)sharedInstance{
    static SigmobAdEvent *myInstance = nil;
    if(myInstance == nil){
        myInstance = [[SigmobAdEvent alloc]init];
    }
    return myInstance;
}


- (void)initEvent:(NSObject<FlutterPluginRegistrar>*)registrar{
    FlutterEventChannel *eventChannel = [FlutterEventChannel eventChannelWithName:@"com.gstory.sigmobad/adevent"   binaryMessenger:[registrar messenger]];
    [eventChannel setStreamHandler:self];
}

-(void)sentEvent:(NSDictionary*)arguments{
    self.eventSink(arguments);
}



#pragma mark - FlutterStreamHandler
- (FlutterError * _Nullable)onCancelWithArguments:(id _Nullable)arguments {
    self.eventSink = nil;
    return nil;
}

- (FlutterError * _Nullable)onListenWithArguments:(id _Nullable)arguments eventSink:(nonnull FlutterEventSink)events {
    self.eventSink = events;
    return nil;
}@end


