//
//  DMUserBookModel.h
//  DisciplineManager
//
//  Created by fujl-mac on 2017/7/28.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMUserBookModel : NSObject


@property (nonatomic, strong) NSString *userId; // ": "8ECA10C3DBFD4712AAF288CBBFDBF348",
@property (nonatomic, strong) NSString *name; // ": "陈宽斌",
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
@property (nonatomic, strong) NSString *orgName; // ": "信息中心",
@property (nonatomic, assign) NSInteger goOutState; // ": 0,  //如果大于0 通讯录人员状态为 外出
@property (nonatomic, assign) NSInteger ocarState; // ": 0,  // 如果大于0 通讯录人员状态为 外出
@property (nonatomic, assign) NSInteger leaveState; // ": 0  // 如果大于0 通讯录人员状态为 请假

- (instancetype)initWithDict:(NSDictionary *)dict;
@end
