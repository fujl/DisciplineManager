//
//  DMSubmitVoteRequester.m
//  DisciplineManager
//
//  Created by fujl-mac on 2017/10/10.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMSubmitVoteRequester.h"

@interface DMSubmitVoteRequester () <DMRequesterDelegate>

@end

@implementation DMSubmitVoteRequester

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
    return @"jgxt/api/vote/submit.do";
}

/**
 *  放入请求的基本参数
 *
 *  @param params 参数容器，注意：里面已经放入基本的请求参数
 * userId: 必须, 当前用户ID
 * channelId: 必须 移动端绑定成功以后的channelId, 百度推送
 * deviceType: 必须 设备类别, 3: android, 4: IOS
 */
- (void)onPutParams:(NSMutableDictionary *)params {
    NSString *userId = [params objectForKey:@"userId"];
    [params removeAllObjects];
    params[@"userId"] = userId;
    params[@"voteId"] = self.voteId;
    params[@"optionId"] = self.optionId;
}

- (BOOL)onPostJson {
    return YES;
}

@end
