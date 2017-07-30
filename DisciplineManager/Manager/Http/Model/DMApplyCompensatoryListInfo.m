//
//  DMApplyCompensatoryListInfo.m
//  DisciplineManager
//
//  Created by fujl-mac on 2017/7/6.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMApplyCompensatoryListInfo.h"

@implementation DMApplyCompensatoryListInfo

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super initWithDict:dict];
    if (self) {
        self.totalTime = parseStringFromObject([dict objectForKey:@"totalTime"]);
    }
    return self;
}

@end
