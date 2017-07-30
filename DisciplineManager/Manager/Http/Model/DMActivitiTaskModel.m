//
//  DMActivitiTaskModel.m
//  DisciplineManager
//
//  Created by fujl-mac on 2017/7/25.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMActivitiTaskModel.h"

@implementation DMActivitiTaskModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.atId = parseStringFromObject([dict objectForKey:@"id"]);
        self.createDate = parseStringFromObject([dict objectForKey:@"createDate"]);
        self.name = parseStringFromObject([dict objectForKey:@"name"]);
        self.businessId = parseStringFromObject([dict objectForKey:@"businessId"]);
        self.formKey = parseStringFromObject([dict objectForKey:@"formKey"]);
        self.definitionKey = parseStringFromObject([dict objectForKey:@"definitionKey"]);
        self.user = [[DMUserModel alloc] initWithDict:[dict objectForKey:@"user"]];
    }
    return self;
}


@end
