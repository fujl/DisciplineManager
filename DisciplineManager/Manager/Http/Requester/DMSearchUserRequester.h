//
//  DMSearchUserRequester.h
//  DisciplineManager
//
//  Created by fujl-mac on 2017/7/28.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMHttpRequester.h"

@interface DMSearchUserRequester : DMHttpRequester

@property (nonatomic, assign) NSInteger offset;
@property (nonatomic, assign) NSInteger limit;
@property (nonatomic, strong) NSString *orgId;

@end
