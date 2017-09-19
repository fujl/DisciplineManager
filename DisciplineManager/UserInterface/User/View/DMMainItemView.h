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
#define kMainItemTemporaryTask      1002    // 督办任务
#define kMainItemExhibition         1003    // 工作展晒
#define kMainItemApplyLeave         1004    // 请假申请
#define kMainItemApplyCompensatory  1005    // 补休申请
#define kMainItemRepast             1006    // 就餐管理
#define kMainItemNotice               1007    // 更多

@interface DMMainItemView : UIButton
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat width;

- (instancetype)initWithIcon:(NSString *)icon;

- (void)setTitleViewText:(NSString *)titleText;

- (void)hiddenDot:(BOOL)hidden;

@end
