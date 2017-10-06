//
//  LMDPhotoPreviewCollectionViewCell.h
//  Doctor
//
//  Created by fujl-mac on 2017/6/2.
//  Copyright © 2017年 朗玛信息. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMDAssetModel.h"
#import "LMDPhotosManager.h"

@interface LMDPhotoPreviewCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) LMDAssetModel *model;
@property (nonatomic, copy) void(^singleImageBlock)();
- (void)recoverSubViews;
@end
