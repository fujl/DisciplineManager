//
//  DMDishModel.m
//  DisciplineManager
//
//  Created by fujl-mac on 2017/10/11.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMDishModel.h"

@implementation DMDishModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.dishesId = parseStringFromObject([dict objectForKey:@"id"]);
        self.createDate = parseStringFromObject([dict objectForKey:@"createDate"]);
        self.operatorDate = parseStringFromObject([dict objectForKey:@"operatorDate"]);
        self.operatorId = parseStringFromObject([dict objectForKey:@"operatorId"]);
        self.operatorName = parseStringFromObject([dict objectForKey:@"operatorName"]);
        self.delSign = [parseNumberFromObject([dict objectForKey:@"delSign"]) integerValue];
        self.optLock = [parseNumberFromObject([dict objectForKey:@"optLock"]) integerValue];
        
        self.dishesName = parseStringFromObject([dict objectForKey:@"dishesName"]);
        self.type = [parseNumberFromObject([dict objectForKey:@"type"]) integerValue];
        self.week = [parseNumberFromObject([dict objectForKey:@"week"]) integerValue];
        self.imgPath = parseStringFromObject([dict objectForKey:@"imgPath"]);
        self.searchTime = parseStringFromObject([dict objectForKey:@"searchTime"]);
    }
    return self;
}

@end
