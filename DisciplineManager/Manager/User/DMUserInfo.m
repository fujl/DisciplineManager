//
//  DMUserInfo.m
//  DisciplineManager
//
//  Created by fujl-mac on 2017/6/29.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMUserInfo.h"

@implementation DMUserInfo

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        if (![dict isEqual:[NSNull null]]) {
            self.userId = parseStringFromObject([dict objectForKey:@"id"]);
            self.name = parseStringFromObject([dict objectForKey:@"name"]);
            self.mobile = parseStringFromObject([dict objectForKey:@"mobile"]);
            self.email = parseStringFromObject([dict objectForKey:@"email"]);
            self.province = parseStringFromObject([dict objectForKey:@"province"]);
            self.city = parseStringFromObject([dict objectForKey:@"city"]);
            
            self.county = parseStringFromObject([dict objectForKey:@"county"]);
            self.address = parseStringFromObject([dict objectForKey:@"address"]);
            self.latitude = parseStringFromObject([dict objectForKey:@"latitude"]);
            self.longitude = parseStringFromObject([dict objectForKey:@"longitude"]);
            self.tel = parseStringFromObject([dict objectForKey:@"tel"]);
            self.contacts = parseStringFromObject([dict objectForKey:@"contacts"]);
            
            self.deptUserId = parseStringFromObject([dict objectForKey:@"deptUserId"]);
            self.deptUserName = parseStringFromObject([dict objectForKey:@"deptUserName"]);
            self.baiduChannelId = parseStringFromObject([dict objectForKey:@"baiduChannelId"]);
            self.deviceType = [parseNumberFromObject([dict objectForKey:@"deviceType"]) integerValue];
            self.pinyin = parseStringFromObject([dict objectForKey:@"pinyin"]);
            self.gender = [parseNumberFromObject([dict objectForKey:@"gender"]) integerValue];
            self.optLock = [parseNumberFromObject([dict objectForKey:@"optLock"]) integerValue];
        }
    }
    return self;
}

@end
