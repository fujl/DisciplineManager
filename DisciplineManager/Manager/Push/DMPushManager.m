//
//  DMPushManager.m
//  DisciplineManager
//
//  Created by apple on 17/8/2.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMPushManager.h"
#import "BPush.h"

@implementation DMPushManager

- (void)didFinishLaunchingWithOptions:(NSDictionary *)launchOptions application:(UIApplication *)application {
    
    [BPush registerChannel:launchOptions apiKey:@"CcXRpllwd2kwcYqhAyDjrumX" pushMode:BPushModeDevelopment withFirstAction:@"打开" withSecondAction:@"关闭" withCategory:@"test" useBehaviorTextInput:YES isDebug:YES];
}

@end
