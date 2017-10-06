//
//  DMConfig.m
//  DisciplineManager
//
//  Created by fujl-mac on 2017/6/29.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMConfig.h"

@implementation DMConfig

+(DMConfig *)mainConfig {
    static DMConfig *mainConfig = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mainConfig = [[self alloc] initWithMain];
    });
    return mainConfig;
}

- (instancetype)initWithMain {
    self = [super init];
    if (self) {
        // 配置服务器地址
        _serverName = ServerNameTest;
    }
    return self;
}

/**
 *  获取WEB服务器地址
 *
 *  @return WEB服务器地址
 */
- (NSString *)getServerUrl {
    if (self.serverName == ServerNameNormal) {
        return @"http://m.xygs.gov.cn:8088/";
    } else {
//        return @"http://m.xygs.gov.cn:8099/";
        return @"http://38434122.ngrok.cc/jgxt/";
    }
}

//读取Document目录
- (NSString *)getAppDocumentDirectory {
    NSArray *lpPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if ([lpPaths count] > 0) {
        return lpPaths[0];
    } else {
        return nil;
    }
}
@end
