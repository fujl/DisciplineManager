//
//  DMReleaseVoteRequester.h
//  DisciplineManager
//
//  Created by apple on 2017/10/6.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMHttpRequester.h"

@interface DMReleaseVoteRequester : DMHttpRequester

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) DMVoteType type;
@property (nonatomic, copy) NSString *endTime;
@property (nonatomic, strong) NSArray *options;

@end
