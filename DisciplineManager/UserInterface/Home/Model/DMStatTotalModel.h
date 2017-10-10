//
//  DMStatTotalModel.h
//  DisciplineManager
//
//  Created by apple on 2017/10/10.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMStatTotalModel : NSObject

@property (nonatomic, assign) NSInteger needBreakfast;  // 早餐人数
@property (nonatomic, assign) NSInteger needLunch;  // 中餐人数
@property (nonatomic, assign) BOOL isSign;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
