//
//  DMSubmitVoteRequester.h
//  DisciplineManager
//
//  Created by fujl-mac on 2017/10/10.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMHttpRequester.h"

@interface DMSubmitVoteRequester : DMHttpRequester

@property (nonatomic, copy) NSString *voteId;
@property (nonatomic, copy) NSString *optionId;  // 如果是多选用逗号分隔

@end
