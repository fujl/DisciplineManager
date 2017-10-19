//
//  DMSuperviselistInfo.m
//  DisciplineManager
//
//  Created by apple on 2017/10/19.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMSuperviselistInfo.h"

@implementation DMSuperviselistInfo

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super initWithDict:dict];
    if (self) {
        self.transactorId = parseStringFromObject([dict objectForKey:@"transactorId"]);
        self.transactorName = parseStringFromObject([dict objectForKey:@"transactorName"]);
        NSArray *assistArray = parseArrayFromObject([dict objectForKey:@"assists"]);
        self.assists = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in assistArray) {
            DMAssistInfo *info = [[DMAssistInfo alloc] initWithDict:dic];
            [self.assists addObject:info];
        }
    }
    return self;
}

@end
