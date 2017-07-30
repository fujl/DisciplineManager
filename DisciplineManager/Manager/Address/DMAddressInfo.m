//
//  DMAddressInfo.m
//  DisciplineManager
//
//  Created by fujl-mac on 2017/6/19.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMAddressInfo.h"

@implementation DMAddressInfo

- (instancetype)initWithCopy:(DMAddressInfo *)copy {
    self = [super init];
    if (self) {
        self.addressId = copy.addressId;
        self.addressPid = copy.addressPid;
        self.type = copy.type;
        self.name = [[NSString alloc] initWithString:copy.name];
    }
    return self;
}
@end
