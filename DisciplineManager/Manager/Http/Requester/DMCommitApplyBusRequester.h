//
//  DMCommitApplyBusRequester.h
//  DisciplineManager
//
//  Created by fujl-mac on 2017/6/30.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMHttpRequester.h"

@interface DMCommitApplyBusRequester : DMHttpRequester
@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *reason;
@end
