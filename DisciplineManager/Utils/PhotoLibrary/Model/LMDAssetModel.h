//
//  LMDAssetModel.h
//  Doctor
//
//  Created by fujl-mac on 2017/6/2.
//  Copyright © 2017年 朗玛信息. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

typedef NS_ENUM(NSUInteger, AssetModelType) {
    AssetModelTypePhoto = 0,
};
@class PHAsset;

@interface LMDAssetModel : NSObject
@property(nonatomic, strong) PHAsset *asset;
@property(nonatomic, assign) BOOL isselected;
@property(nonatomic, assign) AssetModelType type;

+ (instancetype)modelWithAsset:(PHAsset *)asset andType:(AssetModelType)type;

@end

@class PHFetchResult;

@interface LMDAlbumModel : NSObject
@property(nonatomic, strong) NSString *name;                //Album name
@property(nonatomic, assign) NSUInteger count;              //Album model number
@property(nonatomic, assign) NSUInteger selectedCount;       //selected count
@property(nonatomic, strong) NSArray *models;                 //models contained
@property(nonatomic, strong) NSMutableArray *selectModels;    //selected models
@property(nonatomic, strong) PHFetchResult *result;
@end
