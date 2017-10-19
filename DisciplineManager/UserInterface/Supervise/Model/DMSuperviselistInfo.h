//
//  DMSuperviselistInfo.h
//  DisciplineManager
//
//  Created by apple on 2017/10/19.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMFormBaseInfo.h"
#import "DMAssistInfo.h"

@interface DMSuperviselistInfo : DMFormBaseInfo

@property (nonatomic, copy) NSString *transactorId;//": "主办人ID"
@property (nonatomic, copy) NSString *transactorName;
@property (nonatomic, strong) NSMutableArray<DMAssistInfo *> *assists;

@end
