//
//  DMHttpManager.m
//  DisciplineManager
//
//  Created by fujl-mac on 2017/6/29.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMHttpManager.h"
#import "AFNetworking.h"

@interface DMHttpManager ()
@property(nonatomic, strong) AFHTTPSessionManager *sessionManager;
@end

@implementation DMHttpManager

- (instancetype)init {
    self = [super init];
    if (self) {
        _sessionManager = [AFHTTPSessionManager manager];
        _sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        _sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    return self;
}

/**
 *  使用post方式，发送数据到服务器
 *
 *  @param url     服务器地址
 *  @param params  参数
 *  @param handler 服务器返回结果，当且仅当isSuccess为YES时，表示数据请求成功
 */
- (void)postDataToServer:(NSString *)url withParams:(NSDictionary *)params completeHandler:(void (^)(BOOL isSuccess, NSData *data))handler {
    [_sessionManager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
        handler(YES, responseObject);
    }             failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        NSLog(@"WEB error = %@", error);
        handler(NO, nil);
    }];
}

- (void)postDataToServer:(NSString *)url withParams:(NSDictionary *)params withHeaders:(NSDictionary *)headers completeHandler:(void (^)(BOOL isSuccess, NSData *data))handler {
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    if(headers){
        NSArray *keys = [headers allKeys];
        for(NSString *key in keys){
            [requestSerializer setValue:headers[key] forHTTPHeaderField:key];
        }
    }
    sessionManager.requestSerializer = requestSerializer;
    sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    [sessionManager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
        handler(YES, responseObject);
    }             failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        NSLog(@"WEB error = %@", error);
        handler(NO, nil);
    }];
}

- (void)postDataToServer:(NSString *)url withJsonObjectParams:(NSDictionary *)params withHeaders:(NSDictionary *)headers completeHandler:(void (^)(BOOL isSuccess, NSData *data))handler {
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    if(headers){
        NSArray *keys = [headers allKeys];
        for(NSString *key in keys){
            [requestSerializer setValue:headers[key] forHTTPHeaderField:key];
        }
    }
    sessionManager.requestSerializer = requestSerializer;
    sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [sessionManager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
        handler(YES, responseObject);
    }             failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        NSLog(@"WEB error = %@", error);
        handler(NO, nil);
    }];
}

// 发起get请求
- (void)getDataFromServer:(NSString *)url withParams:(NSDictionary *)params completeHandler:(void (^)(BOOL isSuccess, NSData *data))handler {
    [_sessionManager GET:url parameters:params progress:nil success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
        handler(YES, responseObject);
    }            failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        NSLog(@"WEB error = %@", error);
        handler(NO, nil);
    }];
}

- (void)getDataFromServer:(NSString *)url withParams:(NSDictionary *)params withHeaders:(NSDictionary *)headers completeHandler:(void (^)(BOOL isSuccess, NSData *data))handler {
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    if(headers){
        NSArray *keys = [headers allKeys];
        for(NSString *key in keys){
            [requestSerializer setValue:headers[key] forHTTPHeaderField:key];
        }
    }
    sessionManager.requestSerializer = requestSerializer;
    sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [sessionManager GET:url parameters:params progress:nil success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
        handler(YES, responseObject);
    }            failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        NSLog(@"WEB error = %@", error);
        handler(NO, nil);
    }];
}

@end
