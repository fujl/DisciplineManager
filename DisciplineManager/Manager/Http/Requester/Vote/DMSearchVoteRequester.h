//
//  DMSearchVoteRequester.h
//  DisciplineManager
//
//  Created by fujl-mac on 2017/10/9.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMHttpRequester.h"

@interface DMSearchVoteRequester : DMHttpRequester

@property (nonatomic, assign) NSInteger offset;
@property (nonatomic, assign) NSInteger limit;

@end
