//
//  DMSubmitSignRequester.m
//  DisciplineManager
//
//  Created by apple on 2017/10/10.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMSubmitSignRequester.h"

@interface DMSubmitSignRequester () <DMRequesterDelegate>

@end

@implementation DMSubmitSignRequester

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
    return @"jgxt/api/repast/sign/submit.do";
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
    params[@"isNeedBreakfast"] = @(self.isNeedBreakfast);
    params[@"isNeedLunch"] = @(self.isNeedLunch);
    params[@"breakfasts"] = self.breakfasts;
    params[@"lunchs"] = self.lunchs;
}

- (BOOL)onPostJson {
    return YES;
}

@end
