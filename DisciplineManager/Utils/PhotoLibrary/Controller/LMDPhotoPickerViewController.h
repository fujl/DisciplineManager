//
//  LMDPhotoPickerViewController.h
//  Doctor
//
//  Created by fujl-mac on 2017/6/2.
//  Copyright © 2017年 朗玛信息. All rights reserved.
//

#import "DMBaseViewController.h"
#import "LMDAssetModel.h"

@interface LMDPhotoPickerViewController : DMBaseViewController
@property (nonatomic, assign) BOOL isFirstAppear;
@property (nonatomic, strong) LMDAlbumModel *album;
@property (nonatomic, assign) NSInteger columnNumber;
@property (nonatomic, strong) NSMutableArray *selectModels;
@property (nonatomic, assign) void(^refreshAlbum)(LMDAlbumModel *);
@end
