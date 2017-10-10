//
//  DMVoteOptionInfo.m
//  DisciplineManager
//
//  Created by apple on 2017/10/9.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMVoteOptionInfo.h"

@implementation DMVoteOptionInfo

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.optionId = parseStringFromObject([dict objectForKey:@"id"]);
        self.text = parseStringFromObject([dict objectForKey:@"text"]);
        self.number = [parseNumberFromObject([dict objectForKey:@"number"]) integerValue];
        self.optLock = [parseNumberFromObject([dict objectForKey:@"optLock"]) integerValue];
        
        self.results = [[NSMutableArray alloc] init];
        NSArray *resultArray = parseArrayFromObject([dict objectForKey:@"result"]);
        for (NSDictionary *dic in resultArray) {
            DMVoteResultInfo *resultInfo = [[DMVoteResultInfo alloc] initWithDict:dic];
            [self.results addObject:resultInfo];
        }
        
        self.total = [parseNumberFromObject([dict objectForKey:@"total"]) integerValue];
    }
    return self;
}

@end
