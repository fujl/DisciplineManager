//
//  DMSubmitSignRequester.h
//  DisciplineManager
//
//  Created by apple on 2017/10/10.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMHttpRequester.h"

@interface DMSubmitSignRequester : DMHttpRequester

@property (nonatomic, assign) NSInteger isNeedBreakfast;// 必须 是否需要早餐 1 是 0 否 默认0
@property (nonatomic, assign) NSInteger isNeedLunch;//
@property (nonatomic, strong) NSArray *breakfasts;
@property (nonatomic, strong) NSArray *lunchs;

@end
