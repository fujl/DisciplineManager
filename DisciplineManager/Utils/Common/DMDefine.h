//
//  DMDefine.h
//  DisciplineManager
//
//  Created by fujl-mac on 2017/6/9.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#ifndef DMDefine_h
#define DMDefine_h
#import "MBProgressHUD.h"

#define IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

// UI线程断言
#define NSAssertMainThread NSAssert([NSThread currentThread] == [NSThread mainThread], @"请在UI线程调用方法！")

// 获取程序Manager
#define getManager(arg) [[UIApplication sharedApplication] getManager:[arg class]]

#define AppWindow [UIApplication sharedApplication].delegate.window
#define AppRootViewController AppWindow.rootViewController

//定义屏幕获取屏幕宽高
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

#pragma mark - font
#define kMainFont           [UIFont systemFontOfSize:14]
#define kCommitFont           [UIFont systemFontOfSize:16]

#pragma mark - color
#define kCommitBtnColor     [UIColor colorWithRGB:0x449d44]

#define  kPageSize  10      // 每页数据

#define IPHONE5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

typedef NS_ENUM(NSInteger, DMActivitiState) {
    ACTIVITI_STATE_SAVE                 = 0,                // 审批状态, 保存 未启动流程
    ACTIVITI_STATE_PENDING              = 1,                // 审批状态, 审核中
    ACTIVITI_STATE_COMPLETE             = 2,                // 审批状态, 审批完成 通过
    ACTIVITI_STATE_REJECTED             = 9,               // 审批状态, 审批完成 驳回
};

// 请休假类别 0 请假, 1 休假
typedef NS_ENUM(NSInteger, DMLeaveType) {
    LeaveTypeNone                       = -1,
    LeaveTypeDefault                    = 0,                // 请假
    LeaveTypeVacation                   = 1,                // 休假
};

/**
 * 时间类别, 0 上午, 1 下午
 */
typedef NS_ENUM(NSInteger, DMDateType) {
    DMDateTypeNone = -1,         // 未知
    DMDateTypeMorning,          // 上午
    DMDateTypeAfternoon,        // 下午
};

#endif /* DMDefine_h */
