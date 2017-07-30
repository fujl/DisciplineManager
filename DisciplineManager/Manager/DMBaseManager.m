//
//  DMBaseManager.m
//  DisciplineManager
//
//  Created by fujl-mac on 2017/6/7.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMBaseManager.h"
#import "DMUserManager.h"

static NSMutableSet *baseManagerInstanceMark;

@implementation DMBaseManager

- (instancetype)init {
    self = [super init];
    if (self) {
        if (!baseManagerInstanceMark) {
            baseManagerInstanceMark = [[NSMutableSet alloc] init];
        }
        
        NSString *claseName = NSStringFromClass([self class]);
        if ([baseManagerInstanceMark containsObject:claseName]) {
            @throw [NSException exceptionWithName:NSGenericException reason:@"管理器已经初始化，请调用getManager获取实例" userInfo:nil];
        } else {
            [baseManagerInstanceMark addObject:claseName];
        }
    }
    return self;
}

- (void)allManagerCreated {
    
}

- (void)windowCreated {
    
}

- (void)applicationDidEnterBackground {
    
}


- (void)applicationWillEnterForeground {
    
}

- (__kindof DMBaseManager *)getManager:(Class)cls {
    return getManager(cls);
}

- (DMUserManager *)getUserManager {
    return getManager([DMUserManager class]);
}

@end
