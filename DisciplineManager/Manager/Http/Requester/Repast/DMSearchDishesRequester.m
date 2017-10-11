//
//  DMSearchDishesRequester.m
//  DisciplineManager
//
//  Created by apple on 2017/10/10.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMSearchDishesRequester.h"
#import "DMDishModel.h"

@interface DMSearchDishesRequester () <DMRequesterDelegate>

@end

@implementation DMSearchDishesRequester

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
        DMDishModel *dishInfo = [[DMDishModel alloc] initWithDict:dict];
        [listModel.rows addObject:dishInfo];
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
    return @"jgxt/api/repast/dishes/search.do";
}

/**
 *  放入请求的基本参数
 *
 *  @param params 参数容器，注意：里面已经放入基本的请求参数
 */
- (void)onPutParams:(NSMutableDictionary *)params {
    [params removeAllObjects];
    DMUserManager *manager = getManager([DMUserManager class]);
    params[@"orgCode"] = manager.loginInfo.orgCode;
}

- (BOOL)onPostJson {
    return YES;
}

@end
