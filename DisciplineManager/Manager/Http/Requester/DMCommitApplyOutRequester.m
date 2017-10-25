//
//  DMCommitApplyOutRequester.m
//  DisciplineManager
//
//  Created by fujl-mac on 2017/6/29.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMCommitApplyOutRequester.h"

@interface DMCommitApplyOutRequester () <DMRequesterDelegate>

@end

@implementation DMCommitApplyOutRequester

- (instancetype)init {
    self = [super init];
    if (self) {
        self.delegate = self;
    }
    return self;
}

#pragma mark - HlwyyRequesterDelegate
- (id)onDumpData:(NSDictionary *)jsonObject {
    return jsonObject;
}

- (id)onDumpErrorData:(NSDictionary *)jsonObject {
    return [jsonObject objectForKey:@"errMsg"];
}

- (NSString *)getChildrenUrl {
    return @"jgxt/api/egressionApply/submit.do";
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
    params[@"startTime"] = self.startTime;
    if (self.province) {
        params[@"province"] = self.province;
    } else {
        params[@"province"] = @"贵州省";
    }
    if (self.city) {
        params[@"city"] = self.city;
    } else {
        params[@"city"] = @"黔西南州";
    }
    if (self.area) {
        params[@"county"] = self.area;
    } else {
        params[@"county"] = @"兴义市";
    }
    if (self.address) {
        params[@"address"] = self.address;
    } else {
        params[@"address"] = @"";
    }
    params[@"isNeedCar"] = @(self.isNeedCar);
    params[@"reason"] = self.reason;
}

- (BOOL)onPostJson {
    return YES;
}
@end
