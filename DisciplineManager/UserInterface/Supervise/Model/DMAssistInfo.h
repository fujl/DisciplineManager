//
//  DMAssistInfo.h
//  DisciplineManager
//
//  Created by apple on 2017/10/19.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMAssistInfo : NSObject

@property (nonatomic, copy) NSString *assistId;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger optLock;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
