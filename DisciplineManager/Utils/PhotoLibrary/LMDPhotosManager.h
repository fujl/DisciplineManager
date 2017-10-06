//
//  LMDPhotosManager.h
//  Doctor
//
//  Created by fujl-mac on 2017/6/2.
//  Copyright © 2017年 朗玛信息. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "LMDAssetModel.h"

@interface LMDPhotosManager : NSObject
+ (instancetype)sharedInstance;

#pragma mark get Albums
- (void)getCameraRollAlbumWithCompletion:(void (^)(LMDAlbumModel *))completion;
- (void)getAllAlbumsWithCompletion:(void (^)(NSMutableArray<LMDAlbumModel *> *))completion;

- (void)getPostImageWithAlbumModel:(LMDAlbumModel *)model completion:(void (^)(UIImage *))completion;

- (PHImageRequestID)getPhotoWithAsset:(id)asset completion:(void (^)(UIImage *, NSDictionary *, BOOL))completion;
- (void)getOriginalPhotoDataWithAsset:(id)asset completion:(void (^)(NSData *, NSDictionary *))completion;
- (void)writeToFileWithArray:(NSArray *)images andCompletion:(void (^)(NSArray *))completion;
@end
