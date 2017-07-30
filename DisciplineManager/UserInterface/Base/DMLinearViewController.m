//
//  DMLinearViewController.m
//  DisciplineManager
//
//  Created by fujl on 2017/1/10.
//  Copyright © 2017年 fujl. All rights reserved.
//

#import "DMLinearViewController.h"

@implementation UIView (DMLinearViewControllerMargin)

static const char DMLinearViewControllerMargin_lcBottomMargin = '\0';

- (void)setLcBottomMargin:(CGFloat)lcMargin {
    objc_setAssociatedObject(self, &DMLinearViewControllerMargin_lcBottomMargin, @(lcMargin), OBJC_ASSOCIATION_COPY);
}

- (CGFloat)lcBottomMargin {
    NSNumber *bottomMargin = objc_getAssociatedObject(self, &DMLinearViewControllerMargin_lcBottomMargin);
    if (bottomMargin) {
        return [bottomMargin floatValue];
    } else {
        return 0;
    }
}

static const char DMLinearViewControllerMargin_lcTopMargin = '\0';

- (void)setLcTopMargin:(CGFloat)lcMargin {
    objc_setAssociatedObject(self, &DMLinearViewControllerMargin_lcTopMargin, @(lcMargin), OBJC_ASSOCIATION_COPY);
}

- (CGFloat)lcTopMargin {
    NSNumber *margin = objc_getAssociatedObject(self, &DMLinearViewControllerMargin_lcTopMargin);
    if (margin) {
        return [margin floatValue];
    } else {
        return 0;
    }
}

static const char DMLinearViewControllerMargin_lcLeftMargin = '\0';

- (void)setLcLeftMargin:(CGFloat)lcMargin {
    objc_setAssociatedObject(self, &DMLinearViewControllerMargin_lcLeftMargin, @(lcMargin), OBJC_ASSOCIATION_COPY);
}

- (CGFloat)lcLeftMargin {
    NSNumber *margin = objc_getAssociatedObject(self, &DMLinearViewControllerMargin_lcLeftMargin);
    if (margin) {
        return [margin floatValue];
    } else {
        return -1;
    }
}

static const char DMLinearViewControllerMargin_lcRightMargin = '\0';

- (void)setLcRightMargin:(CGFloat)lcMargin {
    objc_setAssociatedObject(self, &DMLinearViewControllerMargin_lcRightMargin, @(lcMargin), OBJC_ASSOCIATION_COPY);
}

- (CGFloat)lcRightMargin {
    NSNumber *margin = objc_getAssociatedObject(self, &DMLinearViewControllerMargin_lcRightMargin);
    if (margin) {
        return [margin floatValue];
    } else {
        return -1;
    }
}

@end

@implementation UIView (DMLinearViewControllerSize)

static const char DMLinearViewControllerSize_lcHeight = '\0';

- (void)setLcHeight:(CGFloat)lcHeight {
    objc_setAssociatedObject(self, &DMLinearViewControllerSize_lcHeight, @(lcHeight), OBJC_ASSOCIATION_COPY);
}

- (CGFloat)lcHeight {
    NSNumber *height = objc_getAssociatedObject(self, &DMLinearViewControllerSize_lcHeight);
    if (height) {
        return [height floatValue];
    } else {
        return -1;
    }
}

static const char DMLinearViewControllerSize_lcRightWidth = '\0';

- (void)setLcWidth:(CGFloat)lcWidth {
    objc_setAssociatedObject(self, &DMLinearViewControllerSize_lcRightWidth, @(lcWidth), OBJC_ASSOCIATION_COPY);
}

- (CGFloat)lcWidth {
    NSNumber *width = objc_getAssociatedObject(self, &DMLinearViewControllerSize_lcRightWidth);
    if (width) {
        return [width floatValue];
    } else {
        return -1;
    }
}

@end

@interface DMLinearViewController ()

@property(nonatomic, strong) UIView *container;

@property(nonatomic, strong, readwrite) NSMutableArray<__kindof UIView *> *childViewList;

@end

@implementation DMLinearViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:_scrollView];

    _childViewList = [[NSMutableArray alloc] init];

    _container = [[UIView alloc] init];

    [_scrollView addSubview:_container];

    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];

    [_container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(_scrollView);
        make.width.equalTo(_scrollView);
    }];
    _gravity = DMLinearViewControllerGravityFit;
}

- (__kindof UIView *)getChildViewAtIndex:(NSUInteger)index {
    return self.childViewList[index];
}

- (NSUInteger)childViewCount {
    return self.childViewList.count;
}

- (void)removeChildViewAtIndex:(NSUInteger)index {
    [self.childViewList removeObjectAtIndex:index];
    [self setupViewLayout];
}

- (void)addChildView:(UIView *)child {
    [self addChildView:child atIndex:[self childViewCount]];
}

- (void)addChildView:(UIView *)child atIndex:(NSUInteger)index {
    [self.childViewList insertObject:child atIndex:index];
    [self setupViewLayout];
}

- (void)addChildViews:(NSArray<__kindof UIView *> *)views{
    [self.childViewList addObjectsFromArray:views];
    [self setupViewLayout];
}

- (void)setChildViews:(NSArray<__kindof UIView *> *)views {
    [self.childViewList removeAllObjects];
    [self addChildViews:views];
}

- (void)reloadViews{
    [self setupViewLayout];
}

- (void)setupViewLayout {
    NSArray<__kindof UIView *> *subviews = self.container.subviews;
    // 移除子View
    for (NSUInteger i = 0; i < subviews.count; ++i) {
        UIView *childView = subviews[i];
        [childView removeFromSuperview];
    }

    UIView *lastView;

    for (NSUInteger i = 0; i < self.childViewList.count; i++) {
        UIView *childView = self.childViewList[i];
        
        [self.container addSubview:childView];
        childView.translatesAutoresizingMaskIntoConstraints = NO;

        if (childView.lcHeight > 0) {
            // 高度约束
            [childView addConstraint:[NSLayoutConstraint constraintWithItem:childView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:childView.lcHeight]];
        }

        if (!lastView) {
            // 顶部约束
            CGFloat topMargin = childView.lcTopMargin;
            [self.container addConstraint:[NSLayoutConstraint constraintWithItem:childView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.container attribute:NSLayoutAttributeTop multiplier:1 constant:topMargin]];
        } else {
            CGFloat topMargin = lastView.lcBottomMargin + childView.lcTopMargin;
            [self.container addConstraint:[NSLayoutConstraint constraintWithItem:childView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:lastView attribute:NSLayoutAttributeBottom multiplier:1 constant:topMargin]];
        }

        CGFloat leftMargin = childView.lcLeftMargin;
        CGFloat rightMargin = childView.lcRightMargin;

        switch (self.gravity) {
            case DMLinearViewControllerGravityStart: {
                [self.container addConstraint:[NSLayoutConstraint constraintWithItem:childView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.container attribute:NSLayoutAttributeLeft multiplier:1 constant:leftMargin]];

                if (childView.lcWidth >= 0) {
                    // 宽度约束
                    [childView addConstraint:[NSLayoutConstraint constraintWithItem:childView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:childView.lcWidth]];
                } else if (rightMargin >= 0) {
                    [self.container addConstraint:[NSLayoutConstraint constraintWithItem:childView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.container attribute:NSLayoutAttributeRight multiplier:1 constant:-rightMargin]];
                }
            }
                break;
            case DMLinearViewControllerGravityEnd: {
                [self.container addConstraint:[NSLayoutConstraint constraintWithItem:childView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.container attribute:NSLayoutAttributeRight multiplier:1 constant:-rightMargin]];
                if (childView.lcWidth >= 0) {
                    // 宽度约束
                    [childView addConstraint:[NSLayoutConstraint constraintWithItem:childView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:childView.lcWidth]];
                } else if (leftMargin >= 0) {
                    [self.container addConstraint:[NSLayoutConstraint constraintWithItem:childView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.container attribute:NSLayoutAttributeLeft multiplier:1 constant:leftMargin]];
                }
            }
                break;
            case DMLinearViewControllerGravityCenter: {
                if (childView.lcWidth >= 0) {
                    // 宽度约束
                    [childView addConstraint:[NSLayoutConstraint constraintWithItem:childView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:childView.lcWidth]];
                    
                    [self.container addConstraint:[NSLayoutConstraint constraintWithItem:childView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.container attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
                } else {
                    if(leftMargin>= 0 && rightMargin >=0){
                        // fit 模式
                        [self.container addConstraint:[NSLayoutConstraint constraintWithItem:childView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.container attribute:NSLayoutAttributeLeft multiplier:1 constant:leftMargin]];
                        [self.container addConstraint:[NSLayoutConstraint constraintWithItem:childView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.container attribute:NSLayoutAttributeRight multiplier:1 constant:-rightMargin]];
                    } else {
                        [self.container addConstraint:[NSLayoutConstraint constraintWithItem:childView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.container attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
                        
                        if (leftMargin >= 0) {
                            [self.container addConstraint:[NSLayoutConstraint constraintWithItem:childView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.container attribute:NSLayoutAttributeLeft multiplier:1 constant:leftMargin]];
                            
                        } else if (rightMargin >= 0) {
                            [self.container addConstraint:[NSLayoutConstraint constraintWithItem:childView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.container attribute:NSLayoutAttributeRight multiplier:1 constant:-rightMargin]];
                        }
                    }
                }
            }
                break;
            case DMLinearViewControllerGravityFit: {
                [self.container addConstraint:[NSLayoutConstraint constraintWithItem:childView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.container attribute:NSLayoutAttributeLeft multiplier:1 constant:leftMargin]];
                [self.container addConstraint:[NSLayoutConstraint constraintWithItem:childView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.container attribute:NSLayoutAttributeRight multiplier:1 constant:-rightMargin]];
            }
                break;
        }

        if(!childView.hidden){
            lastView = childView;
        }
    }
    
    // 最后一项未隐藏的 添加底部约束
    for (NSInteger i = self.childViewList.count - 1; i >= 0; i--){
        if (!self.childViewList[i].hidden) {
            [self.container addConstraint:[NSLayoutConstraint constraintWithItem:self.childViewList[i] attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.container attribute:NSLayoutAttributeBottom multiplier:1 constant:self.childViewList[i].lcBottomMargin]];
            break;
        }
    }
}
@end
