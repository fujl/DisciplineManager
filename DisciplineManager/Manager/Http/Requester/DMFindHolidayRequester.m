//
//  DMFindHolidayRequester.m
//  DisciplineManager
//
//  Created by fujl-mac on 2017/7/7.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMFindHolidayRequester.h"

@interface DMFindHolidayRequester () <DMRequesterDelegate>

@end

@implementation DMFindHolidayRequester

- (instancetype)init {
    self = [super init];
    if (self) {
        self.delegate = self;
    }
    return self;
}

#pragma mark - HlwyyRequesterDelegate
- (id)onDumpData:(NSDictionary *)jsonObject {
    NSArray *errData = [jsonObject objectForKey:@"errData"];
    return errData;
}

- (id)onDumpErrorData:(NSDictionary *)jsonObject {
    return [jsonObject objectForKey:@"errMsg"];
}

- (NSString *)getChildrenUrl {
    return @"api/dic/holiday/findHoliday.do";
}

/**
 *  放入请求的基本参数
 *
 *  @param params 参数容器，注意：里面已经放入基本的请求参数
 */
- (void)onPutParams:(NSMutableDictionary *)params {
    [params removeAllObjects];
    params[@"startDate"] = self.startDate;
    params[@"endDate"] = self.endDate;
}

- (BOOL)onPostJson {
    return NO;
}

@end
