//
//  DMUserBookModel.m
//  DisciplineManager
//
//  Created by fujl-mac on 2017/7/28.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMUserBookModel.h"

@implementation DMUserBookModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.userId = parseStringFromObject([dict objectForKey:@"userId"]);
        self.name = parseStringFromObject([dict objectForKey:@"name"]);
        self.pinyin = parseStringFromObject([dict objectForKey:@"pinyin"]);
        self.mobile = parseStringFromObject([dict objectForKey:@"mobile"]);
        self.email = parseStringFromObject([dict objectForKey:@"email"]);
        self.province = parseStringFromObject([dict objectForKey:@"province"]);
        self.city = parseStringFromObject([dict objectForKey:@"city"]);
        self.county = parseStringFromObject([dict objectForKey:@"county"]);
        self.address = parseStringFromObject([dict objectForKey:@"address"]);
        self.lat = parseStringFromObject([dict objectForKey:@"lat"]);
        self.lng = parseStringFromObject([dict objectForKey:@"lng"]);
        self.tel = parseStringFromObject([dict objectForKey:@"tel"]);
        self.deptUserId = parseStringFromObject([dict objectForKey:@"deptUserId"]);
        self.deptUserName = parseStringFromObject([dict objectForKey:@"deptUserName"]);
        self.orgId = parseStringFromObject([dict objectForKey:@"orgId"]);
        self.orgName = parseStringFromObject([dict objectForKey:@"orgName"]);
        self.goOutState = [parseNumberFromObject([dict objectForKey:@"goOutState"]) integerValue];
        self.ocarState = [parseNumberFromObject([dict objectForKey:@"ocarState"]) integerValue];
        self.leaveState = [parseNumberFromObject([dict objectForKey:@"leaveState"]) integerValue];
        self.gender = [parseNumberFromObject([dict objectForKey:@"gender"]) integerValue];
        self.jobName = parseStringFromObject([dict objectForKey:@"jobName"]);
    }
    return self;
}

@end
