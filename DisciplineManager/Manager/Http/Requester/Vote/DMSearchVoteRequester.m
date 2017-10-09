//
//  DMSearchVoteRequester.m
//  DisciplineManager
//
//  Created by fujl-mac on 2017/10/9.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMSearchVoteRequester.h"
#import "DMVoteListInfo.h"

@interface DMSearchVoteRequester () <DMRequesterDelegate>

@end

@implementation DMSearchVoteRequester

- (instancetype)init {
    self = [super init];
    if (self) {
        self.delegate = self;
    }
    return self;
}

#pragma mark - HlwyyRequesterDelegate
- (id)onDumpData:(NSDictionary *)jsonObject {
    DMListBaseModel *listModel = [[DMListBaseModel alloc] init];
    NSDictionary *errData = [jsonObject objectForKey:@"errData"];
    NSArray *rows = [errData objectForKey:@"rows"];
    listModel.rows = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in rows) {
        DMVoteListInfo *vlInfo = [[DMVoteListInfo alloc] initWithDict:dict];
        [listModel.rows addObject:vlInfo];
    }
    listModel.total = [[errData objectForKey:@"total"] integerValue];
    listModel.totalPage = [[errData objectForKey:@"totalPage"] integerValue];
    listModel.pageSize = [[errData objectForKey:@"pageSize"] integerValue];
    return listModel;
}

- (id)onDumpErrorData:(NSDictionary *)jsonObject {
    return [jsonObject objectForKey:@"errMsg"];
}

- (NSString *)getChildrenUrl {
    return @"jgxt/api/vote/search.do";
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
    params[@"offset"] = @(self.offset);
    params[@"limit"] = @(self.limit);
    DMUserManager *manager = getManager([DMUserManager class]);
    params[@"orgCode"] = manager.loginInfo.orgCode;
}

- (BOOL)onPostJson {
    return YES;
}

@end
