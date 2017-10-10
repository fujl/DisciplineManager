//
//  DMStatVoteRequester.m
//  DisciplineManager
//
//  Created by apple on 2017/10/10.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMStatVoteRequester.h"
#import "DMStatVoteModel.h"

@interface DMStatVoteRequester () <DMRequesterDelegate>

@end

@implementation DMStatVoteRequester

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
    NSArray *rows = parseArrayFromObject([errData objectForKey:@"rows"]);
    NSMutableArray *rowArray = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in rows) {
        DMStatVoteModel *svModel = [[DMStatVoteModel alloc] initWithDict:dic];
        [rowArray addObject:svModel];
    }
    return rowArray;
}

- (id)onDumpErrorData:(NSDictionary *)jsonObject {
    return [jsonObject objectForKey:@"errMsg"];
}

- (NSString *)getChildrenUrl {
    return @"jgxt/api/repast/stat/vote.do";
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
}

- (BOOL)onPostJson {
    return YES;
}

@end
