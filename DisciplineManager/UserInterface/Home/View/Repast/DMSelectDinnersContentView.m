//
//  DMSelectDinnersContentView.m
//  DisciplineManager
//
//  Created by apple on 2017/10/14.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMSelectDinnersContentView.h"
#define kItemHeight 64
@implementation DMSelectDinnersContentView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.disheViewList = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)setDishes:(NSMutableArray<DMDishModel *> *)dishes {
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    _dishes = dishes;
    
    [self.disheViewList removeAllObjects];
    NSInteger index = 0;
    CGFloat width = (SCREEN_WIDTH - 5)/2.0f;
    for (DMDishModel *mdl in dishes) {
        DMSelectDinnerItemView *itemView = [self itemView];
        itemView.dishModel = mdl;
        CGFloat x = index % 2 == 0 ? 0 : (width+5);
        NSInteger multiple = index / 2;
        CGFloat y = multiple*(kItemHeight+5);
        itemView.frame = CGRectMake(x, y, width, kItemHeight);
        index++;
        [self addSubview:itemView];
        [self.disheViewList addObject:itemView];
    }
    
    if (self.disheViewList.count > 0) {
        DMSelectDinnerItemView *lastView = [self.disheViewList lastObject];
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(CGRectGetMaxY(lastView.frame)));
        }];
    }
}

- (DMSelectDinnerItemView *)itemView {
    return [[DMSelectDinnerItemView alloc] init];
}
@end
