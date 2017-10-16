//
//  DMApplyOutListInfo.m
//  DisciplineManager
//
//  Created by fujl-mac on 2017/6/29.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMApplyOutListInfo.h"

@implementation DMApplyOutListInfo

/*"id": "506FD60162E54E37BD39F4E884791DB5",
 "createDate": "2017-05-05 15:29:28",
 "reason": "我要去非洲",
 "startTime": "2017-05-11 09:00:00",
 "endTime": null,
 "state": 1,
 "processInstanceId": "50038"
 */

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super initWithDict:dict];
    if (self) {
        self.province = parseStringFromObject([dict objectForKey:@"province"]);
        self.city = parseStringFromObject([dict objectForKey:@"city"]);
        self.county = parseStringFromObject([dict objectForKey:@"county"]);
        self.address = parseStringFromObject([dict objectForKey:@"address"]);
        self.isNeedCar = [parseNumberFromObject([dict objectForKey:@"isNeedCar"]) integerValue];
        if (self.isNeedCar == 1) {
            self.driverId = parseStringFromObject([dict objectForKey:@"driverId"]);
            self.driverName = parseStringFromObject([dict objectForKey:@"driverName"]);
            self.officialCar = parseStringFromObject([dict objectForKey:@"officialCar"]);
        }
    }
    return self;
}

@end
