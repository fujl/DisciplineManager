//
//  DMDJson.h
//  DisciplineManager
//
//  Created by fujl on 2017/6/13.
//  Copyright © 2017年 fujl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMJson : NSObject

/** 将json对象转换为json字符串 */
+ (NSString *)getJsonStringFromObject:(id)obj;

+ (id)getJsonObjectFormData:(NSData *)data;

/** 将json字符串转换为json对象 */
+ (id)getJsonObjectFormString:(NSString *)jsonStr;

@end
