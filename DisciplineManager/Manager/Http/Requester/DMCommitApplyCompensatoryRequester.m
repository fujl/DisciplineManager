//
//  DMCommitApplyCompensatoryRequester.m
//  DisciplineManager
//
//  Created by fujl-mac on 2017/7/6.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMCommitApplyCompensatoryRequester.h"

@interface DMCommitApplyCompensatoryRequester () <DMRequesterDelegate>

@end

@implementation DMCommitApplyCompensatoryRequester

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
    return @"xysgsj/jgxt/api/cta/submit.do";
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
    params[@"startTime"] = self.startTime;
    params[@"endTime"] = self.endTime;
    params[@"reason"] = self.reason;
}

- (BOOL)onPostJson {
    return YES;
}

@end
