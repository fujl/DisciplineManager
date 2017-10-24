//
//  DMExhMostModel.h
//  DisciplineManager
//
//  Created by apple on 2017/10/14.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMAttrModel : NSObject

@property (nonatomic, copy) NSString *emId;
@property (nonatomic, copy) NSString *path;
@property (nonatomic, assign) NSInteger number;
@property (nonatomic, assign) NSInteger optLock;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end

@interface DMExhMostModel : NSObject

@property (nonatomic, copy) NSString *content;
@property (nonatomic, strong) NSMutableArray<DMAttrModel *> *attrs;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
