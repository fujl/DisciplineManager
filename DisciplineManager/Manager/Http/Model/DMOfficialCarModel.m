//
//  DMOfficialCarModel.m
//  DisciplineManager
//
//  Created by apple on 17/8/1.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMOfficialCarModel.h"

@implementation DMOfficialCarModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        if (![dict isEqual:[NSNull null]] && [dict isKindOfClass:[NSDictionary class]]) {
            self.ocId = parseStringFromObject([dict objectForKey:@"id"]);
            self.createDate = parseStringFromObject([dict objectForKey:@"createDate"]);
            self.operatorDate = parseStringFromObject([dict objectForKey:@"operatorDate"]);
            self.operatorId = parseStringFromObject([dict objectForKey:@"operatorId"]);
            self.operatorName = parseStringFromObject([dict objectForKey:@"operatorName"]);
            self.delSign = [parseNumberFromObject([dict objectForKey:@"delSign"]) integerValue];
            self.optLock = parseStringFromObject([dict objectForKey:@"optLock"]);
            self.number = parseStringFromObject([dict objectForKey:@"number"]);
            self.brand = parseStringFromObject([dict objectForKey:@"brand"]);
            self.color = parseStringFromObject([dict objectForKey:@"color"]);
            self.model = parseStringFromObject([dict objectForKey:@"model"]);
            self.userId = parseStringFromObject([dict objectForKey:@"userId"]);
            self.name = parseStringFromObject([dict objectForKey:@"name"]);
            
            self.state = [parseNumberFromObject([dict objectForKey:@"state"]) integerValue];
        }
        
    }
    return self;
}

@end
