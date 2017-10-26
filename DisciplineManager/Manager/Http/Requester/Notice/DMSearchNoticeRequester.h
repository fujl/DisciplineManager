//
//  DMSearchNoticeRequester.h
//  DisciplineManager
//
//  Created by fujl-mac on 2017/10/15.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMHttpRequester.h"

@interface DMSearchNoticeRequester : DMHttpRequester

@property (nonatomic, assign) NSInteger isReadSign;
@property (nonatomic, assign) NSInteger offset;
@property (nonatomic, assign) NSInteger limit;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *toId;

@end
