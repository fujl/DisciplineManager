//
//  DMPushManager.h
//  DisciplineManager
//
//  Created by apple on 17/8/2.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMBaseManager.h"

@interface DMPushManager : DMBaseManager

@property (nonatomic, assign) BOOL isBindChannel;
@property(nonatomic, strong) void (^onNewMsgBlock)();

- (void)didFinishLaunchingWithOptions:(NSDictionary *)launchOptions application:(UIApplication *)application;

- (void)applicationDidEnterBackground;

- (void)didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;

- (void)handleNotification:(NSDictionary *)userInfo;

- (void)showLocalNotificationAtFront:(UILocalNotification *)notification;

- (void)setTag:(NSString *)tag;

- (NSString *)getChannelId;

@end
