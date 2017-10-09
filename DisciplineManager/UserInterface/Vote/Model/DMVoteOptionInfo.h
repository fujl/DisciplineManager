//
//  DMVoteOptionInfo.h
//  DisciplineManager
//
//  Created by apple on 2017/10/9.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DMVoteResultInfo.h"

@interface DMVoteOptionInfo : NSObject

@property (nonatomic, copy) NSString *optionId;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) NSInteger number;
@property (nonatomic, assign) NSInteger optLock;
@property (nonatomic, strong) NSMutableArray<DMVoteResultInfo *> *results;
@property (nonatomic, assign) NSInteger total;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
