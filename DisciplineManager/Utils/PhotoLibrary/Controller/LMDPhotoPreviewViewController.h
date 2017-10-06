//
//  LMDPhotoPreviewViewController.h
//  Doctor
//
//  Created by fujl-mac on 2017/6/2.
//  Copyright © 2017年 朗玛信息. All rights reserved.
//

#import "DMBaseViewController.h"
#import "LMDAssetModel.h"

@interface LMDPhotoPreviewViewController : DMBaseViewController
@property (nonatomic, strong) NSMutableArray<LMDAssetModel *> *selectModels;
@property (nonatomic, assign) NSInteger currentShow;
@end
