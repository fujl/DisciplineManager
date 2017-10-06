//
//  DMLeaveTicketModel.m
//  DisciplineManager
//
//  Created by fujl-mac on 2017/7/22.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMLeaveTicketModel.h"

@implementation DMLeaveTicketModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.ltId = [dict objectForKey:@"id"];
        self.createDate = [dict objectForKey:@"createDate"];
        self.title = [dict objectForKey:@"title"];
        self.expiryDate = [dict objectForKey:@"expiryDate"];
        self.name = [dict objectForKey:@"name"];
        
        self.days = [[dict objectForKey:@"days"] floatValue];
        self.state = [[dict objectForKey:@"state"] integerValue];
        self.sfgq = [[dict objectForKey:@"sfgq"] integerValue];
        self.type = [[dict objectForKey:@"type"] integerValue];
        self.selected = NO;
    }
    return self;
}
@end
