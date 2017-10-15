//
//  DMSelectDinnersView.m
//  DisciplineManager
//
//  Created by apple on 2017/10/14.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMSelectDinnersView.h"
#import "DMRepastTitleView.h"

@interface DMSelectDinnersView ()

@property (nonatomic, strong) DMRepastTitleView *titleView;

@end

@implementation DMSelectDinnersView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addSubview:self.titleView];
        [self addSubview:self.contentView];
        
        _dishes = [[NSMutableArray alloc] init];
        
        [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.right.equalTo(self.mas_right);
            make.top.equalTo(self);
            make.height.equalTo(@(44));
        }];
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.right.equalTo(self.mas_right);
            make.top.equalTo(self.titleView.mas_bottom);
            make.bottom.equalTo(self.mas_bottom);
        }];
    }
    return self;
}

#pragma mark - getters and setters
- (DMRepastTitleView *)titleView {
    if (!_titleView) {
        _titleView = [[DMRepastTitleView alloc] init];
    }
    return _titleView;
}

- (DMSelectDinnersContentView *)contentView {
    if (!_contentView) {
        _contentView = [[DMSelectDinnersContentView alloc] init];
    }
    return _contentView;
}

- (void)setType:(RepastType)type {
    _type = type;
    if (self.type == RepastTypeBreakfast) {
        [self.titleView setTitle:NSLocalizedString(@"breakfast", @"早餐")];
    } else {
        [self.titleView setTitle:NSLocalizedString(@"lunch", @"午餐")];
    }
    self.contentView.dishes = self.dishes;
}

@end
