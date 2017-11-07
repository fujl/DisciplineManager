//
//  DMRepastTimeModel.m
//  DisciplineManager
//
//  Created by apple on 2017/10/10.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMRepastTimeModel.h"

@implementation DMRepastTimeModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.time = parseStringFromObject([dict objectForKey:@"time"]);
        self.date = parseStringFromObject([dict objectForKey:@"date"]);
        self.datetime = parseStringFromObject([dict objectForKey:@"datetime"]);
        NSString *endHour = parseStringFromObject([dict objectForKey:@"endHour"]);
        if ([endHour isEqualToString:@""]) {
            self.endHour = [parseNumberFromObject([dict objectForKey:@"endHour"]) integerValue];
        } else {
            self.endHour = 18;
        }
        self.week = [parseNumberFromObject([dict objectForKey:@"week"]) integerValue];
    }
    return self;
}

@end
