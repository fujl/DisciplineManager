//
//  DMExhPraiseRequester.h
//  DisciplineManager
//
//  Created by apple on 2017/10/8.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMHttpRequester.h"

@interface DMExhPraiseRequester : DMHttpRequester

@property (nonatomic, copy) NSString *exhId;
@property (nonatomic, assign) BOOL isPraise;

@end
