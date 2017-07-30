//
//  DMLoginInfo.m
//  DisciplineManager
//
//  Created by fujl-mac on 2017/6/29.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMLoginInfo.h"

@implementation DMLoginInfo

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        self.userId = [coder decodeObjectForKey:@"userId"];
        self.username = [coder decodeObjectForKey:@"username"];
        self.password = [coder decodeObjectForKey:@"password"];
        self.accessToken = [coder decodeObjectForKey:@"accessToken"];
        self.expiresIn = [[coder decodeObjectForKey:@"expiresIn"] integerValue];
        self.loginDt = [[coder decodeObjectForKey:@"loginDt"] doubleValue];
        self.createTime = [coder decodeObjectForKey:@"createTime"];
        self.optLock = [[coder decodeObjectForKey:@"optLock"] integerValue];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.userId forKey:@"userId"];
    [coder encodeObject:self.username forKey:@"username"];
    [coder encodeObject:self.password forKey:@"password"];
    [coder encodeObject:self.accessToken forKey:@"accessToken"];
    [coder encodeObject:@(self.expiresIn) forKey:@"expiresIn"];
    [coder encodeObject:@(self.loginDt) forKey:@"loginDt"];
    [coder encodeObject:self.createTime forKey:@"createTime"];
    [coder encodeObject:@(self.optLock) forKey:@"optLock"];
}

@end
