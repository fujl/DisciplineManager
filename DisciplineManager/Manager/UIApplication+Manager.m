//
//  UIApplication+Manager.m
//  DisciplineManager
//
//  Created by fujl-mac on 2017/6/9.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "UIApplication+Manager.h"
#import "DMUserManager.h"
#import "DMNetworkManager.h"
#import "DMAddressManager.h"
#import "DMDBManager.h"
#import "DMDBCommonManager.h"
#import "DMHttpManager.h"

static NSMutableArray<__kindof DMBaseManager *> *managers;

@implementation UIApplication(Manager)

- (__kindof DMBaseManager *)getManager:(Class)cls {
    NSAssert([NSThread currentThread] == [NSThread mainThread], @"请在UI线程获取管理类！");
    
    DMBaseManager *result = nil;
    for (DMBaseManager *manager in managers) {
        if ([manager class] == cls) {
            result = manager;
            break;
        }
    }
    
    NSAssert(result != nil, @"管理类未初始化，请在registerManager方法中注册！");
    return result;
}

- (NSArray<__kindof DMBaseManager *> *)allManager {
    NSAssertMainThread;
    return managers;
}

- (void)setupManager {
    NSAssert(managers == nil, @"管理器已初始化！");
    
    managers = [NSMutableArray array];
    
    NSMutableArray<Class> *managerClass = [[NSMutableArray alloc] init];
    [self registerManager:managerClass];
    for (Class cls in managerClass) {
        DMBaseManager *manager = [[cls alloc] init];
        [managers addObject:manager];
    }
    
    // 通知 所有的管理类创建完成
    for (DMBaseManager *manager in managers) {
        [manager allManagerCreated];
    }
}

- (void)windowCreated {
    NSAssertMainThread;
    
    for (DMBaseManager *manager in managers) {
        [manager windowCreated];
    }
}

- (void)applicationDidEnterBackground {
    NSAssertMainThread;
    
    for (DMBaseManager *manager in managers) {
        [manager applicationDidEnterBackground];
    }
}

- (void)applicationWillEnterForeground {
    NSAssertMainThread;
    
    for (DMBaseManager *manager in managers) {
        [manager applicationWillEnterForeground];
    }
}

- (void)registerManager:(NSMutableArray<Class> *)list {
    [list addObject:[DMUserManager class]]; // 用户管理类
    [list addObject:[DMDBManager class]]; // 数据库管理
    [list addObject:[DMDBCommonManager class]];
    [list addObject:[DMNetworkManager class]]; // 网络管理
    [list addObject:[DMAddressManager class]];    // 地址管理
    //    [list addObject:[LMDCacheManager class]]; // 缓存管理
    //    [list addObject:[LMDSettingManager class]]; // 设置管理
    [list addObject:[DMHttpManager class]];    // 网络请求
//    [list addObject:[LMDHCPManager class]];    // PES请求

//    [list addObject:[LMDMsgManager class]];    // 消息管理
//    [list addObject:[LMDExaminationManager class]]; // 体检管理
//    [list addObject:[LMDFunctionListManager class]]; //配置列表管理（医生、网格等）
//    [list addObject:[LMDNewVersionManager class]];  // 更新管理器
//    [list addObject:[LMDPushNotificationManager class]]; // 推送通知管理
    
}

@end
