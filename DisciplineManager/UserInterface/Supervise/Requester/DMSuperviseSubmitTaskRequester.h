//
//  DMSuperviseSubmitTaskRequester.h
//  DisciplineManager
//
//  Created by apple on 2017/10/18.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMHttpRequester.h"

@interface DMSuperviseSubmitTaskRequester : DMHttpRequester

@property (nonatomic, strong) NSString *businessId;
@property (nonatomic, strong) NSString *taskId;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, assign) DMActivitiState state;
@property (nonatomic, strong) NSString *assistsId;
@property (nonatomic, strong) NSString *agentId;

@end
