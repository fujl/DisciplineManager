//
//  DMBindPushRequester.h
//  DisciplineManager
//
//  Created by fujl-mac on 2017/8/2.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMHttpRequester.h"

@interface DMBindPushRequester : DMHttpRequester

@property (nonatomic, strong) NSString *channelId;

@end
