//
//  DMConfig.h
//  DisciplineManager
//
//  Created by fujl-mac on 2017/6/29.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ServerName){
    ServerNameNormal,
    ServerNameTest
};

@interface DMConfig : NSObject

/**
 *  服务器名字
 */
@property(nonatomic, readonly) ServerName serverName;

/**
 *  获取程序配置
 *
 *  @return 程序的配置
 */
+(DMConfig *)mainConfig;

/**
 *  获取WEB服务器地址
 *
 *  @return WEB服务器地址
 */
- (NSString *)getServerUrl;

/**
 *  获取Documen目录
 *
 *  @return document
 */
- (NSString *)getAppDocumentDirectory;
@end
