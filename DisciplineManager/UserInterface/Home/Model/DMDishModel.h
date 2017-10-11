//
//  DMDishModel.h
//  DisciplineManager
//
//  Created by fujl-mac on 2017/10/11.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 "id": "1D9DE54469E44780ACE448CC3361A4BF",
 "createDate": "2017-09-19 13:33:03",
 "operatorDate": "2017-09-19 13:33:03",
 "operatorId": "b6256756-fc43-4a14-a8aa-89aaafdb9b26",
 "operatorName": "系统管理员",
 "delSign": 1,
 "optLock": 0,
 "dishesName": "绿豆腐",
 "type": 1,
 "week": 4,
 "imgPath": null,
 "searchTime": null
 
 */
@interface DMDishModel : NSObject

@property (nonatomic, copy) NSString *dishesId;
@property (nonatomic, copy) NSString *createDate;
@property (nonatomic, copy) NSString *operatorDate;
@property (nonatomic, copy) NSString *operatorId;
@property (nonatomic, copy) NSString *operatorName;
@property (nonatomic, assign) NSInteger delSign;
@property (nonatomic, assign) NSInteger optLock;
@property (nonatomic, copy) NSString *dishesName;
@property (nonatomic, assign) RepastType type;
@property (nonatomic, assign) NSInteger week;
@property (nonatomic, copy) NSString *imgPath;
@property (nonatomic, copy) NSString *searchTime;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
