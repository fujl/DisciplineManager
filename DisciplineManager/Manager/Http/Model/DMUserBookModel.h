//
//  DMUserBookModel.h
//  DisciplineManager
//
//  Created by fujl-mac on 2017/7/28.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DMUserInfo.h"

/*
 "userId":"ED49FF709B154CE38732620F8ABAC105",
 "name":"郑金波",
 "orgName":"局长室",
 "orgCode":"001001",
 "pinyin":"zhengjinbo",
 "mobile":"15121596666",
 "email":"",
 "province":"贵州省",
 "city":"黔西南布依族苗族自治州",
 "county":"兴义市",
 "address":"",
 "lat":null,
 "lng":null,
 "tel":null,
 "deptUserId":"ED49FF709B154CE38732620F8ABAC105",
 "deptUserName":"郑金波",
 "orgId":"3FEB83EBC83F44E6872CE69AFF9E94C0",
 "job":1,
 "gender":1,
 "face":null,
 "jobName":"局长",
 "prioity":0,
 "startTime":null,
 "reason":null,
 "leaveTime":null,
 "leaveReason":null,
 "leaveType":null
 */
@interface DMUserBookModel : NSObject

@property (nonatomic, strong) NSString *userId; // ": "8ECA10C3DBFD4712AAF288CBBFDBF348",
@property (nonatomic, strong) NSString *name; // ": "陈宽斌",
@property (nonatomic, strong) NSString *face;
@property (nonatomic, strong) NSString *pinyin; // ": null,
@property (nonatomic, strong) NSString *mobile; // ": "13985980009",
@property (nonatomic, strong) NSString *email; // ": "",
@property (nonatomic, strong) NSString *province; // ": "贵州省",
@property (nonatomic, strong) NSString *city; // ": "贵阳市",
@property (nonatomic, strong) NSString *county; // ": "南明区",
@property (nonatomic, strong) NSString *address; // ": "",
@property (nonatomic, strong) NSString *lat; // ": null,
@property (nonatomic, strong) NSString *lng; // ": null,
@property (nonatomic, strong) NSString *tel; // ": null,
@property (nonatomic, strong) NSString *deptUserId; // ": "8ECA10C3DBFD4712AAF288CBBFDBF348",
@property (nonatomic, strong) NSString *deptUserName; // ": "陈宽斌",
@property (nonatomic, strong) NSString *orgId; // ": "001001",
@property (nonatomic, strong) NSString *orgCode;
@property (nonatomic, strong) NSString *orgName; // ": "信息中心",
@property (nonatomic, assign) DMGender gender;
@property (nonatomic, strong) NSString *jobName;

@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *reason;
@property (nonatomic, strong) NSString *leaveTime;
@property (nonatomic, strong) NSString *leaveReason;
@property (nonatomic, assign) NSInteger leaveType;


- (instancetype)initWithDict:(NSDictionary *)dict;
- (NSString *)getStateString;
- (UIColor *)getStateColor;

@end
