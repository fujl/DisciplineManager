//
//  DMResultCode.h
//  DisciplineManager
//
//  Created by fujl-mac on 2017/6/29.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#ifndef DMResultCode_h
#define DMResultCode_h

typedef NS_ENUM(NSInteger, DMResultCode) {
    ResultCodeOK                        = 2,                // 请求成功
    ResultCodeFailed                    = -1,               // 请求失败
    ResultCodeTimeOut                   = -2,               // 请求超时
    ResultCodeNetError                  = -3,               // 请求无网络
    ResultCodeAuthenticationFailure     = 10005,            // 鉴权失败
};

#endif /* DMResultCode_h */
