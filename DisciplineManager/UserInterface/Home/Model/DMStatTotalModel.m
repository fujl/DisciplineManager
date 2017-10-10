//
//  DMStatTotalModel.m
//  DisciplineManager
//
//  Created by apple on 2017/10/10.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMStatTotalModel.h"

@implementation DMStatTotalModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.needBreakfast = [parseNumberFromObject([dict objectForKey:@"needBreakfast"]) integerValue];
        self.needLunch = [parseNumberFromObject([dict objectForKey:@"needLunch"]) integerValue];
        self.isSign = [parseNumberFromObject([dict objectForKey:@"isSign"]) boolValue];
    }
    return self;
}

@end
