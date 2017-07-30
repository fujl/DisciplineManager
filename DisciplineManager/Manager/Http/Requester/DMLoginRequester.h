//
//  DMLoginRequester.h
//  DisciplineManager
//
//  Created by fujl-mac on 2017/6/29.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMHttpRequester.h"

@interface DMLoginRequester : DMHttpRequester
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;
@end
