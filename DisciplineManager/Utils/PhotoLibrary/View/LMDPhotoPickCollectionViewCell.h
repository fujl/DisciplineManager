//
//  LMDPhotoPickCollectionViewCell.h
//  Doctor
//
//  Created by fujl-mac on 2017/6/2.
//  Copyright © 2017年 朗玛信息. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMDAssetModel.h"

@interface LMDPhotoPickCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) LMDAssetModel *model;
@property (nonatomic, assign) NSInteger item;
@property (nonatomic, copy) void(^imageClick)(NSInteger row);
@property (nonatomic, copy) void(^selectBlock)(NSInteger item);

- (void)recallIcon;
@end
