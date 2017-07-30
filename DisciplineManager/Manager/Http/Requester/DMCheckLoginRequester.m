//
//  DMCheckLoginRequester.m
//  DisciplineManager
//
//  Created by fujl-mac on 2017/7/10.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMCheckLoginRequester.h"

@interface DMCheckLoginRequester () <DMRequesterDelegate>

@end

@implementation DMCheckLoginRequester

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
    return @"api/isLogin.do";
}

/**
 *  放入请求的基本参数
 *
 *  @param params 参数容器，注意：里面已经放入基本的请求参数
 */
- (void)onPutParams:(NSMutableDictionary *)params {
    
}

- (BOOL)onPostJson {
    return NO;
}

@end
