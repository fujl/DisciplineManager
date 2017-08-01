//
//  DMOfficialCarModel.h
//  DisciplineManager
//
//  Created by apple on 17/8/1.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMOfficialCarModel : NSObject

@property (nonatomic, strong) NSString *ocId; //": "078899BF54474165837111E0B1287F67",
@property (nonatomic, strong) NSString *createDate; //": "2017-07-10 10:54:28",
@property (nonatomic, strong) NSString *operatorDate; //": "2017-07-10 10:54:28",
@property (nonatomic, strong) NSString *operatorId; //": "8ECA10C3DBFD4712AAF288CBBFDBF348",
@property (nonatomic, strong) NSString *operatorName; //": "陈宽斌",
@property (nonatomic, assign) NSInteger delSign; //": 0,
@property (nonatomic, strong) NSString *optLock; //": null,
@property (nonatomic, strong) NSString *number; //": "贵E12345",
@property (nonatomic, strong) NSString *brand; //": "奥迪R8",
@property (nonatomic, strong) NSString *color; //": "黑色",
@property (nonatomic, strong) NSString *model; //": "轿车",
@property (nonatomic, strong) NSString *userId; //": null,
@property (nonatomic, strong) NSString *name; //": null,
@property (nonatomic, assign) NSInteger state; //": 2  // 大于0 代表 车辆已外出  未回刚

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
