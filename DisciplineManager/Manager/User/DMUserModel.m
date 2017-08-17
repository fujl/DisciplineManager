//
//  DMUserModel.m
//  DisciplineManager
//
//  Created by fujl-mac on 2017/7/25.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMUserModel.h"

@implementation DMUserModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        if (![dict isEqual:[NSNull null]]) {
            self.userId = parseStringFromObject([dict objectForKey:@"id"]);
            // "id":"F55B27AD03034815A854B85EA53FC403",
            self.createDate = parseStringFromObject([dict objectForKey:@"createDate"]);
            // "createDate":"2017-07-06 15:19:24",
            self.operatorDate = parseStringFromObject([dict objectForKey:@"operatorDate"]);
            // "operatorDate":"2017-07-24 20:31:35",
            self.operatorId = parseStringFromObject([dict objectForKey:@"operatorId"]);
            // "operatorId":"F55B27AD03034815A854B85EA53FC403",
            self.operatorName = parseStringFromObject([dict objectForKey:@"operatorName"]);
            // "operatorName":"IOS测试",
            self.delSign = [parseNumberFromObject([dict objectForKey:@"delSign"]) integerValue];
            // "delSign":1,
            self.optLock = [parseNumberFromObject([dict objectForKey:@"optLock"]) integerValue];
            // "optLock":5,
            self.loginId = parseStringFromObject([dict objectForKey:@"loginId"]);
            // "loginId":"ios001",
            self.enabled = [parseNumberFromObject([dict objectForKey:@"enabled"]) integerValue];
            // "enabled":1,
            self.unLockedTime = parseStringFromObject([dict objectForKey:@"unLockedTime"]);
            // "unLockedTime":"1970-02-01 00:00:01",
            self.expiryDate = parseStringFromObject([dict objectForKey:@"expiryDate"]);
            // "expiryDate":"2017-08-31 00:00:00",
            self.userInfo = [[DMUserInfo alloc] initWithDict:[dict objectForKey:@"userInfo"]];
            self.orgInfo = [[DMOrgModel alloc] initWithDict:[dict objectForKey:@"org"]];
        }
    }
    return self;
}
@end
