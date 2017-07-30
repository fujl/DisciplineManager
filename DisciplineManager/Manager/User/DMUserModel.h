//
//  DMUserModel.h
//  DisciplineManager
//
//  Created by fujl-mac on 2017/7/25.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DMUserInfo.h"
#import "DMOrgModel.h"

/*
 {
 "errCode":2,
 "errMsg":"success",
 "errData":{
 "id":"F55B27AD03034815A854B85EA53FC403",
 "createDate":"2017-07-06 15:19:24",
 "operatorDate":"2017-07-24 20:31:35",
 "operatorId":"F55B27AD03034815A854B85EA53FC403",
 "operatorName":"IOS测试",
 "delSign":1,
 "optLock":5,
 "loginId":"ios001",
 "enabled":1,
 "unLockedTime":"1970-02-01 00:00:01",
 "expiryDate":"2017-08-31 00:00:00",
 "userInfo":{
 "id":"E53B405C1167411E805F7DA5A78A2B58",
 "name":"IOS测试",
 "mobile":"18286000191",
 "email":"",
 "province":"北京市",
 "city":"北京市市辖区",
 "county":"东城区",
 "address":"",
 "deptUserId":"F55B27AD03034815A854B85EA53FC403",
 "deptUserName":"IOS测试",
 "baiduChannelId":"4594165929953927487",
 "deviceType":3,
 "pinyin":"IOSceshi",
 "optLock":5
 },
 "org":{
 "id":"001001",
 "createDate":"2015-02-08 17:54:55",
 "operatorDate":"2017-04-25 17:08:34",
 "operatorId":"b6256756-fc43-4a14-a8aa-89aaafdb9b26",
 "operatorName":"系统管理员",
 "delSign":1,
 "optLock":1,
 "code":"001001",
 "name":"信息中心",
 "description":"",
 "parentId":"001",
 "type":0,
 "isLeaf":0,
 "isParent":false,
 "children":[
 
 ]
 },
 "loginError":0,
 "expired":-1,
 "locked":-1
 }
 }
 */
@interface DMUserModel : NSObject
@property (nonatomic, strong) NSString *userId; // ":"F55B27AD03034815A854B85EA53FC403",
@property (nonatomic, strong) NSString *createDate; // ":"2017-07-06 15:19:24",
@property (nonatomic, strong) NSString *operatorDate; // ":"2017-07-24 20:31:35",
@property (nonatomic, strong) NSString *operatorId; // ":"F55B27AD03034815A854B85EA53FC403",
@property (nonatomic, strong) NSString *operatorName; // ":"IOS测试",
@property (nonatomic, assign) NSInteger delSign; // ":1,
@property (nonatomic, assign) NSInteger optLock; // ":5,
@property (nonatomic, strong) NSString *loginId; // ":"ios001",
@property (nonatomic, assign) NSInteger enabled; // ":1,
@property (nonatomic, strong) NSString *unLockedTime; // ":"1970-02-01 00:00:01",
@property (nonatomic, strong) NSString *expiryDate; // ":"2017-08-31 00:00:00",
@property (nonatomic, strong) DMUserInfo *userInfo;
@property (nonatomic, strong) DMOrgModel *orgInfo;

- (instancetype)initWithDict:(NSDictionary *)dict;
@end
