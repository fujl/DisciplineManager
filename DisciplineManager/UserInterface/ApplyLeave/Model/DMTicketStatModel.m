//
//  DMTicketStatModel.m
//  DisciplineManager
//
//  Created by fujl-mac on 2017/10/24.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMTicketStatModel.h"

@implementation DMTicketStatModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.total = [parseNumberFromObject([dict objectForKey:@"total"]) integerValue];
        self.ticketType = [parseNumberFromObject([dict objectForKey:@"ticketType"]) integerValue];
    }
    return self;
}

@end
