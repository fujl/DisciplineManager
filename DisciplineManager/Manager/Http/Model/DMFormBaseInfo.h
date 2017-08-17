//
//  DMFormBaseInfo.h
//  DisciplineManager
//
//  Created by fujl-mac on 2017/6/30.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DMTaskTracksModel.h"
#import "DMUserModel.h"

@interface DMFormBaseInfo : NSObject
@property (nonatomic, strong) NSString *formId;
@property (nonatomic, strong) NSString *reason;
@property (nonatomic, strong) NSString *createDate;
@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *endTime;
@property (nonatomic, assign) DMActivitiState state;
@property (nonatomic, assign) NSInteger processInstanceId;
@property (nonatomic, strong) NSMutableArray<DMTaskTracksModel *> *taskTracks;
@property (nonatomic, strong) DMUserModel *user;
- (instancetype)initWithDict:(NSDictionary *)dict;
@end
