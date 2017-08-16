//
//  DMTaskTracksModel.h
//  DisciplineManager
//
//  Created by fujl-mac on 2017/7/24.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OperatorUser : NSObject

@property (nonatomic, assign) NSInteger oId;
@property (nonatomic, strong) NSString *createDate;
@property (nonatomic, strong) NSString *operatorDate;
@property (nonatomic, strong) NSString *operatorId;
@property (nonatomic, strong) NSString *operatorName;
@property (nonatomic, strong) DMUserInfo *userInfo;

- (instancetype)initWithDict:(NSDictionary *)dict;
@end

@interface DMTaskTracksModel : NSObject
@property (nonatomic, assign) NSInteger ttId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *definitionKey;
@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *endTime;
@property (nonatomic, assign) NSInteger durationInMillis;
@property (nonatomic, strong) NSString *durationInMillisFormat;
@property (nonatomic, assign) DMActivitiState status;

@property (nonatomic, strong) OperatorUser *operatorUser;

- (instancetype)initWithDict:(NSDictionary *)dict taskTracks:(BOOL)taskTracks;
@end
