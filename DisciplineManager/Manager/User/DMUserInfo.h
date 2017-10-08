//
//  DMUserInfo.h
//  DisciplineManager
//
//  Created by fujl-mac on 2017/6/29.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import <Foundation/Foundation.h>

// 1 男  2 女
typedef NS_ENUM(NSInteger, DMGender) {
    Male        = 1,                // 男
    Female      = 2,                // 女
};

@interface DMUserInfo : NSObject

/*"id":"E53B405C1167411E805F7DA5A78A2B58",
 "name":"IOS测试",
 "mobile":"18286000191",
 "email":"",
 "province":"北京市",
 "city":"北京市市辖区",
 "county":"东城区",
 "address":"",
 "latitude":null,
 "longitude":null,
 "tel":null,
 "contacts":null,
 "deptUserId":"F55B27AD03034815A854B85EA53FC403",
 "deptUserName":"IOS测试",
 "baiduChannelId":"4594165929953927487",
 "deviceType":3,
 "pinyin":"IOSceshi",
 "optLock":4*/

@property (nonatomic, copy) NSString *userId;

/** 用户名 */
@property (nonatomic, copy) NSString *name;

/** 用户头像 */
@property (nonatomic, copy) NSString *face;

/** 电话 */
@property (nonatomic, copy) NSString *mobile;

/** 用户email */
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *province;     //":"北京市",
@property (nonatomic, copy) NSString *city;         //":"北京市市辖区",
@property (nonatomic, copy) NSString *county;       //":"东城区",
@property (nonatomic, copy) NSString *address;      //":"",
@property (nonatomic, copy) NSString *latitude;     //":null,
@property (nonatomic, copy) NSString *longitude;    //":null,
@property (nonatomic, copy) NSString *tel;          //":null,
@property (nonatomic, copy) NSString *contacts;     //":null,
@property (nonatomic, copy) NSString *deptUserId;   //":"F55B27AD03034815A854B85EA53FC403",
@property (nonatomic, copy) NSString *deptUserName; //":"IOS测试",
@property (nonatomic, copy) NSString *baiduChannelId; //":"4594165929953927487",
@property (nonatomic, assign) NSInteger deviceType;   //":3,
@property (nonatomic, copy) NSString *pinyin;       //":"IOSceshi",
@property (nonatomic, assign) DMGender gender;
@property (nonatomic, assign) NSInteger optLock;      //":4

- (instancetype)initWithDict:(NSDictionary *)dict;
@end
