//
//  DMOrgModel.m
//  DisciplineManager
//
//  Created by fujl-mac on 2017/7/27.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMOrgModel.h"

@implementation DMOrgModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        // "id":"001001",
        self.orgId = parseStringFromObject([dict objectForKey:@"id"]);
        // "createDate":"2015-02-08 17:54:55",
        self.createDate = parseStringFromObject([dict objectForKey:@"createDate"]);
        // "operatorDate":"2017-04-25 17:08:34",
        self.operatorDate = parseStringFromObject([dict objectForKey:@"operatorDate"]);
        // "operatorId":"b6256756-fc43-4a14-a8aa-89aaafdb9b26",
        self.operatorId = parseStringFromObject([dict objectForKey:@"operatorId"]);
        // "operatorName":"系统管理员",
        self.operatorName = parseStringFromObject([dict objectForKey:@"operatorName"]);
        // "delSign":1,
        self.delSign = [parseNumberFromObject([dict objectForKey:@"delSign"]) integerValue];
        // "optLock":1,
        self.optLock = [parseNumberFromObject([dict objectForKey:@"optLock"]) integerValue];
        // "code":"001001",
        self.code = parseStringFromObject([dict objectForKey:@"code"]);
        // "name":"信息中心",
        self.name = parseStringFromObject([dict objectForKey:@"name"]);
        // "description":"",
        self.descriptions = parseStringFromObject([dict objectForKey:@"description"]);
        // "parentId":"001",
        self.parentId = parseStringFromObject([dict objectForKey:@"parentId"]);
        // "type":0,
        self.type = [parseNumberFromObject([dict objectForKey:@"type"]) integerValue];
        // "isLeaf":0,
        self.isLeaf = [parseNumberFromObject([dict objectForKey:@"isLeaf"]) boolValue];
        // "isParent":false,
        self.isParent = [parseNumberFromObject([dict objectForKey:@"isParent"]) boolValue];
    }
    return self;
}
@end
