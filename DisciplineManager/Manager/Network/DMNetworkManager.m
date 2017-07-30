//
//  DMNetworkManager.m
//  DisciplineManager
//
//  Created by fujl on 2017/6/7.
//  Copyright © 2017年 fujl. All rights reserved.
//

#import "DMNetworkManager.h"

#import "DMWeakReferencesArray.h"

@interface DMNetworkManager ()

@property(nonatomic, strong) Reachability *internetReachability;
@property(nonnull, strong) DMWeakReferencesArray *listeners;

@end

@implementation DMNetworkManager

- (instancetype)init {
    self = [super init];
    if (self) {
        _listeners = [[DMWeakReferencesArray alloc] init];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
        self.internetReachability = [Reachability reachabilityForInternetConnection];
        [self.internetReachability startNotifier];
    }
    return self;
}

- (BOOL)hasNet {
    return [self currentReachabilityStatus] != NotReachable;
}

- (NetworkStatus)currentReachabilityStatus {
    return [self.internetReachability currentReachabilityStatus];
}

- (void)addOnNetworkStateChangeListener:(id <DMOnNetworkStateChangeListener>)listener {
    [_listeners addObject:listener];
}

- (void)removeOnNetworkStateChangeListener:(id <DMOnNetworkStateChangeListener>)listener {
    [_listeners removeObject:listener];
}

/*!
 * Called by Reachability whenever status changes.
 */
- (void)reachabilityChanged:(NSNotification *)note {
    // 网络状态变化了 通知
    for (id <DMOnNetworkStateChangeListener> listener in _listeners.allObjects) {
        [listener onNetworkStateChange:[self currentReachabilityStatus]];
    }
}

@end
