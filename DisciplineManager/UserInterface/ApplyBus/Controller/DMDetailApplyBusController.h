//
//  DMDetailApplyBusController.h
//  DisciplineManager
//
//  Created by fujl-mac on 2017/6/30.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMLinearViewController.h"
#import "DMActivitiTaskModel.h"

@interface DMDetailApplyBusController : DMLinearViewController
@property (nonatomic, strong) NSString *abId;
@property (nonatomic, strong) DMActivitiTaskModel *activitiTaskModel;
@end
