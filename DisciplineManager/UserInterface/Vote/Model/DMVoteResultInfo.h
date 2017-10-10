//
//  DMVoteResultInfo.h
//  DisciplineManager
//
//  Created by apple on 2017/10/9.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMVoteResultInfo : NSObject

@property (nonatomic, copy) NSString *resultId;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *voteId;
@property (nonatomic, copy) NSString *optionId;
@property (nonatomic, assign) NSInteger optLock;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
