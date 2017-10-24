//
//  DMApplyLeaveListInfo.m
//  DisciplineManager
//
//  Created by fujl-mac on 2017/7/6.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMApplyLeaveListInfo.h"

@implementation DMApplyLeaveListInfo

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super initWithDict:dict];
    if (self) {
        self.type = [parseNumberFromObject([dict objectForKey:@"type"]) integerValue];
        self.startTimeType = [parseNumberFromObject([dict objectForKey:@"startTimeType"]) integerValue];
        self.endTimeType = [parseNumberFromObject([dict objectForKey:@"endTimeType"]) integerValue];
        self.holiday = parseStringFromObject([dict objectForKey:@"holiday"]);
        self.days = [parseNumberFromObject([dict objectForKey:@"days"]) floatValue];
        self.ticket = parseStringFromObject([dict objectForKey:@"ticket"]);
        self.attrs = [[NSMutableArray alloc] init];
        NSArray *attrArray = parseArrayFromObject([dict objectForKey:@"attrs"]);
        for (NSDictionary *dic in attrArray) {
            DMAttrModel *mdl = [[DMAttrModel alloc] initWithDict:dic];
            [self.attrs addObject:mdl];
        }
    }
    return self;
}

@end
