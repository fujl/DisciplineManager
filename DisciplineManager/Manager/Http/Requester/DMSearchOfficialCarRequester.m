//
//  DMSearchOfficialCarRequester.m
//  DisciplineManager
//
//  Created by apple on 17/8/1.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMSearchOfficialCarRequester.h"
#import "DMOfficialCarModel.h"

@interface DMSearchOfficialCarRequester () <DMRequesterDelegate>

@end

@implementation DMSearchOfficialCarRequester

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
        DMOfficialCarModel *orgInfo = [[DMOfficialCarModel alloc] initWithDict:dict];
        [listModel.rows addObject:orgInfo];
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
    return @"jgxt/api/officialCar/search.do";
}

/**
 *  放入请求的基本参数
 *
 *  @param params 参数容器，注意：里面已经放入基本的请求参数
 */
- (void)onPutParams:(NSMutableDictionary *)params {
    [params removeAllObjects];
}

- (BOOL)onPostJson {
    return NO;
}

@end
