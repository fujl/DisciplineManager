//
//  DMVoteListInfo.h
//  DisciplineManager
//
//  Created by fujl-mac on 2017/10/9.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 "id":"4B1C45664AAA4F468F8BC84F4641464E",
 "createDate":"2017-10-06 21:05:21",
 "operatorDate":"2017-10-07 01:06:52",
 "operatorId":"F55B27AD03034815A854B85EA53FC403",
 "operatorName":"APP测试",
 "delSign":0,
 "optLock":null,
 "title":"s j j s k d k x 显瘦圆领",
 "user":null,
 "orgCode":null,
 "type":1,
 "endTime":"2017-10-06 21:16",
 "options":[
 
 ],
 "userId":"F55B27AD03034815A854B85EA53FC403",
 "offset":0,
 "limit":0,
 "total":2,
 "name":"APP测试",
 "face":"/upload/face/images/201710091101233150.jpg",
 "isEnd":true,
 "myTicket":0,
 "timeTxt":"2天前"
 */

@interface DMVoteListInfo : NSObject

@property (nonatomic, copy) NSString *vlId;
@property (nonatomic, copy) NSString *createDate;//":"2017-10-06 21:05:21",
@property (nonatomic, copy) NSString *operatorDate;//":"2017-10-07 01:06:52",
@property (nonatomic, copy) NSString *operatorId;//":"F55B27AD03034815A854B85EA53FC403",
@property (nonatomic, copy) NSString *operatorName;//":"APP测试",
@property (nonatomic, assign) NSInteger delSign;//":0,
@property (nonatomic, copy) NSString *optLock;//":null,
@property (nonatomic, copy) NSString *title;//":"s j j s k d k x 显瘦圆领",
@property (nonatomic, copy) NSString *user;//":null,
@property (nonatomic, copy) NSString *orgCode;//":null,
@property (nonatomic, assign) NSInteger type;//":1,
@property (nonatomic, copy) NSString *endTime;//":"2017-10-06 21:16"

@property (nonatomic, copy) NSString *userId;//":"F55B27AD03034815A854B85EA53FC403",
@property (nonatomic, assign) NSInteger offset;//":0,
@property (nonatomic, assign) NSInteger limit;//":0,
@property (nonatomic, assign) NSInteger total;//":2,
@property (nonatomic, copy) NSString *name;//":"APP测试",
@property (nonatomic, copy) NSString *face;//":"/upload/face/images/201710091101233150.jpg",
@property (nonatomic, assign) BOOL isEnd;//":true,
@property (nonatomic, assign) NSInteger myTicket;//":0, 判断是否已经投票, 大于0 已经投票
@property (nonatomic, copy) NSString *timeTxt;//":"2天前"

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
