//
//  DMCmsContentModel.m
//  DisciplineManager
//
//  Created by apple on 2017/8/10.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMCmsContentModel.h"

@implementation DMCmsContentModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.ccId = [[dict objectForKey:@"id"] integerValue];
        self.createTime = [dict objectForKey:@"createTime"];
        self.title = [dict objectForKey:@"title"];
        self.shortTitle = [dict objectForKey:@"shortTitle"];
        self.txt = parseStringFromObject([dict objectForKey:@"txt"]);
        self.imgPath = [dict objectForKey:@"imgPath"];
    }
    return self;
}
@end
