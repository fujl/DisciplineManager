//
//  DMApplyBusListInfo.m
//  DisciplineManager
//
//  Created by fujl-mac on 2017/6/30.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMApplyBusListInfo.h"

@implementation DMApplyBusListInfo

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super initWithDict:dict];
    if (self) {
        self.address = parseStringFromObject([dict objectForKey:@"address"]);
        self.driverId = parseStringFromObject([dict objectForKey:@"driverId"]);
        self.driverName = parseStringFromObject([dict objectForKey:@"driverName"]);
        self.officialCar = parseStringFromObject([dict objectForKey:@"officialCar"]);
    }
    return self;
}

@end
