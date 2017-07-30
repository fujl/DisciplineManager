//
//  DMHttpRequester.h
//  DisciplineManager
//
//  Created by fujl-mac on 2017/6/29.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DMNetworkManager.h"

@protocol DMRequesterDelegate <NSObject>

@required

/**
 *  注意： 只有服务器返回0才会执行本方法，如果服务器返回失败，会调用{@link OnResultListener#onResult(int, Object)}方法。
 *  将服务器返回的数据转换成java的数据结构
 *
 *  @param jsonObject 服务器返回的数据
 *
 *  @return 返回解析好的oc对象，该对象通过doRequest传入的resultListener返回。
 */
- (id)onDumpData:(NSDictionary *)jsonObject;

/**
 *  放入请求的基本参数
 *
 *  @param params 参数容器，注意：里面已经放入基本的请求参数
 */
- (void)onPutParams:(NSMutableDictionary *)params;

/**
 *  获取本次请求的子路径
 *
 *  必须在实现getChildrenUrl
 */
-(NSString *)getChildrenUrl;

/**
 *  判断是否postJson
 *
 *  @return 返回是否需要postJson到服务器
 */
- (BOOL)onPostJson;

@optional
- (id)onDumpErrorData:(NSDictionary *)jsonObject;

@end

@interface DMHttpRequester : NSObject

// 请求数据，参数
@property(nonatomic, weak) id <DMRequesterDelegate> delegate;

/**
 *  发起网络请求
 *
 *  @param resultListener 结果监听 当code为0时，表示请求成功
 */
- (void)doRequest:(void (^)(DMResultCode code, id data))resultListener;

/**
 *  延时发起网络请求，用于改善用户体验，部分界面网络请求太快，造成界面闪动
 *
 *  @param resultListener 回调结果
 *  @param delayTime      延时时间  秒
 */
- (void)doRequest:(void (^)(DMResultCode code, id data))resultListener withDelay:(NSTimeInterval)delayTime;

/**
 *  发起网络请求 post
 *
 *  @param resultListener 结果监听 当code为0时，表示请求成功
 */
- (void)postRequest:(void (^)(DMResultCode code, id data))resultListener;

- (void)requestCompleteHandler:(BOOL)isSuccess
                          data:(id)data
                resultListener:(void (^)(DMResultCode code, id data))resultListener
                      delegate:(id <DMRequesterDelegate>) delegate;

@end
