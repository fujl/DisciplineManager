//
//  NSString+DMFontWitdh.h
//  DisciplineManager
//
//  Created by fujl on 17/6/11.
//  Copyright © 2017年 fujl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (DMFontWitdh)

- (CGFloat)widthOfFont:(UIFont *)font height:(CGFloat)height;

- (CGFloat)heightOfFont:(UIFont *)font width:(CGFloat)width;

@end
