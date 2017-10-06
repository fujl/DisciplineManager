//
//  DMNewsInfoModel.h
//  DisciplineManager
//
//  Created by fujl-mac on 2017/7/22.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMNewsInfoModel : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, assign) NSInteger read;

@property (nonatomic, strong) NSString *url;
@property (nonatomic, assign) NSTimeInterval createDate;

- (instancetype)initWithDict:(NSDictionary *)dict;
@end
