//
//  DMHttpManager.h
//  DisciplineManager
//
//  Created by fujl-mac on 2017/6/29.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMBaseManager.h"

@interface DMHttpManager : DMBaseManager

/**
 *  使用post方式，发送数据到服务器
 *
 *  @param url     服务器地址
 *  @param params  参数
 *  @param handler 服务器返回结果，当且仅当isSuccess为YES时，表示数据请求成功
 */
- (void)postDataToServer:(NSString *)url withParams:(NSDictionary *)params completeHandler:(void (^)(BOOL isSuccess, NSData *data))handler;

- (void)postDataToServer:(NSString *)url withParams:(NSDictionary *)params withHeaders:(NSDictionary *)headers completeHandler:(void (^)(BOOL isSuccess, NSData *data))handler;

/**
 *  使用post方式，发送JSON数据到服务器
 *
 *  @param url     服务器地址
 *  @param params  参数
 *  @param handler 服务器返回结果，当且仅当isSuccess为YES时，表示数据请求成功
 */
- (void)postDataToServer:(NSString *)url withJsonObjectParams:(NSDictionary *)params withHeaders:(NSDictionary *)headers completeHandler:(void (^)(BOOL isSuccess, NSData *data))handler;

// 发起get请求
- (void)getDataFromServer:(NSString *)url withParams:(NSDictionary *)params completeHandler:(void (^)(BOOL isSuccess, NSData *data))handler;

- (void)getDataFromServer:(NSString *)url withParams:(NSDictionary *)params withHeaders:(NSDictionary *)headers completeHandler:(void (^)(BOOL isSuccess, NSData *data))handler;

@end
