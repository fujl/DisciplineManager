//
//  DMDatePickerView.h
//  DM
//
//  Created by fujl-mac on 2017/4/6.
//  Copyright © 2017年 Micheal Jordan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DMAddressManager.h"

@interface DMDateTypeModel : NSObject
@property(nonatomic, assign) DMDateType dateType;
@property(nonatomic, strong) NSString *name;
@end

@interface DMDatePickerView : UIView

// 时间选择，设置属性
@property(nonatomic, strong) UIDatePicker *datePicker;

// 完成被点击的属性
@property(nonatomic, copy) void (^onCompleteClick)(DMDatePickerView *datePicker, NSDate *date);

// 完成被点击的属性
@property(nonatomic, copy) void (^onCompleteDtClick)(DMDatePickerView *datePicker, NSDate *date, DMDateTypeModel *dtModel);

- (instancetype)initWithDateType:(DMDateType)dateType;

- (void)setCompleteTitle:(NSString *)title;
// 显示
- (void)show;

// 隐藏
- (void)dismiss;

@end
