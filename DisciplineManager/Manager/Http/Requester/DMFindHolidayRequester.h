//
//  DMFindHolidayRequester.h
//  DisciplineManager
//
//  Created by fujl-mac on 2017/7/7.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMHttpRequester.h"

@interface DMFindHolidayRequester : DMHttpRequester
@property (nonatomic, strong) NSString *startDate;
@property (nonatomic, strong) NSString *endDate;
@end
