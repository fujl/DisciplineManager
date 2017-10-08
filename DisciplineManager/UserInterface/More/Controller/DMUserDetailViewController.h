//
//  DMUserDetailViewController.h
//  DisciplineManager
//
//  Created by fujl-mac on 2017/7/27.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMLinearViewController.h"
#import "DMUserModel.h"

@interface DMUserDetailViewController : DMLinearViewController
@property (nullable, nonatomic, copy) void (^userAvatarChange)();
@property (nonatomic, strong) DMUserModel * _Nonnull user;
@end
