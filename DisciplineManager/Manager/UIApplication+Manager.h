//
//  UIApplication+Manager.h
//  DisciplineManager
//
//  Created by fujl-mac on 2017/6/9.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (Manager)

// 获取程序管理器，程序所有的管理器通过此方法获取实例
- (__kindof DMBaseManager *)getManager:(Class)cls;

// 获取所有的管理类
- (NSArray<__kindof DMBaseManager *> *)allManager;

// 控制管理器生命周期
- (void)setupManager;

- (void)windowCreated;

- (void)applicationDidEnterBackground;

- (void)applicationWillEnterForeground;

@end
