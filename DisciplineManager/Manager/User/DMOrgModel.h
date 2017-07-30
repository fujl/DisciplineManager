//
//  DMOrgModel.h
//  DisciplineManager
//
//  Created by fujl-mac on 2017/7/27.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 "id":"001001",
 "createDate":"2015-02-08 17:54:55",
 "operatorDate":"2017-04-25 17:08:34",
 "operatorId":"b6256756-fc43-4a14-a8aa-89aaafdb9b26",
 "operatorName":"系统管理员",
 "delSign":1,
 "optLock":1,
 "code":"001001",
 "name":"信息中心",
 "description":"",
 "parentId":"001",
 "type":0,
 "isLeaf":0,
 "isParent":false,
 "children":[
 
 ]
 */
@interface DMOrgModel : NSObject
@property (nonatomic, strong) NSString *orgId; // ":"001001",
@property (nonatomic, strong) NSString *createDate; // ":"2015-02-08 17:54:55",
@property (nonatomic, strong) NSString *operatorDate; // ":"2017-04-25 17:08:34",
@property (nonatomic, strong) NSString *operatorId; // ":"b6256756-fc43-4a14-a8aa-89aaafdb9b26",
@property (nonatomic, strong) NSString *operatorName; // ":"系统管理员",
@property (nonatomic, assign) NSInteger delSign; // ":1,
@property (nonatomic, assign) NSInteger optLock; // ":1,
@property (nonatomic, strong) NSString *code; // ":"001001",
@property (nonatomic, strong) NSString *name; // ":"信息中心",
@property (nonatomic, strong) NSString *descriptions; // ":"",
@property (nonatomic, strong) NSString *parentId; // ":"001",
@property (nonatomic, assign) NSInteger type; // ":0,
@property (nonatomic, assign) BOOL isLeaf; // ":0,
@property (nonatomic, assign) BOOL isParent; // ":false,

- (instancetype)initWithDict:(NSDictionary *)dict;
@end
