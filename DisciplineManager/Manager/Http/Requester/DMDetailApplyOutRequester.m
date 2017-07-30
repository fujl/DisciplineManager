//
//  DMDetailApplyOutRequester.m
//  DisciplineManager
//
//  Created by fujl-mac on 2017/6/30.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMDetailApplyOutRequester.h"
#import "DMApplyOutListInfo.h"

@interface DMDetailApplyOutRequester () <DMRequesterDelegate>

@end

@implementation DMDetailApplyOutRequester

- (instancetype)init {
    self = [super init];
    if (self) {
        self.delegate = self;
    }
    return self;
}

#pragma mark - HlwyyRequesterDelegate
- (id)onDumpData:(NSDictionary *)jsonObject {
    NSDictionary *errData = [jsonObject objectForKey:@"errData"];
    DMApplyOutListInfo *aoInfo = [[DMApplyOutListInfo alloc] initWithDict:errData];
    return aoInfo;
}

- (id)onDumpErrorData:(NSDictionary *)jsonObject {
    return [jsonObject objectForKey:@"errMsg"];
}

- (NSString *)getChildrenUrl {
    return @"xysgsj/jgxt/api/goOut/get.do";
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
    params[@"id"] = self.aoId;
}

- (BOOL)onPostJson {
    return YES;
}

@end
