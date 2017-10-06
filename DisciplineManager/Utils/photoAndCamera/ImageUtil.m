//
//  ImageUtil.m
//  ImageFilter
//
//  Created by hgj on 9/18/12.
//  Copyright (c) 2012 Longmaster. All rights reserved.
//

#import "ImageUtil.h"
//#import "UIImage+YWKit.h"

@implementation ImageUtil

static CGContextRef CreateRGBABitmapContext (CGImageRef inImage, void *bitmapBuf)// 返回一个使用RGBA通道的位图上下文
{
	CGContextRef context = NULL;
	CGColorSpaceRef colorSpace;
//	void *bitmapData; //内存空间的指针，该内存空间的大小等于图像使用RGB通道所占用的字节数。
//	int bitmapByteCount;
	size_t bitmapBytesPerRow;
    
	size_t pixelsWide = CGImageGetWidth(inImage); //获取横向的像素点的个数
	size_t pixelsHigh = CGImageGetHeight(inImage); //纵向
    
	bitmapBytesPerRow	= (pixelsWide * 4); //每一行的像素点占用的字节数，每个像素点的ARGB四个通道各占8个bit(0-255)的空间
//	bitmapByteCount	= (bitmapBytesPerRow * pixelsHigh); //计算整张图占用的字节数
    
	colorSpace = CGColorSpaceCreateDeviceRGB();//创建依赖于设备的RGB通道
	
//	bitmapData = malloc(bitmapByteCount); //分配足够容纳图片字节数的内存空间
    
	context = CGBitmapContextCreate (bitmapBuf, pixelsWide, pixelsHigh, 8, bitmapBytesPerRow, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
//    context = CGBitmapContextCreate (NULL, pixelsWide, pixelsHigh, CGImageGetBitsPerComponent(inImage), 0,
//                                     CGImageGetColorSpace(inImage),
//                                     CGImageGetBitmapInfo(inImage));
    //创建CoreGraphic的图形上下文，该上下文描述了bitmaData指向的内存空间需要绘制的图像的一些绘制参数
//    free(bitmapData);
//    bitmapData = NULL;
	CGColorSpaceRelease(colorSpace);
    //Core Foundation中通过含有Create、Alloc的方法名字创建的指针，需要使用CFRelease()函数释放
	return context;
}

static unsigned char *RequestImagePixelData(UIImage *inImage, void *bitmapBuf)
// 返回一个指针，该指针指向一个数组，数组中的每四个元素都是图像上的一个像素点的RGBA的数值(0-255)，用无符号的char是因为它正好的取值范围就是0-255
{
	CGImageRef img = [inImage CGImage];
	CGSize size = [inImage size];
    
	CGContextRef cgctx = CreateRGBABitmapContext(img, bitmapBuf); //使用上面的函数创建上下文
	
	CGRect rect = {{0,0},{size.width, size.height}};
    
	CGContextDrawImage(cgctx, rect, img); //将目标图像绘制到指定的上下文，实际为上下文内的bitmapData。
	unsigned char *data = CGBitmapContextGetData (cgctx);
    
//    memcpy(bitmapBuf, (void *)data, (CGImageGetWidth(img) * 4 * CGImageGetHeight(img)));
	CGContextRelease(cgctx);//释放上面的函数创建的上下文
	return data;
}

+(CGAffineTransform)CaculateCorrectTransformation:(UIImage*) image
{
    //我们分两步来完成这项工作：
    //1:如果图片朝向为左/右/下，那么旋转到朝上的位置；
    //2:方向调整好后，如果图片被镜像过(当前图片看上去就像在镜子里一样),则反镜像之.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    //step1:旋转计算
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
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    //step2:反镜像计算
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
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    return transform;
}

+(UIImage*)AdjustOrientationToUpReturnNew:(UIImage*) image
{
    // 如果图片朝向正确(朝上)，则无需调整，直接返回
    if (image.imageOrientation == UIImageOrientationUp) return image;
    
    // 这里做适当的属性计算来调整图片，使其朝向变为正面朝上方向,这些参数将以transform变量得到
    CGAffineTransform transform = [ImageUtil CaculateCorrectTransformation:image];
    
    //下面开始基于上面计算出来的参数transform和当前错图，来重新构建一个正确的新图上下文
    CGContextRef ctx = CGBitmapContextCreate(NULL,
                                             image.size.width,
                                             image.size.height,
                                             CGImageGetBitsPerComponent(image.CGImage),
                                             0,
                                             CGImageGetColorSpace(image.CGImage),
                                             CGImageGetBitmapInfo(image.CGImage));
    
    //合并图形上下文和图形变换参数
    CGContextConcatCTM(ctx, transform);
    
    //绘制新图并加入图形上下文
    switch (image.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.height,image.size.width), image.CGImage);
            break;
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.width,image.size.height), image.CGImage);
            break;
    }
    
    //基于上面的图形上下文创建正确的图片
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *rightUpImage = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return rightUpImage;
}

static void changeRGBA(int *red,int *green,int *blue,int *alpha, const float* f)//修改RGB的值
{
    int redV = *red;
    int greenV = *green;
    int blueV = *blue;
    int alphaV = *alpha;
    
    *red = f[0] * redV + f[1] * greenV + f[2] * blueV + f[3] * alphaV + f[4];
    *green = f[0+5] * redV + f[1+5] * greenV + f[2+5] * blueV + f[3+5] * alphaV + f[4+5];
    *blue = f[0+5*2] * redV + f[1+5*2] * greenV + f[2+5*2] * blueV + f[3+5*2] * alphaV + f[4+5*2];
    *alpha = f[0+5*3] * redV + f[1+5*3] * greenV + f[2+5*3] * blueV + f[3+5*3] * alphaV + f[4+5*3];
    
    if (*red > 255)
    {
        *red = 255;
    }
    if(*red < 0)
    {
        *red = 0;
    }
    if (*green > 255)
    {
        *green = 255;
    }
    if (*green < 0)
    {
        *green = 0;
    }
    if (*blue > 255)
    {
        *blue = 255;
    }
    if (*blue < 0)
    {
        *blue = 0;
    }
    if (*alpha > 255)
    {
        *alpha = 255;
    }
    if (*alpha < 0)
    {
        *alpha = 0;
    }
}

+ (UIImage*)imageWithImage:(UIImage*)inImage withColorMatrix:(const float*)f withBitmapBuf:(void *)bitmapBuf
{
//    UIImage *iImage = [ImageUtil AdjustOrientationToUpReturnNew:inImage];
	unsigned char *imgPixel = RequestImagePixelData(inImage, bitmapBuf);
	CGImageRef inImageRef = [inImage CGImage];
	size_t w = CGImageGetWidth(inImageRef);
	size_t h = CGImageGetHeight(inImageRef);
	
	int wOff = 0;
	int pixOff = 0;
	
    
	for(GLuint y = 0;y< h;y++)//双层循环按照长宽的像素个数迭代每个像素点
	{
		pixOff = wOff;
		
		for (GLuint x = 0; x<w; x++)
		{
			int red = (unsigned char)imgPixel[pixOff];
			int green = (unsigned char)imgPixel[pixOff+1];
			int blue = (unsigned char)imgPixel[pixOff+2];
            int alpha = (unsigned char)imgPixel[pixOff+3];
            changeRGBA(&red, &green, &blue, &alpha, f);
            
            //回写数据
			imgPixel[pixOff] = red;
			imgPixel[pixOff+1] = green;
			imgPixel[pixOff+2] = blue;
            imgPixel[pixOff+3] = alpha;
            
            
			pixOff += 4; //将数组的索引指向下四个元素
		}
        
		wOff += w * 4;
	}
    
	NSInteger dataLength = w * h * 4;
    
    //下面的代码创建要输出的图像的相关参数
	CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, imgPixel, dataLength, NULL);
    
	int bitsPerComponent = 8;
	int bitsPerPixel = 32;
	size_t bytesPerRow = 4 * w;
	CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
	CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
	CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
	
	
	CGImageRef imageRef = CGImageCreate(w, h, bitsPerComponent, bitsPerPixel, bytesPerRow,colorSpaceRef, bitmapInfo, provider, NULL, NO, renderingIntent);//创建要输出的图像
	
    
	UIImage *myImage = [UIImage imageWithCGImage:imageRef];
    
    CGImageRelease(imageRef);
	CGColorSpaceRelease(colorSpaceRef);
	CGDataProviderRelease(provider);
    
	return myImage;
}

+ (UIImage *)drawImage:(UIImage *)backImage withSize:(CGSize)size frontImage:(UIImage *)frontImage inRect:(CGRect)rect
{
    UIGraphicsBeginImageContext(size);
    [backImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
    [frontImage drawInRect:rect];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)clipImage:(UIImage *)image inRect:(CGRect)rect
{
    CGImageRef sourceImageRef = [image CGImage];
    UIImageOrientation currentOrientation = image.imageOrientation;
    
    //begin add by lihuan,2012-12-25。截图时需要考虑方向性。
    CGRect newRect;
    if ( currentOrientation == UIImageOrientationUp || currentOrientation == UIImageOrientationUpMirrored ) {
        newRect=rect;
    } else if ( currentOrientation == UIImageOrientationDown || currentOrientation == UIImageOrientationDownMirrored ){
        newRect = CGRectMake(image.size.width - rect.size.width - rect.origin.x, image.size.height - rect.size.height - rect.origin.y, rect.size.width, rect.size.height);
    } else if ( currentOrientation == UIImageOrientationLeft || currentOrientation == UIImageOrientationLeftMirrored ){
        newRect = CGRectMake(image.size.height - rect.size.height - rect.origin.y, rect.origin.x, rect.size.height, rect.size.width);
    } else {
        //currentOrientation == UIImageOrientationRight || currentOrientation == UIImageOrientationRightMirrored
        newRect = CGRectMake(image.size.height - rect.origin.y - rect.size.height, rect.origin.x, rect.size.height, rect.size.width);
    }
    //end add by lihuan,2012-12-25。截图时需要考虑方向性。
    
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, newRect);
//    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef scale:1.0 orientation:currentOrientation];
    CGImageRelease(newImageRef);
//    UIImage *newImage = [UIImage imageWithCGImage:[newImage1 CGImage] scale:1.0 orientation:currentOrientation];
    return newImage;
}
//设置相册 选择的图片 大小
+ (UIImage *)compressImageToRect:(UIImage *)img withSize:(CGSize)imgSize
{
    UIGraphicsBeginImageContext(imgSize);
    [img drawInRect:CGRectMake(0, 0, imgSize.width+1, imgSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+(UIImage*) compressImageProportional:(UIImage *)imgDesc compressSize:(CGSize)compressSize
{
    /*为空直接返回*/
    if (!imgDesc) {
        return imgDesc;
    }
    //小于限定值，什么也不做
    if (imgDesc.size.width<=compressSize.width&&imgDesc.size.height<=compressSize.height)
        
    {
        //donothing;
    }
    //宽的比重大，把图片的宽顶满再进行等比缩放
    else if (imgDesc.size.width/compressSize.width>imgDesc.size.height/compressSize.height)
    {
        CGFloat imgScallingHeight=compressSize.width*imgDesc.size.height/imgDesc.size.width;
        imgDesc=[self imageByScalingProportionallyToSize:CGSizeMake(compressSize.width, imgScallingHeight) image:imgDesc];
    }
    //高的比重大，把图片的高顶满再进行等比缩放
    else
    {
        CGFloat imgScallingWidth=imgDesc.size.width*compressSize.height/imgDesc.size.height;
        imgDesc=[self imageByScalingProportionallyToSize:CGSizeMake(imgScallingWidth,compressSize.height) image:imgDesc];
        //imageView.contentMode=UIViewContentModeTop;
    }
	//imageView.image = img;
    return imgDesc;
}

+ (UIImage*) imageByScalingProportionallyToSize:(CGSize)targetSize image:(UIImage *)sourceImage {
    UIImage *newImage = nil;
    
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor < heightFactor)
            scaleFactor = widthFactor;
        else
            scaleFactor = heightFactor;
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        
        if (widthFactor < heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        } else if (widthFactor > heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    
    // this is actually the interesting part:
    
    UIGraphicsBeginImageContext(targetSize);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if(newImage == nil) NSLog(@"could not scale image");
    
    
    return newImage ;
}

+ (UIImage *) buildToThumbnail:(UIImage *)img withSize:(CGSize)imgSize
{
    BOOL isWidthMax = (img.size.width > img.size.height);
    CGFloat wOr =  isWidthMax ? img.size.height : img.size.width;
    
    UIGraphicsBeginImageContext(CGSizeMake(wOr, wOr));//根据当前大小创建一个基于位图图形的环境
    [[self clipImage:img inRect:CGRectMake(isWidthMax ? (img.size.width - wOr)/2.0f : 0, isWidthMax
                                           ?  0 : (img.size.height - wOr)/2.0f, wOr, wOr)] drawInRect:CGRectMake(0, 0, wOr, wOr)];//根据新的尺寸画出传过来的图片
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();//从当前环境当中得到重绘的图片
    
    UIGraphicsEndImageContext();//关闭当前环境
    
    UIImage *compressedImg = [self compressImageToRect:newImage withSize:imgSize];
    UIImage *cgImage = [UIImage imageWithCGImage:[compressedImg CGImage] scale:1.0 orientation:img.imageOrientation];
    
    return cgImage;
//    UIImage *iImage = [ImageUtil AdjustOrientationToUpReturnNew:cgImage];
//    return iImage;
}

@end
