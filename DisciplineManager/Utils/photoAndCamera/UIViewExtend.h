//
//  UIViewExtend.h
//  ipeng
//
//  Created by lihuan on 12-8-2.
//  Copyright (c) 2012年 longmaster. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIView(UIViewExtend) 

//重置视图X坐标。
- (void)setOriginX:(CGFloat)originX;
//重置视图Y坐标。
- (void)setOriginY:(CGFloat)originY;
//重置视图宽度。
- (void)setWidth:(CGFloat)width;
//重置视图高度。
- (void)setHeight:(CGFloat)height;
//重置视图坐标原点。
- (void)setOriginX:(CGFloat)originX withOriginY:(CGFloat)originY;
//重置视图大小。
- (void)setWidth:(CGFloat)width withHeight:(CGFloat)height;


// 垂直间隔。【 设置自身视图与topView视图的垂直间隔。】
- (void)setVerticalSpace:(int)vertical compareTopView:(UIView *)topView;
// 水平间隔。【 设置自身视图与leftView视图的水平间隔。】
- (void)setHorizontalSpace:(int)horizontal compareLeftView:(UIView *)leftView;


/****** 以下为动画效果 **************************************************************************************/

// 左移。【 以duration的时间向左移动pixels像素。】
-(void) moveLeft:(CGFloat)pixels animationDuration:(NSTimeInterval)duration;
// 右移。【 以duration的时间向左移动pixels像素。】
-(void) moveRight:(CGFloat)pixels animationDuration:(NSTimeInterval)duration;
// 上移。【 以duration的时间向左移动pixels像素。】
-(void) moveUp:(CGFloat)pixels animationDuration:(NSTimeInterval)duration;
// 下移。【 以duration的时间向左移动pixels像素。】
-(void) moveDown:(CGFloat)pixels animationDuration:(NSTimeInterval)duration;


// 左移一屏幕。【 以animationDuration的时间向左移动一屏幕。】
-(void) moveLeftOneScreen:(NSTimeInterval)animationDuration;
// 右移一屏幕。【 以animationDuration的时间向右移动一屏幕。】
-(void) moveRightOneScreen:(NSTimeInterval)animationDuration;
// 上移一屏幕。【 以animationDuration的时间向上移动一屏幕。】
-(void) moveUpOneScreen:(NSTimeInterval)animationDuration;
// 下移一屏幕。【以animationDuration的时间向下移动一屏幕。】
-(void) moveDownOneScreen:(NSTimeInterval)animationDuration;

- (void)fadeOut:(NSTimeInterval)duration;
- (void)fadeIn:(NSTimeInterval)duration;


//透明度。作者：pengjiaqi
-(void) changeViewAlpha:(NSTimeInterval)animationDuration ToAlphaValue:(float)toAlpha;

//未实现。
// 左边拉伸。【 以duration的时间让视图宽度向左增加pixels像素。】
- (void)elongateLeft:(CGFloat)pixels animationDuration:(NSTimeInterval)duration;
// 右边拉伸。【 以duration的时间让视图宽度向左增加pixels像素。】
- (void)elongateRight:(CGFloat)pixels animationDuration:(NSTimeInterval)duration;
// 顶部拉伸。【 以duration的时间让视图高度向上增加pixels像素。】
- (void)elongateTop:(CGFloat)pixels animationDuration:(NSTimeInterval)duration;
// 底部拉伸。【 以duration的时间让视图高度向下增加pixels像素。】
- (void)elongateBottom:(CGFloat)pixels animationDuration:(NSTimeInterval)duration;


//圆角。 【目前动画无效】
-(void)setCornerRadius:(CGFloat)cornerRadius animationDuration:(NSTimeInterval)duration;

//判断View是否在屏幕的可视区域
- (BOOL)isInVisibleView:(NSInteger)screenPages;
@end
