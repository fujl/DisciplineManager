//
//  ImageUtil.h
//  ImageFilter
//
//  Created by hgj on 9/18/12.
//  Copyright (c) 2012 Longmaster. All rights reserved.
//

#ifndef IMAGEUTIL_H
#define IMAGEUTIL_H

#import <Foundation/Foundation.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

@interface ImageUtil : NSObject

+ (UIImage*)imageWithImage:(UIImage*)inImage withColorMatrix:(const float*)f withBitmapBuf:(void *)bitmapBuf;
+ (CGAffineTransform)CaculateCorrectTransformation:(UIImage*) image;
+ (UIImage*)AdjustOrientationToUpReturnNew:(UIImage*) image;
+ (UIImage *)drawImage:(UIImage *)backImage withSize:(CGSize)size frontImage:(UIImage *)frontImage inRect:(CGRect)rect;
+ (UIImage *)clipImage:(UIImage *)image inRect:(CGRect)rect;
+ (UIImage *)compressImageToRect:(UIImage *)img withSize:(CGSize)imgSize;
// 等比缩放
+ (UIImage *)compressImageProportional:(UIImage *)imgDesc compressSize:(CGSize)compressSize;
+ (UIImage *) buildToThumbnail:(UIImage *)img withSize:(CGSize)imgSize;
@end

#endif