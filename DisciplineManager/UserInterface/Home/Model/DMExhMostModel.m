//
//  DMExhMostModel.m
//  DisciplineManager
//
//  Created by apple on 2017/10/14.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMExhMostModel.h"

@implementation DMAttrModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.emId = parseStringFromObject([dict objectForKey:@"id"]);
        self.path = parseStringFromObject([dict objectForKey:@"path"]);
        self.number = [parseNumberFromObject([dict objectForKey:@"number"]) integerValue];
        self.optLock = [parseNumberFromObject([dict objectForKey:@"optLock"]) integerValue];
    }
    return self;
}

@end

@implementation DMExhMostModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.content = parseStringFromObject([dict objectForKey:@"content"]);
        self.attrs = [[NSMutableArray alloc] init];
        NSArray *attrs = parseArrayFromObject([dict objectForKey:@"attrs"]);
        for (NSDictionary *dic in attrs) {
            DMAttrModel *mdl = [[DMAttrModel alloc] initWithDict:dic];
            [self.attrs addObject:mdl];
        }
    }
    return self;
}

@end
