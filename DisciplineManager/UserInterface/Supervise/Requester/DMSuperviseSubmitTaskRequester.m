//
//  DMSuperviseSubmitTaskRequester.m
//  DisciplineManager
//
//  Created by apple on 2017/10/18.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMSuperviseSubmitTaskRequester.h"

@interface DMSuperviseSubmitTaskRequester () <DMRequesterDelegate>

@end

@implementation DMSuperviseSubmitTaskRequester

- (instancetype)init {
    self = [super init];
    if (self) {
        self.delegate = self;
    }
    return self;
}

#pragma mark - HlwyyRequesterDelegate
- (id)onDumpData:(NSDictionary *)jsonObject {
    return jsonObject;
}

- (id)onDumpErrorData:(NSDictionary *)jsonObject {
    return [jsonObject objectForKey:@"errMsg"];
}

- (NSString *)getChildrenUrl {
    return @"jgxt/api/supervise/submitTask.do";
}

/**
 *  放入请求的基本参数
 *
 *  @param params 参数容器，注意：里面已经放入基本的请求参数
 */
- (void)onPutParams:(NSMutableDictionary *)params {
    NSString *userId = [params objectForKey:@"userId"];
    [params removeAllObjects];
    params[@"userId"] = userId;
    params[@"id"] = self.businessId;
    params[@"taskId"] = self.taskId;
    params[@"message"] = self.message;
    params[@"state"] = @(self.state);
    if (self.assistsId) {
        params[@"assistsId"] = self.assistsId;
    }
    if (self.agentId) {
        params[@"agentId"] = self.agentId;
    }
}

- (BOOL)onPostJson {
    return YES;
}

@end
