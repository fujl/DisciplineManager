//
//  UIColor+Define.m
//  DisciplineManager
//
//  Created by fujl on 2017/6/7.
//  Copyright © 2017年 fujl. All rights reserved.
//

@implementation UIColor (DMDefine)

+ (UIColor *)colorWithRGB:(NSUInteger)rgbValue {
    return [UIColor colorWithARGB:(0xFF000000 | rgbValue)];
}

+ (UIColor *)colorWithARGB:(NSUInteger)rgbValue {
    return [UIColor colorWithRed:(((rgbValue & 0xFF0000) >> 16)) / 255.0 green:(((rgbValue & 0xFF00)
            >> 8)) / 255.0  blue:((rgbValue & 0xFF)) / 255.0 alpha:((rgbValue & 0xFF000000) >> 24) / 255.0];
}

+ (UIColor *)colorWithRGB:(NSUInteger)rgbValue alpha:(CGFloat)alpha {
    return [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:alpha];
}

+ (UIColor *)colorWithGrayColor:(NSUInteger)value {
    CGFloat colorValue = ((float) (value & 0xFF)) / 255.0;
    return [UIColor colorWithRed:colorValue green:colorValue blue:colorValue alpha:1.0];
}

+ (UIColor *)appBackground {
    return [UIColor colorWithRGB:0xF2F2F2];
}
+ (UIColor *)colorWithHexString:(NSString *)hexString{
    
    hexString = [[hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    UIColor *defaultColor = [UIColor clearColor];
    
    if (hexString.length < 6) return defaultColor;
    if ([hexString hasPrefix:@"#"]) hexString = [hexString substringFromIndex:1];
    if ([hexString hasPrefix:@"0X"]) hexString = [hexString substringFromIndex:2];
    if (hexString.length != 6) return defaultColor;
    
    //method1
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    unsigned int hexNumber;
    if (![scanner scanHexInt:&hexNumber]) return defaultColor;
    
    //method2
    const char *char_str = [hexString cStringUsingEncoding:NSASCIIStringEncoding];
    int hexNum;
    sscanf(char_str, "%x", &hexNum);
    
    return [UIColor colorWithRGB:(NSInteger)hexNum];
}

@end
