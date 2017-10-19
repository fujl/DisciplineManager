//
//  DMSuperviseSubmitRequester.h
//  DisciplineManager
//
//  Created by apple on 2017/10/18.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMHttpRequester.h"

@interface DMSuperviseSubmitRequester : DMHttpRequester

@property (nonatomic, copy) NSString *transactorName;//": "主办人姓名",
@property (nonatomic, copy) NSString *reason;//": "任务内容",
@property (nonatomic, copy) NSString *endTime;//": "2017-10-18", // 截止日期
@property (nonatomic, copy) NSString *assistsId;//": "id@姓名id2,@姓名2" // 协办人员
@property (nonatomic, copy) NSString *transactorId;//": "主办人ID"

@end
