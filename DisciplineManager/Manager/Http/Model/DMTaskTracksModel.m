//
//  DMTaskTracksModel.m
//  DisciplineManager
//
//  Created by fujl-mac on 2017/7/24.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMTaskTracksModel.h"

@implementation OperatorUser

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.oId = [parseNumberFromObject([dict objectForKey:@"id"]) integerValue];
        self.createDate = parseStringFromObject([dict objectForKey:@"createDate"]);
        self.operatorDate = parseStringFromObject([dict objectForKey:@"operatorDate"]);
        self.operatorId = parseStringFromObject([dict objectForKey:@"operatorId"]);
        self.operatorName = parseStringFromObject([dict objectForKey:@"operatorName"]);
    }
    return self;
}
@end

@implementation DMTaskTracksModel

- (instancetype)initWithDict:(NSDictionary *)dict  taskTracks:(BOOL)taskTracks {
    self = [super init];
    if (self) {
        if (taskTracks) {
            self.ttId = [parseNumberFromObject([dict objectForKey:@"id"]) integerValue];
            self.name = parseStringFromObject([dict objectForKey:@"name"]);
            self.message = parseStringFromObject([dict objectForKey:@"message"]);
            self.endTime = parseStringFromObject([dict objectForKey:@"endTime"]);
        } else {
            self.ttId = [parseNumberFromObject([dict objectForKey:@"taskId"]) integerValue];
            self.name = parseStringFromObject([dict objectForKey:@"taskName"]);
            self.message = parseStringFromObject([dict objectForKey:@"fullMessage"]);
            self.endTime = parseStringFromObject([dict objectForKey:@"time"]);
        }
        
        self.definitionKey = parseStringFromObject([dict objectForKey:@"definitionKey"]);
        self.startTime = parseStringFromObject([dict objectForKey:@"startTime"]);
        
        self.durationInMillis = [parseNumberFromObject([dict objectForKey:@"durationInMillis"]) integerValue];
        self.durationInMillisFormat = parseStringFromObject([dict objectForKey:@"durationInMillisFormat"]);
        self.status = [parseNumberFromObject([dict objectForKey:@"status"]) integerValue];
        
        self.operatorUser = [[OperatorUser alloc] initWithDict:[dict objectForKey:@"user"]];
    }
    return self;
}

@end
