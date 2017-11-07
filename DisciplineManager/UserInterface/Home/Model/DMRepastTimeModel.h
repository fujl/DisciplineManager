//
//  DMRepastTimeModel.h
//  DisciplineManager
//
//  Created by apple on 2017/10/10.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMRepastTimeModel : NSObject

@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *datetime;
@property (nonatomic, assign) NSInteger endHour;
@property (nonatomic, assign) NSInteger week;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
