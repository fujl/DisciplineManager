//
//  DMSubmitTaskLeaveRequester.h
//  DisciplineManager
//
//  Created by fujl-mac on 2017/7/25.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMHttpRequester.h"

@interface DMSubmitTaskLeaveRequester : DMHttpRequester
@property (nonatomic, strong) NSString *businessId;
@property (nonatomic, strong) NSString *taskId;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, assign) DMActivitiState state;
@property (nonatomic, strong) NSString *leaderId;
@end
