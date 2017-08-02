//
//  DMUserManager.m
//  DisciplineManager
//
//  Created by fujl-mac on 2017/6/9.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMUserManager.h"
#import "DMWeakReferencesArray.h"
#import "DMLoginRequester.h"
#import "DMCheckLoginRequester.h"
#import "DMMainViewController.h"
#import "DMNavigationController.h"
#import "DMLoginViewController.h"
#import "DMBindPushRequester.h"
#import "DMPushManager.h"

#define kDMUserManagerLoginDataName @"login.info"
#define kDMUserManagerUserDataName @"user.info"

@interface DMUserManager ()
@property(nonatomic, strong) DMWeakReferencesArray *delegates;
@property(nonatomic, strong) DMLoginInfo *loginInfo;
@end

@implementation DMUserManager

- (instancetype)init {
    self = [super init];
    if (self) {
        _delegates = [[DMWeakReferencesArray alloc] init];
        [self loadUser];
    }
    return self;
}

- (BOOL)isNeedLogin {
    return [_loginInfo.userId isEqualToString:@""];
}

- (void)addOnUserChangeDelegate:(id <OnUserChangeDelegate>)delegate {
    [_delegates addObject:delegate];
}

- (void)removeOnUserChangeDelegate:(id <OnUserChangeDelegate>)delegate {
    [_delegates removeObject:delegate];
}

- (void)login:(NSString *)username password:(NSString *)password callback:(void (^)(DMResultCode code, NSString *errMsg))callback {
    DMLoginRequester *requester = [[DMLoginRequester alloc] init];
    requester.username = username;
    requester.password = password;
    [requester postRequest:^(DMResultCode code, id data) {
        if (code == ResultCodeOK) {
            DMLoginInfo *loginInfo = data;
            self.loginInfo = loginInfo;
            [self saveUser];
            if (callback) {
                callback(code, @"");
            }
            for(id <OnUserChangeDelegate> delegate in self.delegates.allObjects){
                if([delegate respondsToSelector:@selector(onUserWillLogin)]){
                    [delegate onUserWillLogin];
                }
            }
            // 通知 用户已经登录
            for(id <OnUserChangeDelegate> delegate in self.delegates.allObjects){
                if([delegate respondsToSelector:@selector(onUserDidLogin)]){
                    [delegate onUserDidLogin];
                }
            }
        } else {
            NSString *errMsg = data;
            if (callback) {
                callback(code, errMsg);
            }
        }
    }];
}

- (void)logout:(void (^)(DMResultCode code, NSString *errMsg))callback {
    _loginInfo = [[DMLoginInfo alloc] init];
    _loginInfo.userId = @"";
    [self saveUser];
    // 通知 用户退出登录
    for(id <OnUserChangeDelegate> delegate in self.delegates.allObjects){
        if([delegate respondsToSelector:@selector(onUserLogout)]){
            [delegate onUserLogout];
        }
    }
    callback(ResultCodeOK, @"退出登录成功");
}

- (void)isLogin:(void (^)(DMResultCode code))callback {
    DMCheckLoginRequester *requester = [[DMCheckLoginRequester alloc] init];
    [requester postRequest:^(DMResultCode code, id data) {
        callback(code);
    }];
}

- (void)autoLogin:(void (^)(DMResultCode code))callback {
    [self isLogin:^(DMResultCode code) {
        if (code == ResultCodeOK) {
            callback(ResultCodeOK);
        } else {
            [self login:_loginInfo.username password:_loginInfo.password callback:^(DMResultCode code, NSString *errMsg) {
                callback(code);
            }];
        }
    }];
}

- (void)bindPush {
    if ([self isNeedLogin]) {
        return;
    }
    DMPushManager *pushManager = getManager([DMPushManager class]);
    if (pushManager.isBindChannel) {
        DMBindPushRequester *requester = [[DMBindPushRequester alloc] init];
        requester.channelId = [pushManager getChannelId];
        [requester postRequest:^(DMResultCode code, id data) {
            if (code == ResultCodeOK) {
                [pushManager setTag:[NSString stringWithFormat:@"%@", self.loginInfo.userId]];
            }
        }];
    }
}

- (void)startMainController {
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithRGB:0x64C990]} forState:UIControlStateSelected];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithRGB:0x555555]} forState:UIControlStateNormal];
    DMMainViewController *mainViewController = [[DMMainViewController alloc] init];
    UINavigationController *mainNavigationController = [[DMNavigationController alloc] initWithRootViewController:mainViewController];
    
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    UIView *currentView = window.rootViewController.view;
    
    [UIView transitionFromView:currentView toView:mainNavigationController.view duration:0.4 options:UIViewAnimationOptionTransitionCrossDissolve completion:^(BOOL finished) {
        [window setRootViewController:mainNavigationController];
    }];
}

- (void)startLoginController {
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithRGB:0x64C990]} forState:UIControlStateSelected];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithRGB:0x555555]} forState:UIControlStateNormal];
    DMLoginViewController *loginViewController = [[DMLoginViewController alloc] init];
    
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    UIView *currentView = window.rootViewController.view;
    
    [UIView transitionFromView:currentView toView:loginViewController.view duration:0.4 options:UIViewAnimationOptionTransitionCrossDissolve completion:^(BOOL finished) {
        [window setRootViewController:loginViewController];
    }];
}


#pragma mark - getters and setters
-(DMUserInfo *)userInfo{
    // 拷贝一份 返回
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_loginInfo];
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

#pragma mark - UserInfo
- (void)loadUser {
    NSString *cachePath = [[[DMConfig mainConfig] getAppDocumentDirectory] stringByAppendingPathComponent:kDMUserManagerLoginDataName];
    
    DMLoginInfo *user = [NSKeyedUnarchiver unarchiveObjectWithFile:cachePath];
    if (user) {
        _loginInfo = user;
    } else {
        _loginInfo = [[DMLoginInfo alloc] init];
        _loginInfo.userId = @"";
    }
}

- (void)saveUser {
    NSString *cachePath = [[[DMConfig mainConfig] getAppDocumentDirectory] stringByAppendingPathComponent:kDMUserManagerLoginDataName];
    [NSKeyedArchiver archiveRootObject:_loginInfo toFile:cachePath];
}

@end
