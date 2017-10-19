//
//  DMSuperviseSubmitRequester.m
//  DisciplineManager
//
//  Created by apple on 2017/10/18.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMSuperviseSubmitRequester.h"

@interface DMSuperviseSubmitRequester () <DMRequesterDelegate>

@end

@implementation DMSuperviseSubmitRequester

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
    return @"jgxt/api/supervise/submit.do";
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
    params[@"endTime"] = self.endTime;
    params[@"transactorId"] = self.transactorId;
    params[@"transactorName"] = self.transactorName;
    
    if (self.assistsId) {
        params[@"assistsId"] = self.assistsId;
    }
    
    params[@"reason"] = self.reason;
}

- (BOOL)onPostJson {
    return YES;
}

@end
