//
//  LMDAssetModel.m
//  Doctor
//
//  Created by fujl-mac on 2017/6/2.
//  Copyright © 2017年 朗玛信息. All rights reserved.
//

#import "LMDAssetModel.h"

@implementation LMDAssetModel
+ (instancetype)modelWithAsset:(PHAsset *)asset andType:(AssetModelType)type {
    LMDAssetModel *model = [[LMDAssetModel alloc] init];
    model.asset = asset;
    model.type = type;
    model.isselected = NO;
    return model;
}
@end

@implementation LMDAlbumModel

- (void)setResult:(PHFetchResult *)result {
    _result = result;
    [self getAssetsFromFetchResult:result completion:^(NSArray<LMDAssetModel *> *models) {
        _models = models;
    }];
}

- (void)getAssetsFromFetchResult:(PHFetchResult *)result completion:(void (^)(NSArray<LMDAssetModel *> *))completion {
    NSMutableArray *assets = [[NSMutableArray alloc] init];
    [result enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        PHAsset *asset = obj;
        LMDAssetModel *model = [LMDAssetModel modelWithAsset:asset andType:AssetModelTypePhoto];
        [assets addObject:model];
    }];
    
    if (completion) {
        completion(assets);
    }
}

@end
