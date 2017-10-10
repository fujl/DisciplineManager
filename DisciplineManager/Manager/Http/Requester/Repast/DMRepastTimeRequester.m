//
//  DMRepastTimeRequester.m
//  DisciplineManager
//
//  Created by apple on 2017/10/10.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMRepastTimeRequester.h"
#import "DMRepastTimeModel.h"

@interface DMRepastTimeRequester () <DMRequesterDelegate>

@end

@implementation DMRepastTimeRequester

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
    DMRepastTimeModel *repastTimeModel = [[DMRepastTimeModel alloc] initWithDict:errData];
    return repastTimeModel;
}

- (id)onDumpErrorData:(NSDictionary *)jsonObject {
    return [jsonObject objectForKey:@"errMsg"];
}

- (NSString *)getChildrenUrl {
    return @"jgxt/api/repast/time.do";
}

/**
 *  放入请求的基本参数
 *
 *  @param params 参数容器，注意：里面已经放入基本的请求参数
 */
- (void)onPutParams:(NSMutableDictionary *)params {
    //NSString *userId = [params objectForKey:@"userId"];
    [params removeAllObjects];
}

- (BOOL)onPostJson {
    return YES;
}

@end
