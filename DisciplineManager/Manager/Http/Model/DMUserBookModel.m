//
//  DMUserBookModel.m
//  DisciplineManager
//
//  Created by fujl-mac on 2017/7/28.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMUserBookModel.h"

@implementation DMUserBookModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.userId = parseStringFromObject([dict objectForKey:@"userId"]);
        self.name = parseStringFromObject([dict objectForKey:@"name"]);
        self.face = parseStringFromObject([dict objectForKey:@"face"]);
        self.pinyin = parseStringFromObject([dict objectForKey:@"pinyin"]);
        self.mobile = parseStringFromObject([dict objectForKey:@"mobile"]);
        self.email = parseStringFromObject([dict objectForKey:@"email"]);
        self.province = parseStringFromObject([dict objectForKey:@"province"]);
        self.city = parseStringFromObject([dict objectForKey:@"city"]);
        self.county = parseStringFromObject([dict objectForKey:@"county"]);
        self.address = parseStringFromObject([dict objectForKey:@"address"]);
        self.lat = parseStringFromObject([dict objectForKey:@"lat"]);
        self.lng = parseStringFromObject([dict objectForKey:@"lng"]);
        self.tel = parseStringFromObject([dict objectForKey:@"tel"]);
        self.deptUserId = parseStringFromObject([dict objectForKey:@"deptUserId"]);
        self.deptUserName = parseStringFromObject([dict objectForKey:@"deptUserName"]);
        self.orgId = parseStringFromObject([dict objectForKey:@"orgId"]);
        self.orgName = parseStringFromObject([dict objectForKey:@"orgName"]);
        self.orgCode = parseStringFromObject([dict objectForKey:@"orgCode"]);
        self.gender = [parseNumberFromObject([dict objectForKey:@"gender"]) integerValue];
        self.jobName = parseStringFromObject([dict objectForKey:@"jobName"]);
        
        self.startTime = parseStringFromObject([dict objectForKey:@"startTime"]);
        self.reason = parseStringFromObject([dict objectForKey:@"reason"]);
        self.leaveTime = parseStringFromObject([dict objectForKey:@"leaveTime"]);
        self.leaveReason = parseStringFromObject([dict objectForKey:@"leaveReason"]);
        self.leaveType = [parseNumberFromObject([dict objectForKey:@"leaveType"]) integerValue];
    }
    return self;
}

- (NSString *)getStateString {
//    String eaReason = item.optString("reason"); // 外出事由
//    String startTime = item.optString("startTime"); // 外出时间
//    String leaveReason = item.optString("leaveReason"); // 请休假事由
//    String leaveTime = item.optString("leaveTime"); // 请休假时间
//    int leaveType = item.optInt("leaveType"); // 请假类别
    
    //if (StringUtils.isNotBlank(eaReason) && !"null".equals(eaReason) && StringUtils.isNotBlank(startTime) && !"null".equals(startTime)) {
    if (![self.reason isEqualToString:@""] && ![self.startTime isEqualToString:@""]) {
        // 外出
        return @"外出";
    //} else if (StringUtils.isNotBlank(leaveReason) && !"null".equals(leaveReason) && StringUtils.isNotBlank(leaveTime) && !"null".equals(leaveTime)) {
        } else if (![self.leaveReason isEqualToString:@""] && ![self.leaveTime isEqualToString:@""]) {
        if(self.leaveType == 0) {
            // 请假
            return @"请假";
        } else if(self.leaveType == 1) {
            // 休假
            return @"休假";
        } else {
            return @"未知";
        }
    } else {
        // 在岗
        return @"在岗";
    }
}


/*
 if (isOut) {
 self.stateView.text = NSLocalizedString(@"Out", @"外出");
 self.stateView.backgroundColor = [UIColor colorWithRGB:0x5cb85c];
 } else if (userInfo.leaveState2 > 0) {
 self.stateView.text = NSLocalizedString(@"Vacation", @"休假");
 self.stateView.backgroundColor = [UIColor colorWithRGB:0xd9534f];
 } else if (userInfo.leaveState > 0) {
 self.stateView.text = NSLocalizedString(@"Leave", @"请假");
 self.stateView.backgroundColor = [UIColor colorWithRGB:0x5bc0de];
 } else {
 self.stateView.text = NSLocalizedString(@"OnGuard", @"在岗");
 self.stateView.backgroundColor = [UIColor colorWithRGB:0x5cb85c];
 }
 */
- (UIColor *)getStateColor {
    if (![self.reason isEqualToString:@""] && ![self.startTime isEqualToString:@""]) {
        // 外出
        return [UIColor colorWithRGB:0x0073b7];
        //} else if (StringUtils.isNotBlank(leaveReason) && !"null".equals(leaveReason) && StringUtils.isNotBlank(leaveTime) && !"null".equals(leaveTime)) {
    } else if (![self.leaveReason isEqualToString:@""] && ![self.leaveTime isEqualToString:@""]) {
        if(self.leaveType == 0) {
            // 请假
            return [UIColor colorWithRGB:0xd9534f];
        } else if(self.leaveType == 1) {
            // 休假
            return [UIColor colorWithRGB:0xFE9C6D];
        } else {
            return [UIColor colorWithRGB:0x777777];
        }
    } else {
        // 在岗
        return [UIColor colorWithRGB:0x5cb85c];
    }
}

@end
