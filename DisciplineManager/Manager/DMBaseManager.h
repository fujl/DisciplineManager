//
//  DMBaseManager.h
//  DisciplineManager
//
//  Created by fujl-mac on 2017/6/7.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DMUserManager;

/**
 程序管理器，逻辑代码应当放入管理器中
 MVC
 
 管理器代码创建步骤：
 1、新建类，继承BaseManager
 2、重载init方法或者allManagerCreated方法完成管理器初始化工作
 3、在"UIApplication+Manager"分类的registerManager方法中注册管理器
 4、其他地方使用getManager获取Manager实例
 
 
 管理器生命周期执行顺序方法如下
 1、管理器被创建,执行init
 2、所有的管理器被创建:allManagerCreated
 3、接着，window被创建, 执行windowCreated
 4、以上三个方法执行完成后，程序加载完成，跑起来了
 
 程序进入后台，执行applicationdidEnterBackground
 程序进入前台，执行applicationWillEnterForeground
 */

@interface DMBaseManager : NSObject

/**
 所有的管理器初始化完成后执行
 用于子类重载
 
 注意:
 1、本方法执行，表示所有的管理器都被创建成功，可通过getManager方法获取在之后被添加的管理器
 2、init方法不能调用之后注册的方法，否则getManager返回nil
 */
- (void)allManagerCreated;

/**
 程序窗口创建成功后执行
 用于子类重载
 */
- (void)windowCreated;

/**
 程序进入后台
 用于子类重载
 */
- (void)applicationDidEnterBackground;

/**
 程序进入前台
 用于子类重载
 */
- (void)applicationWillEnterForeground;

/**
 获取管理器
 */
- (__kindof DMBaseManager *)getManager:(Class)cls;

/**
 获取用户管理器
 */
- (DMUserManager *)getUserManager;

@end
