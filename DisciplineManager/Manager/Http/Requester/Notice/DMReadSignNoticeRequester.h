//
//  DMReadSignNoticeRequester.h
//  DisciplineManager
//
//  Created by fujl-mac on 2017/10/15.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMHttpRequester.h"

@interface DMReadSignNoticeRequester : DMHttpRequester

@property (nonatomic, copy) NSString *noticeId;

@end
