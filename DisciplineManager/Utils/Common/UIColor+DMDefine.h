//
//  UIColor+Define.h
//  DisciplineManager
//
//  Created by fujl on 2017/6/7.
//  Copyright © 2017年 fujl. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 程序颜色定义
 */
@interface UIColor (DMDefine)

// 绿色：[UIColor colorWithRGB:0x00FF00]
// 红色：[UIColor colorWithRGB:0xFF0000]
// 蓝色：[UIColor colorWithRGB:0x0000FF]
+ (UIColor *)colorWithRGB:(NSUInteger)rgbValue;

+ (UIColor *)colorWithARGB:(NSUInteger)rgbValue;

+ (UIColor *)colorWithGrayColor:(NSUInteger)value;

+ (UIColor *)colorWithRGB:(NSUInteger)rgbValue alpha:(CGFloat)alpha;
+ (UIColor *)colorWithHexString:(NSString *)hexString;
/**
 程序背景色
 */
+ (UIColor *)appBackground;

@end
