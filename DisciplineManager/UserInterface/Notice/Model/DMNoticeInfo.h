//
//  DMNoticeInfo.h
//  DisciplineManager
//
//  Created by fujl-mac on 2017/10/15.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DMUserModel.h"

/*
 
 "id": "D200919444C04209976A9DEBFF0A68DF",
 "title": "发送所有人",
 "content": "内容内容内容内容内容内容内容内容内容内容",
 "user": null,
 "createDate": "2017-09-23 18:05:31",
 "optLock": null,
 "userId": "b6256756-fc43-4a14-a8aa-89aaafdb9b26",
 
 */

@interface DMNoticeInfo : NSObject

@property (nonatomic, copy) NSString *noticeId;
@property (nonatomic, copy) NSString *title;// 发送所有人
@property (nonatomic, copy) NSString *content;// 内容内容内容内容内容内容内容内容内容内容
@property (nonatomic, strong) DMUserModel *user;
@property (nonatomic, copy) NSString *createDate;//"2017-09-23 18:05:31"
@property (nonatomic, copy) NSString *optLock;//":null,
@property (nonatomic, copy) NSString *userId;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
