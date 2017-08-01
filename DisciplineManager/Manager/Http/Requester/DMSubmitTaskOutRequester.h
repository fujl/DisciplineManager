//
//  DMSubmitTaskOutRequester.h
//  DisciplineManager
//
//  Created by fujl-mac on 2017/8/1.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMHttpRequester.h"

@interface DMSubmitTaskOutRequester : DMHttpRequester

@property (nonatomic, strong) NSString *businessId;
@property (nonatomic, strong) NSString *taskId;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSNumber *state;

@end
