//
//  DMExhMostRequester.m
//  DisciplineManager
//
//  Created by apple on 2017/10/14.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMExhMostRequester.h"
#import "DMExhMostModel.h"

@interface DMExhMostRequester () <DMRequesterDelegate>

@end

@implementation DMExhMostRequester

- (instancetype)init {
    self = [super init];
    if (self) {
        self.delegate = self;
    }
    return self;
}

#pragma mark - HlwyyRequesterDelegate
- (id)onDumpData:(NSDictionary *)jsonObject {
    NSDictionary *errData = parseDictionaryFromObject([jsonObject objectForKey:@"errData"]);
    DMExhMostModel *exhMostModel = [[DMExhMostModel alloc] initWithDict:errData];
    return exhMostModel;
}

- (id)onDumpErrorData:(NSDictionary *)jsonObject {
    return [jsonObject objectForKey:@"errMsg"];
}

- (NSString *)getChildrenUrl {
    return @"jgxt/api/exh/most.do";
}

/**
 *  放入请求的基本参数
 *
 *  @param params 参数容器，注意：里面已经放入基本的请求参数
 */
- (void)onPutParams:(NSMutableDictionary *)params {
    //NSString *userId = [params objectForKey:@"userId"];
    [params removeAllObjects];
    //params[@"userId"] = userId;
}

- (BOOL)onPostJson {
    return YES;
}

@end
