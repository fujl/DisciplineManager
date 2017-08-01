//
//  DMSubmitTaskCtaRequester.h
//  DisciplineManager
//
//  Created by fujl-mac on 2017/8/1.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMHttpRequester.h"

@interface DMSubmitTaskCtaRequester : DMHttpRequester

@property (nonatomic, strong) NSString *businessId;
@property (nonatomic, strong) NSString *taskId;
@property (nonatomic, strong) NSString *number;
@property (nonatomic, strong) NSString *number2;
@property (nonatomic, strong) NSString *expiryDate;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, assign) DMActivitiState state;
@property (nonatomic, strong) NSString *emp;

@end
