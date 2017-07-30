//
//  DMListBaseModel.h
//  DisciplineManager
//
//  Created by fujl-mac on 2017/6/29.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMListBaseModel : NSObject
@property (nonatomic, assign) NSInteger total;          //: 10,
@property (nonatomic, assign) NSInteger totalPage;      // 10,
@property (nonatomic, assign) NSInteger pageSize;       // 1

@property (nonatomic, strong) NSMutableArray *rows;
@end
