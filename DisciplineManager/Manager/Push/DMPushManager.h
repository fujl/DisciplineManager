//
//  DMPushManager.h
//  DisciplineManager
//
//  Created by apple on 17/8/2.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMBaseManager.h"

/*
 个推账号
 starzhang
 worinimab110
 
 zhengshu pwd dm123456
 */
@interface DMPushManager : DMBaseManager

@property (nonatomic, assign) BOOL isBindClientId;
@property (nonatomic, copy) void (^onNewMsgBlock)();

- (void)didFinishLaunchingWithOptions:(NSDictionary *)launchOptions application:(UIApplication *)application;

- (void)applicationDidEnterBackground;

- (void)didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;

- (void)didFailToRegisterForRemoteNotificationsWithError:(NSError *)error;

- (void)handleNotification:(NSDictionary *)userInfo;

- (void)showLocalNotificationAtFront:(UILocalNotification *)notification;

- (void)setTag:(NSString *)tag;

- (NSString *)getClientId;

@end
