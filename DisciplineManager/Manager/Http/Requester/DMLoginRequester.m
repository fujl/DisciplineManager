//
//  DMLoginRequester.m
//  DisciplineManager
//
//  Created by fujl-mac on 2017/6/29.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMLoginRequester.h"
#import "DMUserInfo.h"

@interface DMLoginRequester () <DMRequesterDelegate>

@end

@implementation DMLoginRequester

- (instancetype)init {
    self = [super init];
    if (self) {
        self.delegate = self;
    }
    return self;
}

#pragma mark - HlwyyRequesterDelegate
/**
 {
 "errCode":2,
 "errMsg":"success",
 "errData":{
 "id":"74181AA0B33A49A4B49A9DD670C29FED",
 "accessToken":"2c38985449f8b1edd45d5452f2f209cb",
 "expiresIn":7200,
 "createTime":"2017-06-29 11:36:04",
 "optLock":1
 }
 }
 */
- (id)onDumpData:(NSDictionary *)jsonObject {
    DMLoginInfo *loginInfo = [[DMLoginInfo alloc] init];
    loginInfo.username = self.username;
    loginInfo.password = self.password;
    NSDictionary *errData = [jsonObject objectForKey:@"errData"];
    loginInfo.userId = [errData objectForKey:@"id"];
    loginInfo.accessToken = [errData objectForKey:@"accessToken"];
    loginInfo.expiresIn = [[errData objectForKey:@"expiresIn"] integerValue];
    loginInfo.loginDt = [[NSDate date] timeIntervalSince1970];
    loginInfo.createTime = [errData objectForKey:@"createTime"];
    loginInfo.optLock = [[errData objectForKey:@"optLock"] integerValue];
    NSDictionary *user = [errData objectForKey:@"user"];
    NSDictionary *org = [user objectForKey:@"org"];
    NSString *orgCode = [org objectForKey:@"code"];
    loginInfo.orgCodeOriginal = orgCode;// 保存原始值
    if (orgCode.length > 3) {
        loginInfo.orgCode = [orgCode substringWithRange:NSMakeRange(0, 3)];
    } else {
        loginInfo.orgCode = orgCode;
    }
    return loginInfo;
}

- (id)onDumpErrorData:(NSDictionary *)jsonObject {
    return [jsonObject objectForKey:@"errMsg"];
}

- (NSString *)getChildrenUrl {
    return @"api/login.do";
}

/**
 *  放入请求的基本参数
 *
 *  @param params 参数容器，注意：里面已经放入基本的请求参数
 */
- (void)onPutParams:(NSMutableDictionary *)params {
    params[@"username"] = self.username;
    params[@"password"] = self.password;
}

- (BOOL)onPostJson {
    return NO;
}
@end
