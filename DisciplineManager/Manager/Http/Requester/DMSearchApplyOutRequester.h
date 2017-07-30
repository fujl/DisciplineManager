//
//  DMSearchApplyOutRequester.h
//  DisciplineManager
//
//  Created by fujl-mac on 2017/6/29.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMHttpRequester.h"

@interface DMSearchApplyOutRequester : DMHttpRequester

@property (nonatomic, assign) NSInteger offset;
@property (nonatomic, assign) NSInteger limit;

@end
