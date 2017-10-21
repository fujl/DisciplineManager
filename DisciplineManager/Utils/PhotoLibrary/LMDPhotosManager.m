//
//  LMDPhotosManager.m
//  Doctor
//
//  Created by fujl-mac on 2017/6/2.
//  Copyright © 2017年 朗玛信息. All rights reserved.
//

#import "LMDPhotosManager.h"

@implementation LMDPhotosManager

+ (instancetype)sharedInstance {
    static LMDPhotosManager *shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[[self class] alloc] init];
    });
    return shareInstance;
}

#pragma mark get Albums

- (void)getCameraRollAlbumWithCompletion:(void (^)(LMDAlbumModel *))completion {
    __block LMDAlbumModel *model;
    //设置设置
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    //设置请求的数据类型
    option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
    //设置排序，按修改时间，升序
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    for (PHAssetCollection *result in smartAlbums) {
        if (![result isKindOfClass:[PHAssetCollection class]]) continue;
        if ([self isCameraRollAlbum:result.localizedTitle]) {
            PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:result options:option];
            model = [self modelWithResult:fetchResult name:result.localizedTitle];
            if (completion) completion(model);
            break;
        }
    }
}

- (void)getAllAlbumsWithCompletion:(void (^)(NSMutableArray<LMDAlbumModel *> *))completion {
    __block NSMutableArray *models = [NSMutableArray array];
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    //设置请求的数据类型
    option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
    //设置排序，按修改时间，升序
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    PHFetchResult *ituneAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAny options:nil];
    PHFetchResult *topLevelCollection = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    for (PHAssetCollection *collection in smartAlbums) {
        // 有可能是PHCollectionList类的的对象，过滤掉
        if (![collection isKindOfClass:[PHAssetCollection class]]) continue;
        PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:option];
        if (fetchResult.count < 1) continue;
        if ([collection.localizedTitle containsString:@"Deleted"] || [collection.localizedTitle isEqualToString:@"最近删除"]) continue;
        if ([self isCameraRollAlbum:collection.localizedTitle]) {
            [models insertObject:[self modelWithResult:fetchResult name:collection.localizedTitle] atIndex:0];
        } else {
            [models addObject:[self modelWithResult:fetchResult name:collection.localizedTitle]];
        }
    }
    for (PHAssetCollection *collection in ituneAlbums) {
        // 有可能是PHCollectionList类的的对象，过滤掉
        if (![collection isKindOfClass:[PHAssetCollection class]]) continue;
        PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:option];
        if (fetchResult.count < 1) continue;
        if ([collection.localizedTitle containsString:@"Deleted"] || [collection.localizedTitle isEqualToString:@"最近删除"]) continue;
        if ([self isCameraRollAlbum:collection.localizedTitle]) {
            [models insertObject:[self modelWithResult:fetchResult name:collection.localizedTitle] atIndex:0];
        } else {
            [models addObject:[self modelWithResult:fetchResult name:collection.localizedTitle]];
        }
    }
    for (PHAssetCollection *collection in topLevelCollection) {
        // 有可能是PHCollectionList类的的对象，过滤掉
        if (![collection isKindOfClass:[PHAssetCollection class]]) continue;
        PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:option];
        if (fetchResult.count < 1) continue;
        [models addObject:[self modelWithResult:fetchResult name:collection.localizedTitle]];
    }
    
    if (completion && models.count > 0) completion(models);
    
}

//判断来源
- (BOOL)isCameraRollAlbum:(NSString *)albumName {
    NSString *versionStr = [[UIDevice currentDevice].systemVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
    if (versionStr.length <= 1) {
        versionStr = [versionStr stringByAppendingString:@"00"];
    } else if (versionStr.length <= 2) {
        versionStr = [versionStr stringByAppendingString:@"0"];
    }
    CGFloat version = versionStr.floatValue;
    // 目前已知8.0.0 - 8.0.2系统，拍照后的图片会保存在最近添加中
    if (version >= 800 && version <= 802) {
        return [albumName isEqualToString:@"最近添加"] || [albumName isEqualToString:@"Recently Added"];
    } else {
        return [albumName isEqualToString:@"Camera Roll"] || [albumName isEqualToString:@"相机胶卷"] || [albumName isEqualToString:@"所有照片"] || [albumName isEqualToString:@"All Photos"];
    }
}

- (LMDAlbumModel *)modelWithResult:(PHFetchResult *)result name:(NSString *)name {
    LMDAlbumModel *model = [[LMDAlbumModel alloc] init];
    model.result = result;
    model.name = name;
    model.selectModels = [NSMutableArray array];
    if ([result isKindOfClass:[PHFetchResult class]]) {
        PHFetchResult *fetchResult = (PHFetchResult *) result;
        model.count = fetchResult.count;
    }
    return model;
}

#pragma mark get photo
- (void)getPostImageWithAlbumModel:(LMDAlbumModel *)model completion:(void (^)(UIImage *))completion {
    id asset = model.result.lastObject;
    
    [[LMDPhotosManager sharedInstance] getPhotoWithAsset:asset completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
        if (completion) {
            completion(photo);
        }
    }];
}

- (PHImageRequestID)getPhotoWithAsset:(id)asset completion:(void (^)(UIImage *, NSDictionary *, BOOL))completion {
    ///剪辑宽度
    CGFloat fullScreenWidth = SCREEN_WIDTH;
    return [self getPhotoWithAsset:asset photoWidth:fullScreenWidth completion:completion];
}

- (void)getOriginalPhotoDataWithAsset:(id)asset completion:(void (^)(NSData *, NSDictionary *))completion {
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.networkAccessAllowed = YES;
    [[PHImageManager defaultManager] requestImageDataForAsset:asset options:option resultHandler:^(NSData *_Nullable imageData, NSString *_Nullable dataUTI, UIImageOrientation orientation, NSDictionary *_Nullable info) {
        BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey]);
        if (downloadFinined && imageData) {
            if (completion) completion(imageData, info);
        }
    }];
}

- (PHImageRequestID)getPhotoWithAsset:(id)asset photoWidth:(CGFloat)photoWidth completion:(void (^)(UIImage *, NSDictionary *, BOOL))completion {
    PHAsset *phasset = (PHAsset *) asset;
    CGSize imageSize;
    CGFloat aspectRatio = (CGFloat) phasset.pixelWidth / (CGFloat) phasset.pixelHeight;
    CGFloat pixelHeight = photoWidth / aspectRatio;
    imageSize = CGSizeMake(photoWidth, pixelHeight);
    
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.resizeMode = PHImageRequestOptionsResizeModeFast;
    PHImageRequestID imageRequestID = [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:imageSize contentMode:PHImageContentModeAspectFill options:option resultHandler:^(UIImage *_Nullable result, NSDictionary *_Nullable info) {
        BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey]);
        if (downloadFinined && result) {
            result = [self fixOrientation:result];
            if (completion) completion(result, info, [[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
        }
        // Download image from iCloud / 从iCloud下载图片
        if ([info objectForKey:PHImageResultIsInCloudKey] && !result) {
            PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
            option.networkAccessAllowed = YES;
            option.resizeMode = PHImageRequestOptionsResizeModeFast;
            [[PHImageManager defaultManager] requestImageDataForAsset:asset options:option resultHandler:^(NSData *_Nullable imageData, NSString *_Nullable dataUTI, UIImageOrientation orientation, NSDictionary *_Nullable info) {
                UIImage *resultImage = [UIImage imageWithData:imageData scale:0.1];
                resultImage = [self scaleImage:resultImage toSize:imageSize];
                if (resultImage) {
                    resultImage = [self fixOrientation:resultImage];
                    if (completion) completion(resultImage, info, [[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
                }
            }];
        }
    }];
    return imageRequestID;
}

- (void)writeToFileWithArray:(NSArray *)images andCompletion:(void (^)(NSArray *))completion {
    NSString *tmpDir = NSTemporaryDirectory();
    tmpDir = [tmpDir stringByAppendingString:@"GetImageCache"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:tmpDir]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:tmpDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSMutableArray *paths = [NSMutableArray array];
    dispatch_queue_t queue = dispatch_queue_create("imageWrite", NULL);
    for (NSData *image in images) {
        NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
        NSString *date = [NSString stringWithFormat:@"%f", time * 1000];
        int a = 0;
        for (int i = 0; i < 10; i++) {
            a = a * 10 + arc4random_uniform(10);
        }
        NSString *imagePath = [tmpDir stringByAppendingString:[NSString stringWithFormat:@"/%@%d.jpg", date, a]];
        dispatch_sync(queue, ^{
            [[self conpressImage:image] writeToFile:imagePath atomically:NO];
            [paths addObject:imagePath];
            if (paths.count == images.count) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (completion) {
                        completion(paths);
                    }
                });
            }
        });
    }
}

- (NSData *)conpressImage:(NSData *)data {
    UIImage *nextImage = [UIImage imageWithData:data];
    return UIImageJPEGRepresentation(nextImage, 0.7);
}

#pragma mark cut image
- (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)size {
    if (image.size.width > size.width) {
        UIGraphicsBeginImageContext(size);
        [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImage;
    } else {
        return image;
    }
}

#pragma mark rotate image
- (UIImage *)fixOrientation:(UIImage *)image {
    //    if (!self.shouldFixOrientation) return image;
    
    // No-op if the orientation is already correct
    if (image.imageOrientation == UIImageOrientationUp)
        return image;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (image.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, image.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, image.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (image.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, image.size.width, image.size.height,
                                             CGImageGetBitsPerComponent(image.CGImage), 0,
                                             CGImageGetColorSpace(image.CGImage),
                                             CGImageGetBitmapInfo(image.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (image.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0, 0, image.size.height, image.size.width), image.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0, 0, image.size.width, image.size.height), image.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

@end
