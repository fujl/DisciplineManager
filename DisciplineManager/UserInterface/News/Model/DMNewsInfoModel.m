//
//  DMNewsInfoModel.m
//  DisciplineManager
//
//  Created by fujl-mac on 2017/7/22.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMNewsInfoModel.h"

@implementation DMNewsInfoModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.url = [dict objectForKey:@"url"];
        self.title = [dict objectForKey:@"title"];
        self.content = [dict objectForKey:@"content"];
        self.read = [[dict objectForKey:@"read"] integerValue];
        self.createDate = [[dict objectForKey:@"create_date"] doubleValue];
    }
    return self;
}

@end
