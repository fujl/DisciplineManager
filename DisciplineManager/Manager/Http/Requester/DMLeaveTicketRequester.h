//
//  DMLeaveTicketRequester.h
//  DisciplineManager
//
//  Created by fujl-mac on 2017/7/22.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMHttpRequester.h"

@interface DMLeaveTicketRequester : DMHttpRequester
@property (nonatomic, assign) NSInteger offset;
@property (nonatomic, assign) NSInteger limit;
@end
