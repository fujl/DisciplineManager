//
//  DMAssistInfo.m
//  DisciplineManager
//
//  Created by apple on 2017/10/19.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMAssistInfo.h"

@implementation DMAssistInfo

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.assistId = parseStringFromObject([dict objectForKey:@"id"]);
        self.userId = parseStringFromObject([dict objectForKey:@"userId"]);
        self.name = parseStringFromObject([dict objectForKey:@"name"]);
        self.optLock = [parseNumberFromObject([dict objectForKey:@"optLock"]) integerValue];
    }
    return self;
}

@end
