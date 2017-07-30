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
@property (nonatomic, strong) NSString *reason;

@end
