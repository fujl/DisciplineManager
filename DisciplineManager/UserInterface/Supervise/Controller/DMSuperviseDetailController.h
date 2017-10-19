//
//  DMSuperviseDetailController.h
//  DisciplineManager
//
//  Created by apple on 2017/10/19.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMLinearViewController.h"
#import "DMActivitiTaskModel.h"

@interface DMSuperviseDetailController : DMLinearViewController

@property (nonatomic, strong) NSString *slId;
@property (nonatomic, strong) DMActivitiTaskModel *activitiTaskModel;

@end
