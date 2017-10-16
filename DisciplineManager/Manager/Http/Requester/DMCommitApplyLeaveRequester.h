//
//  DMCommitApplyLeaveRequester.h
//  DisciplineManager
//
//  Created by fujl-mac on 2017/7/6.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMHttpRequester.h"

@interface DMCommitApplyLeaveRequester : DMHttpRequester
@property (nonatomic, assign) DMLeaveType type;
@property (nonatomic, assign) DMDateType startTimeType;
@property (nonatomic, assign) DMDateType endTimeType;
@property (nonatomic, strong) NSString *holiday;
@property (nonatomic, assign) CGFloat days;
@property (nonatomic, strong) NSString *ticket;

@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *endTime;
@property (nonatomic, strong) NSString *reason;

@property (nonatomic, strong) NSArray *attrs;

@end
