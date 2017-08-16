//
//  DMModifyPasswordRequester.h
//  DisciplineManager
//
//  Created by apple on 2017/8/16.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMHttpRequester.h"

@interface DMModifyPasswordRequester : DMHttpRequester

@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *nowPassword;

@end
