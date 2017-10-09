//
//  DMVoteListInfo.m
//  DisciplineManager
//
//  Created by fujl-mac on 2017/10/9.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMVoteListInfo.h"

@implementation DMVoteListInfo

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.vlId = parseStringFromObject([dict objectForKey:@"id"]);
        self.createDate = parseStringFromObject([dict objectForKey:@"createDate"]);//":"2017-10-06 21:05:21",
        self.operatorDate = parseStringFromObject([dict objectForKey:@"operatorDate"]);//":"2017-10-07 01:06:52",
        self.operatorId = parseStringFromObject([dict objectForKey:@"operatorId"]);//":"F55B27AD03034815A854B85EA53FC403",
        self.operatorName = parseStringFromObject([dict objectForKey:@"operatorName"]);//":"APP测试",
        self.delSign = [parseNumberFromObject([dict objectForKey:@"delSign"]) integerValue];//":0,
        self.optLock = parseStringFromObject([dict objectForKey:@"optLock"]);//":null,
        self.title = parseStringFromObject([dict objectForKey:@"title"]);//":"s j j s k d k x 显瘦圆领",
        self.user = parseStringFromObject([dict objectForKey:@"user"]);//":null,
        self.orgCode = parseStringFromObject([dict objectForKey:@"orgCode"]);//":null,
        self.type = [parseNumberFromObject([dict objectForKey:@"type"]) integerValue];//":1,
        self.endTime = parseStringFromObject([dict objectForKey:@"endTime"]);//":"2017-10-06 21:16"
        
        self.userId = parseStringFromObject([dict objectForKey:@"userId"]);//":"F55B27AD03034815A854B85EA53FC403",
        self.offset = [parseNumberFromObject([dict objectForKey:@"offset"]) integerValue];//":0,
        self.limit = [parseNumberFromObject([dict objectForKey:@"limit"]) integerValue];//":0,
        self.total = [parseNumberFromObject([dict objectForKey:@"total"]) integerValue];//":2,
        self.name = parseStringFromObject([dict objectForKey:@"name"]);//":"APP测试",
        self.face = parseStringFromObject([dict objectForKey:@"face"]);//":"/upload/face/images/201710091101233150.jpg",
        self.isEnd = [parseNumberFromObject([dict objectForKey:@"isEnd"]) boolValue];//":true,
        self.myTicket = [parseNumberFromObject([dict objectForKey:@"myTicket"]) integerValue];//":0, 判断是否已经投票, 大于0 已经投票
        self.timeTxt = parseStringFromObject([dict objectForKey:@"timeTxt"]);//":"2天前"
    }
    return self;
}

@end
