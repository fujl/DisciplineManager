//
//  DMNoticeDetailController.h
//  DisciplineManager
//
//  Created by fujl-mac on 2017/10/16.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMLinearViewController.h"
#import "DMNoticeInfo.h"

@interface DMNoticeDetailController : DMLinearViewController

@property (nonatomic, strong) DMNoticeInfo *noticeInfo;
@property (nonatomic, assign) BOOL isReadSign;// 是否是已读

@end
