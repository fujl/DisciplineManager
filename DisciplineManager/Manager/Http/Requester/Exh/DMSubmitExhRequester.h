//
//  DMSubmitExhRequester.h
//  DisciplineManager
//
//  Created by apple on 2017/10/6.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMHttpRequester.h"

@interface DMSubmitExhRequester : DMHttpRequester

@property (nonatomic, copy) NSString *content;
@property (nonatomic, strong) NSArray *attrs;

@end
