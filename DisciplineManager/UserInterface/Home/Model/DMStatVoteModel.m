//
//  DMStatVoteModel.m
//  DisciplineManager
//
//  Created by apple on 2017/10/10.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMStatVoteModel.h"

@implementation DMStatVoteModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
//        self.total = [parseNumberFromObject([dict objectForKey:@"total"]) integerValue];
        self.total = 50;
        self.dishesName = parseStringFromObject([dict objectForKey:@"dishesName"]);
        self.type = [parseNumberFromObject([dict objectForKey:@"type"]) integerValue];
    }
    return self;
}

@end
