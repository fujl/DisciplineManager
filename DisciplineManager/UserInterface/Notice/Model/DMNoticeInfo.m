//
//  DMNoticeInfo.m
//  DisciplineManager
//
//  Created by fujl-mac on 2017/10/15.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMNoticeInfo.h"

@implementation DMNoticeInfo

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.noticeId = parseStringFromObject([dict objectForKey:@"id"]);
        self.title = parseStringFromObject([dict objectForKey:@"title"]);
        self.content = parseStringFromObject([dict objectForKey:@"content"]);
        self.user = [[DMUserModel alloc] initWithDict:[dict objectForKey:@"user"]];
        self.createDate = parseStringFromObject([dict objectForKey:@"createDate"]);
        self.optLock = parseStringFromObject([dict objectForKey:@"optLock"]);
        self.userId = parseStringFromObject([dict objectForKey:@"userId"]);
    }
    return self;
}

@end
