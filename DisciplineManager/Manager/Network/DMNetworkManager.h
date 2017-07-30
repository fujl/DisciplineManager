//
//  DMNetworkManager.h
//  DisciplineManager
//
//  Created by fujl on 2017/1/7.
//  Copyright © 2017年 fujl. All rights reserved.
//

#import "DMBaseManager.h"
#import "Reachability.h"

@protocol DMOnNetworkStateChangeListener <NSObject>

/**
 *  客户端网络状态发生变化了
 *
 *  @param currentState 变化完成后的网络类型
 */
@required
- (void)onNetworkStateChange:(NetworkStatus)currentState;

@end

/**
 * 网络管理器
 */
@interface DMNetworkManager : DMBaseManager

/**
 *  判断是否有网络
 *
 *  @return YES：有网络  NO:无网络
 */
- (BOOL)hasNet;

/**
 *  当前的网络类型
 *
 *  @return 0、没网， 1、Wi-Fi  2、移动流量
 */
- (NetworkStatus)currentReachabilityStatus;

/**
 *  添加网络变化监听
 *  当客户端网络状态发生变化时，会调用
 *
 *  @param listener 网络变化回调
 */
- (void)addOnNetworkStateChangeListener:(id <DMOnNetworkStateChangeListener>)listener;

/**
 * 移除变化监听，与 addOnNetworkStateChangeListener 配套使用
 * @param listener 添加的监听
 */
- (void)removeOnNetworkStateChangeListener:(id <DMOnNetworkStateChangeListener>)listener;


@end
