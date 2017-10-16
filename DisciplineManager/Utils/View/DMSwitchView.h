//
//  DMSwitchView.h
//  DisciplineManager
//
//  Created by fujl-mac on 2017/10/16.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMSwitchView : UIView

// 完成被点击的属性
@property(nonatomic, copy) void (^onSwitchChangeBlock)(BOOL isOn);

- (void)hiddenBottomLine:(BOOL)hidden;
- (void)setTitle:(NSString *)title;
- (void)setIsOn:(BOOL)isOn;

@end
