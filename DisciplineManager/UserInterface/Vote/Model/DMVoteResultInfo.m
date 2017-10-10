//
//  DMVoteResultInfo.m
//  DisciplineManager
//
//  Created by apple on 2017/10/9.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMVoteResultInfo.h"

@implementation DMVoteResultInfo

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.resultId = parseStringFromObject([dict objectForKey:@"id"]);
        self.userId = parseStringFromObject([dict objectForKey:@"userId"]);
        self.voteId = parseStringFromObject([dict objectForKey:@"voteId"]);
        self.optionId = parseStringFromObject([dict objectForKey:@"optionId"]);
        self.optLock = [parseNumberFromObject([dict objectForKey:@"optLock"]) integerValue];
    }
    return self;
}

@end
