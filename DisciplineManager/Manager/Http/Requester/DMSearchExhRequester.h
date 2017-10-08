//
//  DMSearchExhRequester.h
//  DisciplineManager
//
//  Created by apple on 2017/10/6.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMHttpRequester.h"

@interface DMSearchExhRequester : DMHttpRequester

@property (nonatomic, assign) NSInteger offset;
@property (nonatomic, assign) NSInteger limit;

@end
