//
//  DMSelectUserController.h
//  DisciplineManager
//
//  Created by apple on 2017/10/15.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMBaseViewController.h"

@interface DMSelectUserController : DMBaseViewController

@property (nonatomic, copy) void (^onSelectUserBlock)(NSMutableDictionary *userDict);

@end
