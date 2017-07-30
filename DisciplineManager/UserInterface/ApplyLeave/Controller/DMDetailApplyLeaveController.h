//
//  DMDetailApplyLeaveController.h
//  DisciplineManager
//
//  Created by fujl-mac on 2017/7/24.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMLinearViewController.h"
#import "DMActivitiTaskModel.h"

@interface DMDetailApplyLeaveController : DMLinearViewController
@property (nonatomic, strong) NSString *alId;
@property (nonatomic, strong) DMActivitiTaskModel *activitiTaskModel;
@end
