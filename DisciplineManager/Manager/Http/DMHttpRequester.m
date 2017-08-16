//
//  DMHttpRequester.m
//  DisciplineManager
//
//  Created by fujl-mac on 2017/6/29.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMHttpRequester.h"
#import "DMHttpManager.h"
#import "DMUserManager.h"

@implementation DMHttpRequester

- (void)doRequest:(void (^)(DMResultCode code, id data))resultListener {
    if (!_delegate) {
        @throw [NSException exceptionWithName:NSGenericException reason:@"请设置请求的delegate回调" userInfo:nil];
    }
    DMNetworkManager *netWorkManager = getManager(DMNetworkManager);
    if(![netWorkManager hasNet]){
        resultListener(ResultCodeNetError,nil);
        return;
    }
    NSString *url = [NSString stringWithFormat:@"%@%@", [[DMConfig mainConfig] getServerUrl], [_delegate getChildrenUrl]];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [self putPublicParams:params];
    // 放入接口请求参数
    [_delegate onPutParams:params];
    DMHttpManager *httpManager = getManager([DMHttpManager class]);
    NSLog(@"get request, url = %@?param=%@\n", url, params);
    [httpManager getDataFromServer:url withParams:params completeHandler:^(BOOL isSuccess, NSData *data) {
        NSLog(@"get response, url = %@, isSuccess = %@, data = %@\n", url, isSuccess ? @"true" : @"false", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        [self requestCompleteHandler:isSuccess data:data resultListener:resultListener delegate:_delegate];
    }];
}

- (void)doRequest:(void (^)(DMResultCode, id data))resultListener withDelay:(NSTimeInterval)delayTime {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delayTime * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self doRequest:resultListener];
    });
}

- (void)requestCompleteHandler:(BOOL)isSuccess
                          data:(id)data
                resultListener:(void (^)(DMResultCode code, id data))resultListener
                      delegate:(id <DMRequesterDelegate>) delegate {
    if (isSuccess) {
        NSDictionary *resultData = [DMJson getJsonObjectFormData:data];
        int code = [resultData[@"errCode"] intValue];
        id dumpData = nil;
        if (code == ResultCodeOK) {
            dumpData = [delegate onDumpData:resultData];
        } else {
            if ([delegate respondsToSelector:@selector(onDumpErrorData:)]) {
                dumpData = [delegate onDumpErrorData:resultData];
            }
        }
        if (code == ResultCodeAuthenticationFailure) {
            if ([[delegate getChildrenUrl] isEqualToString:@"api/isLogin.do"]) {
                resultListener(code, dumpData);
            } else {
                DMUserManager *userManager = getManager([DMUserManager class]);
                [userManager autoLogin:^(DMResultCode code) {
                    if (code == ResultCodeOK) {
                        [userManager startMainController];
                    } else {
                        [userManager startLoginController];
                    }
                }];
            }
        } else {
            resultListener(code, dumpData);
        }
    } else {
        // 网络不给力
        resultListener(ResultCodeTimeOut, nil);
    }
}

- (void)postRequest:(void (^)(DMResultCode code, id data))resultListener {
    if (!_delegate) {
        @throw [NSException exceptionWithName:NSGenericException reason:@"请设置请求的delegate回调" userInfo:nil];
    }
    DMNetworkManager *netWorkManager = getManager([DMNetworkManager class]);
    if(![netWorkManager hasNet]){
        resultListener(ResultCodeNetError,nil);
        return;
    }
    NSString *url = [NSString stringWithFormat:@"%@%@", [[DMConfig mainConfig] getServerUrl], [_delegate getChildrenUrl]];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [self putPublicParams:params];
    // 放入接口请求参数
    [_delegate onPutParams:params];
    DMHttpManager *httpManager = getManager([DMHttpManager class]);
    DMUserManager *userManager = getManager([DMUserManager class]);
    NSLog(@"post request, onPostJson：%d url = %@?param=%@\n", [_delegate onPostJson], url, params);
    if (userManager.isNeedLogin || ![_delegate onPostJson]) {
        [httpManager postDataToServer:url withParams:params completeHandler:^(BOOL isSuccess, NSData *data) {
            NSLog(@"post response, url = %@, isSuccess = %@, data = %@\n", url, isSuccess ? @"true" : @"false", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            [self requestCompleteHandler:isSuccess data:data resultListener:resultListener delegate:_delegate];
        }];
    } else {
        [httpManager postDataToServer:url withJsonObjectParams:params withHeaders:@{@"token":userManager.loginInfo.accessToken} completeHandler:^(BOOL isSuccess, NSData *data) {
            NSLog(@"post response, url = %@, isSuccess = %@, data = %@\n", url, isSuccess ? @"true" : @"false", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            [self requestCompleteHandler:isSuccess data:data resultListener:resultListener delegate:_delegate];
        }];
    }
}

#pragma mark - private method
- (void)putPublicParams:(NSMutableDictionary *)params {
    DMUserManager *userManager = getManager([DMUserManager class]);
    if (!userManager.isNeedLogin) {
        params[@"userId"] = userManager.loginInfo.userId;
        params[@"token"] = userManager.loginInfo.accessToken;
    }
}

@end
