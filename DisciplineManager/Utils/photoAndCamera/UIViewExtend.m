//
//  UIViewExtend.m
//  ipeng
//
//  Created by lihuan on 12-8-2.
//  Copyright (c) 2012年 longmaster. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "UIViewExtend.h"

@implementation UIView(UIViewExtend)

#pragma mark -
#pragma mark 非动画效果（设值+增值）
#pragma mark 设值：

//重置视图X坐标。
- (void)setOriginX:(CGFloat)OriginX{
    self.frame=CGRectMake(OriginX, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}

//重置视图Y坐标。
- (void)setOriginY:(CGFloat)OriginY{
    self.frame=CGRectMake(self.frame.origin.x, OriginY, self.frame.size.width, self.frame.size.height);
}

//重置视图宽度。
- (void)setWidth:(CGFloat)width{
    self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, width, self.frame.size.height);
}

//重置视图高度。
- (void)setHeight:(CGFloat)height{
    self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height);
}


//重置视图坐标原点。
- (void)setOriginX:(CGFloat)originX withOriginY:(CGFloat)originY {
    self.frame=CGRectMake(originX, originY, self.frame.size.width, self.frame.size.height);
}

//重置视图大小。
- (void)setWidth:(CGFloat)width withHeight:(CGFloat)height {
    self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, width, height);
}


//设置自身视图与topView视图的垂直间隔。
- (void)setVerticalSpace:(int)vertical compareTopView:(UIView *)topView {
    [self setOriginY:topView.frame.origin.y+topView.frame.size.height+vertical];
}

//设置自身视图与leftView视图的水平间隔。
- (void)setHorizontalSpace:(int)horizontal compareLeftView:(UIView *)leftView{
    [self setOriginX:leftView.frame.origin.x+leftView.frame.size.width+horizontal];
}



#pragma mark -
#pragma mark 动画效果（移动+拉伸）
#pragma mark 移动：

//向左移动pixels像素。
-(void) moveLeft:(CGFloat)pixels animationDuration:(NSTimeInterval)duration{
    [UIView animateWithDuration:duration animations:^{[self setOriginX:self.frame.origin.x-pixels];}];
}

//向右移动pixels像素。
-(void) moveRight:(CGFloat)pixels animationDuration:(NSTimeInterval)duration{
    [UIView animateWithDuration:duration animations:^{[self setOriginX:self.frame.origin.x+pixels];}];
}


//向上移动pixels像素。
-(void) moveUp:(CGFloat)pixels animationDuration:(NSTimeInterval)duration{
    [UIView animateWithDuration:duration animations:^{[self setOriginY:self.frame.origin.y-pixels];}];
}


//向下移动pixels像素。
-(void) moveDown:(CGFloat)pixels animationDuration:(NSTimeInterval)duration{
    [UIView animateWithDuration:duration animations:^{[self setOriginY:self.frame.origin.y+pixels];}];
}


//向左移动一屏幕。
-(void) moveLeftOneScreen:(NSTimeInterval)animationDuration{
    [self moveLeft:[UIScreen mainScreen].bounds.size.width animationDuration:animationDuration];
}


//向右移动一屏幕。
-(void) moveRightOneScreen:(NSTimeInterval)animationDuration{
    [self moveRight:[UIScreen mainScreen].bounds.size.width animationDuration:animationDuration];
}


//向上移动一屏幕。
-(void) moveUpOneScreen:(NSTimeInterval)animationDuration{
    [self moveUp:[UIScreen mainScreen].bounds.size.height animationDuration:animationDuration];
}


//向下移动一屏幕。
-(void) moveDownOneScreen:(NSTimeInterval)animationDuration{
    [self moveDown:[UIScreen mainScreen].bounds.size.height animationDuration:animationDuration];
}

#pragma mark - 隐藏和显示
- (void)fadeOut:(NSTimeInterval)duration
{
    [UIView animateWithDuration:duration animations:^{
        self.layer.opacity = 1.0f;
    }];
}

- (void)fadeIn:(NSTimeInterval)duration
{
    [UIView animateWithDuration:duration animations:^{
        self.layer.opacity = 0.0f;
    }];
}

#pragma mark 透明度：

-(void) changeViewAlpha:(NSTimeInterval)animationDuration ToAlphaValue:(float)toAlpha{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.alpha = toAlpha;
    [UIView commitAnimations];                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
}

#pragma mark 拉伸：

//让视图左部平滑延伸pixels像素。
- (void)elongateLeft:(CGFloat)pixels animationDuration:(NSTimeInterval)duration{
    
}

//让视图右部平滑延伸pixels像素。
- (void)elongateRight:(CGFloat)pixels animationDuration:(NSTimeInterval)duration{
    
}

//让视图顶部平滑延伸pixels像素。
- (void)elongateTop:(CGFloat)pixels animationDuration:(NSTimeInterval)duration{
    
}


//让视图底部平滑延伸pixels像素。
- (void)elongateBottom:(CGFloat)pixels animationDuration:(NSTimeInterval)duration{
    
}

#pragma mark 圆角：
-(void)setCornerRadius:(CGFloat)cornerRadius animationDuration:(NSTimeInterval)duration{
    //    [UIView beginAnimations:@"UIViewExtendMoveDown" context:NULL];
    //    [UIView setAnimationBeginsFromCurrentState:YES];
    //    [UIView setAnimationDuration:duration];
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
    //    [UIView commitAnimations];
}

- (BOOL)isInVisibleView:(NSInteger)screenPages
{
    assert(screenPages > 0);
    CGPoint absolutePoint = [self convertPoint:self.frame.origin toView:nil];
    if (screenPages * SCREEN_HEIGHT < absolutePoint.y || - (SCREEN_HEIGHT * (screenPages - 1)) > absolutePoint.y) {
        return NO; 
    }
    return YES;
}

@end
