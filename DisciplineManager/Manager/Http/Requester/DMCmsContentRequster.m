//
//  DMCmsContentRequster.m
//  DisciplineManager
//
//  Created by apple on 2017/8/10.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMCmsContentRequster.h"
#import "DMCmsContentModel.h"

@interface DMCmsContentRequster () <DMRequesterDelegate>

@end

@implementation DMCmsContentRequster

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
        DMCmsContentModel *aoInfo = [[DMCmsContentModel alloc] initWithDict:dict];
        [listModel.rows addObject:aoInfo];
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
    return @"api/cms/content/search.do";
}

/**
 *  放入请求的基本参数
 *
 *  @param params 参数容器，注意：里面已经放入基本的请求参数
 */
- (void)onPutParams:(NSMutableDictionary *)params {
    //params[@"recommend"] = @(1); //  是否推荐 默认 -1 全部 0 否 1 是 健康伴侣 传递 1
    params[@"channelId"] = @"8"; // 栏目ID 健康伴侣 传递 2, 国税APP 传递8
//    params[@"offset"] = @(self.offset);
//    params[@"limit"] = @(self.limit);
}

- (BOOL)onPostJson {
    return NO;
}

@end
