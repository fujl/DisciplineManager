//
//  DMLinearViewController.h
//  DisciplineManager
//
//  Created by fujl on 2017/1/10.
//  Copyright © 2017年 fujl. All rights reserved.
//

#import "DMBaseViewController.h"

/**
 * UIView 增加边距
 */
@interface UIView (DMLinearViewControllerMargin)

@property(nonatomic) CGFloat lcTopMargin; // 顶部边距
@property(nonatomic) CGFloat lcLeftMargin; // 左边距
@property(nonatomic) CGFloat lcRightMargin; // 有边距
@property(nonatomic) CGFloat lcBottomMargin; // 底边距

@end

@interface UIView (DMLinearViewControllerSize)

@property(nonatomic) CGFloat lcHeight; // 高度 默认-1，不添加约束
@property(nonatomic) CGFloat lcWidth; // 宽度 默认-1 不添加约束å

@end

/**
 * 布局对齐方式
 */
typedef NS_ENUM(NSInteger, DMLinearViewControllerGravity) {
    DMLinearViewControllerGravityStart,    //头
    DMLinearViewControllerGravityEnd,      //尾部对齐
    DMLinearViewControllerGravityCenter,   //居中
    DMLinearViewControllerGravityFit,      //充满
};

@interface DMLinearViewController : DMBaseViewController

/** 对齐方式 */
@property(nonatomic) DMLinearViewControllerGravity gravity;

@property(nonatomic, readonly) NSMutableArray<__kindof UIView *> *childViewList;

@property(nonatomic, strong) UIScrollView *scrollView;

/**
 * 获取子View
 * @param index view索引
 * @return view
 */
- (__kindof UIView *)getChildViewAtIndex:(NSUInteger)index;

- (NSUInteger)childViewCount;

- (void)removeChildViewAtIndex:(NSUInteger)index;

- (void)addChildView:(UIView *)child;

- (void)addChildView:(UIView *)child atIndex:(NSUInteger)index;

- (void)addChildViews:(NSArray<__kindof UIView *> *)views;

- (void)setChildViews:(NSArray<__kindof UIView *> *)views;

- (void)reloadViews;


@end
