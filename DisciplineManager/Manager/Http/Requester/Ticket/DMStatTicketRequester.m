//
//  DMStatTicketRequester.m
//  DisciplineManager
//
//  Created by fujl-mac on 2017/10/24.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMStatTicketRequester.h"
#import "DMTicketStatModel.h"

@interface DMStatTicketRequester () <DMRequesterDelegate>

@end

@implementation DMStatTicketRequester

- (instancetype)init {
    self = [super init];
    if (self) {
        self.delegate = self;
    }
    return self;
}

#pragma mark - DMRequesterDelegate
- (id)onDumpData:(NSDictionary *)jsonObject {
    DMListBaseModel *listModel = [[DMListBaseModel alloc] init];
    NSDictionary *errData = [jsonObject objectForKey:@"errData"];
    NSArray *rows = [errData objectForKey:@"rows"];
    listModel.rows = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in rows) {
        DMTicketStatModel *tsInfo = [[DMTicketStatModel alloc] initWithDict:dict];
        [listModel.rows addObject:tsInfo];
    }
    listModel.total = [[errData objectForKey:@"total"] integerValue];
    return listModel;
}

- (id)onDumpErrorData:(NSDictionary *)jsonObject {
    return [jsonObject objectForKey:@"errMsg"];
}

- (NSString *)getChildrenUrl {
    return @"jgxt/api/let/statTicket.do";
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
