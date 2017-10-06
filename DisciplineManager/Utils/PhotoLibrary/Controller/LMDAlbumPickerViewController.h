//
//  LMDAlbumPickerViewController.h
//  Doctor
//
//  Created by fujl-mac on 2017/6/2.
//  Copyright © 2017年 朗玛信息. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMDAssetModel.h"

@class LMDAlbumPickerViewController;
@protocol LMDImagePickerDelegate <NSObject>

@optional
- (void)imagePickerController:(LMDAlbumPickerViewController *)picker didFinishPickingPhotos:(NSArray<NSString *> *)photos;
- (void)imagePickerController:(LMDAlbumPickerViewController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets;
- (void)imagePickerController:(LMDAlbumPickerViewController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets infos:(NSArray<NSDictionary *> *)infos;
- (void)imagePickerControllerDidCancel:(LMDAlbumPickerViewController *)picker;
@end

@interface LMDAlbumPickerViewController : UINavigationController

// Use this init method
- (instancetype)initWithMaxImagesCount:(NSInteger)maxImagesCount delegate:(id<LMDImagePickerDelegate>)delegate;
- (instancetype)initWithMaxImagesCount:(NSInteger)maxImagesCount columnNumber:(NSInteger)columnNumber delegate:(id<LMDImagePickerDelegate>)delegate;
- (instancetype)initWithMaxImagesCount:(NSInteger)maxImagesCount columnNumber:(NSInteger)columnNumber delegate:(id<LMDImagePickerDelegate>)delegate pushPhotoPickerVC:(BOOL)pushPhotoPickerVC;

#pragma mark -- properties
@property (nonatomic, assign) NSInteger maxImageNumber;
@property (nonatomic, assign) NSInteger minImageNumber;
@property (nonatomic, assign) NSInteger leftNumber;

@property (nonatomic, assign) NSInteger pixelWidth;    //想要的图片的宽，单位像素，暂时只传图片原比例
@property (nonatomic, assign) NSInteger pixelHeight;

@property (nonatomic, assign) BOOL sortByIncreaseWithModifyDate;
@property (nonatomic, assign) NSInteger photoMaxWidth;

@property (nonatomic, strong) NSArray *selectedAssets;
@property (nonatomic, strong) NSMutableArray<LMDAssetModel *> *selectedModels;

@property (nonatomic, weak)id<LMDImagePickerDelegate> pickerDelegate;
@end

@interface LMDAlbumListViewController : DMBaseViewController
@property (nonatomic, assign) NSInteger columnNumber;
@property (nonatomic, strong) LMDAlbumModel *refreshModel;
@end
