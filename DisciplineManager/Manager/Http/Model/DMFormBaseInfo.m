//
//  DMFormBaseInfo.m
//  DisciplineManager
//
//  Created by fujl-mac on 2017/6/30.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMFormBaseInfo.h"

@implementation DMFormBaseInfo

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.formId = [dict objectForKey:@"id"];
        self.createDate = [dict objectForKey:@"createDate"];
        self.reason = [dict objectForKey:@"reason"];
        self.startTime = [dict objectForKey:@"startTime"];
        self.endTime = parseStringFromObject([dict objectForKey:@"endTime"]);
        self.state = [[dict objectForKey:@"state"] integerValue];
        self.processInstanceId = [[dict objectForKey:@"processInstanceId"] integerValue];
        
        self.taskTracks = [[NSMutableArray alloc] init];
        
        if (self.state > ACTIVITI_STATE_SAVE) {
            NSArray *tracks = !(self.state == ACTIVITI_STATE_COMPLETE || self.state == ACTIVITI_STATE_REJECTED) ? [dict objectForKey:@"taskTracks"] : [dict objectForKey:@"hiTasks"];
            for (NSDictionary *dic in tracks) {
                DMTaskTracksModel *ttModel = [[DMTaskTracksModel alloc] initWithDict:dic taskTracks:!(self.state == ACTIVITI_STATE_COMPLETE || self.state == ACTIVITI_STATE_REJECTED)];
                [self.taskTracks addObject:ttModel];
            }
        }
        self.user = [[DMUserModel alloc] initWithDict:[dict objectForKey:@"user"]];
    }
    return self;
}

@end
