//
//  DMSubmitTaskBusRequester.h
//  DisciplineManager
//
//  Created by fujl-mac on 2017/8/1.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMHttpRequester.h"

@interface DMSubmitTaskBusRequester : DMHttpRequester

@property (nonatomic, strong) NSString *businessId;
@property (nonatomic, strong) NSString *taskId;
@property (nonatomic, strong) NSString *driverId;
@property (nonatomic, strong) NSString *driverName;
@property (nonatomic, strong) NSString *officialCarId;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, assign) DMActivitiState state;
@property (nonatomic, strong) NSString *emp;

@end
