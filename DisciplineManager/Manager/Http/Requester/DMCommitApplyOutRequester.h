//
//  DMCommitApplyOutRequester.h
//  DisciplineManager
//
//  Created by fujl-mac on 2017/6/29.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMHttpRequester.h"

@interface DMCommitApplyOutRequester : DMHttpRequester

@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *province;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *area;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, assign) NSInteger isNeedCar;
@property (nonatomic, strong) NSString *reason;

@end
