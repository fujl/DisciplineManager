//
//  DMMainItemView.h
//  DisciplineManager
//
//  Created by fujl-mac on 2017/6/15.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kMainItemTodo               1000    // 待办任务
#define kMainItemApplyOut           1001    // 外出申请
#define kMainItemApplyBus           1002    // 公车申请
#define kMainItemApplyCompensatory  1003    // 补休申请
#define kMainItemApplyLeave         1004    // 请假申请
#define kMainItemAddressBook        1005    // 通讯录
#define kMainItemMore               1006    // 更多

@interface DMMainItemView : UIButton
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat width;

- (instancetype)initWithIcon:(NSString *)icon;

- (void)setTitleViewText:(NSString *)titleText;

@end
