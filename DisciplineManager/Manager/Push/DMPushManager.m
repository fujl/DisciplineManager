//
//  DMPushManager.m
//  DisciplineManager
//
//  Created by apple on 17/8/2.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMPushManager.h"
#import "BPush.h"

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@implementation DMPushManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isBindChannel = NO;
    }
    return self;
}

- (void)didFinishLaunchingWithOptions:(NSDictionary *)launchOptions application:(UIApplication *)application {
    
    // iOS10 下需要使用新的 API
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0) {
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
        UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
        
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound + UNAuthorizationOptionBadge)
                              completionHandler:^(BOOL granted, NSError * _Nullable error) {
                                  // Enable or disable features based on authorization.
                                  if (granted) {
                                      [application registerForRemoteNotifications];
                                  }
                              }];
#endif
    }
    else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIUserNotificationType myTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:myTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }else {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }
    
    [BPush registerChannel:launchOptions apiKey:@"CcXRpllwd2kwcYqhAyDjrumX" pushMode:BPushModeDevelopment withFirstAction:@"打开" withSecondAction:@"关闭" withCategory:@"test" useBehaviorTextInput:YES isDebug:YES];
    
    // App 是用户点击推送消息启动
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        [BPush handleNotification:userInfo];
    }
    
    [self clearNotification];
}

- (void)applicationDidEnterBackground {
    [self clearNotification];
    __block UIBackgroundTaskIdentifier bgTask;
    bgTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^(void) {
        [[UIApplication sharedApplication] endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }];
}

- (void)didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *tmp = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    tmp = [tmp stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"deviceToken:%@", tmp);
    DMUserManager *manager = getManager([DMUserManager class]);
    manager.deviceToken = tmp;
    
    [BPush registerDeviceToken:deviceToken];
    [BPush bindChannelWithCompleteHandler:^(id result, NSError *error) {
        // 需要在绑定成功后进行 settag listtag deletetag unbind 操作否则会失败
        
        // 网络错误
        if (error) {
            return ;
        }
        if (result) {
            // 确认绑定成功
            if ([result[@"error_code"]intValue]!=0) {
                return;
            }
            self.isBindChannel = YES;
            DMUserManager *manager = getManager([DMUserManager class]);
            [manager bindPush];
            // 获取channel_id
            NSString *myChannel_id = [BPush getChannelId];
            NSLog(@"==%@",myChannel_id);
            
            [BPush listTagsWithCompleteHandler:^(id result, NSError *error) {
                if (result) {
                    NSLog(@"result ============== %@",result);
                }
            }];
        }
    }];
}

- (void)setTag:(NSString *)tag {
    [BPush setTag:tag withCompleteHandler:^(id result, NSError *error) {
        if (result) {
            NSLog(@"设置tag成功");
        }
    }];
}

- (NSString *)getChannelId {
    return [BPush getChannelId];
}

- (void)handleNotification:(NSDictionary *)userInfo {
    // App 收到推送的通知
    [BPush handleNotification:userInfo];
    if (self.onNewMsgBlock) {
        self.onNewMsgBlock();
    }
}

- (void)showLocalNotificationAtFront:(UILocalNotification *)notification {
    NSLog(@"接收本地通知啦！！！");
    [BPush showLocalNotificationAtFront:notification identifierKey:nil];
    if (self.onNewMsgBlock) {
        self.onNewMsgBlock();
    }
}

#pragma mark - private method
- (void)clearNotification {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}
@end
