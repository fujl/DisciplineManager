//
//  AppDelegate.m
//  DisciplineManager
//
//  Created by fujl-mac on 2017/6/5.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "AppDelegate.h"

#import "IQKeyboardManager.h"

#import "DMLoginViewController.h"
#import "DMMainViewController.h"
#import "DMNavigationController.h"
#import "DMLaunchViewController.h"
#import "DMPushManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].keyboardDistanceFromTextField = 80;
    
    [[UIApplication sharedApplication] setupManager];
    
    DMUserManager *userManager = getManager(DMUserManager);
    // 初始化程序Window
    UIViewController *rootController;
    if (userManager.isNeedLogin) {
        // 登录
        rootController = [[DMLoginViewController alloc] init];
    } else {
        rootController = [[DMLaunchViewController alloc] init];
        [userManager autoLogin:^(DMResultCode code) {
            if (code == ResultCodeOK) {
                [userManager startMainController];
            } else {
                [userManager startLoginController];
            }
        }];
    }
    
    UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    window.rootViewController = rootController;
    [window makeKeyAndVisible];
    window.backgroundColor = [UIColor appBackground];
    
    self.window = window;
    
    // 通知 程序的界面创建完成
    [[UIApplication sharedApplication] windowCreated];
    
    DMPushManager *pushManager = getManager([DMPushManager class]);
    [pushManager didFinishLaunchingWithOptions:launchOptions application:application];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[UIApplication sharedApplication] applicationDidEnterBackground];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [[UIApplication sharedApplication] applicationDidEnterBackground];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
