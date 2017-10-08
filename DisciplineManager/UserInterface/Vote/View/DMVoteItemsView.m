//
//  DMVoteItemsView.m
//  DisciplineManager
//
//  Created by apple on 2017/10/4.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMVoteItemsView.h"
#import "DMAddVoteItemView.h"

#define kMaxItemCount   5

@interface DMVoteItemsView ()

@property (nonatomic, strong) DMAddVoteItemView *addItemView;
@property (nonatomic, strong) UILabel *maxTipLabel;

@end

@implementation DMVoteItemsView

- (instancetype)init {
    self = [super init];
    if (self) {
        DMVoteItemView *item1 = [self getVoteItemView];
        [item1 hiddenMinusItem];
        [self.subItemViews addObject:item1];
        DMVoteItemView *item2 = [self getVoteItemView];
        [item2 hiddenMinusItem];
        [self.subItemViews addObject:item2];
        [self layoutItemsView];
    }
    return self;
}

- (void)layoutItemsView {
    for (UIView *v in self.subviews) {
        [v removeFromSuperview];
    }
    CGFloat top = 0;
    NSInteger i = 1;
    for (DMVoteItemView *item in self.subItemViews) {
        [self addSubview:item];
        [item setPlaceholder:[NSString stringWithFormat:NSLocalizedString(@"vote_item_placeholder", @"选项%zd"), i++]];
        [item mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.right.equalTo(self.mas_right);
            make.height.equalTo(@44);
            make.top.equalTo(self).offset(top);
        }];
        top += 44;
    }
    if (self.subItemViews.count < kMaxItemCount) {
        [self addSubview:self.addItemView];
        [self.addItemView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.right.equalTo(self.mas_right);
            make.height.equalTo(@44);
            make.top.equalTo(self).offset(top);
        }];
        top += 44;
    }
    [self addSubview:self.maxTipLabel];
    [self.maxTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
        make.height.equalTo(@44);
        make.top.equalTo(self).offset(top);
    }];
    top += 44;
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(top));
    }];
}

#pragma mark - getters and setters
- (DMVoteItemView *)getVoteItemView {
    DMVoteItemView *item = [[DMVoteItemView alloc] init];
    __weak typeof(self) weakSelf = self;
    __weak typeof(DMVoteItemView *) weakItem = item;
    item.clickMinusItem = ^{
        [weakSelf clickMinusItem:weakItem];
    };
    return item;
}

- (NSMutableArray<DMVoteItemView *> *)subItemViews {
    if (!_subItemViews) {
        _subItemViews = [[NSMutableArray alloc] init];
    }
    return _subItemViews;
}

- (DMAddVoteItemView *)addItemView {
    if (!_addItemView) {
        _addItemView = [[DMAddVoteItemView alloc] init];
        __weak typeof(self) weakSelf = self;
        _addItemView.clickAddItem = ^{
            [weakSelf clickAddItem];
        };
    }
    return _addItemView;
}

- (UILabel *)maxTipLabel {
    if (!_maxTipLabel) {
        _maxTipLabel = [[UILabel alloc] init];
        _maxTipLabel.text = [NSString stringWithFormat:NSLocalizedString(@"max_tip_publish_vote", @"最多支持%zd个选项，每个选项不超过%zd个字"), kMaxItemCount, kMaxItemTextCount];
        _maxTipLabel.font = [UIFont systemFontOfSize:15.0f];
        _maxTipLabel.textColor = [UIColor grayColor];
        _maxTipLabel.backgroundColor = [UIColor clearColor];
    }
    return _maxTipLabel;
}

#pragma mark - event
- (void)clickAddItem {
    DMVoteItemView *item = [self getVoteItemView];
    [self.subItemViews addObject:item];
    [self layoutItemsViewAnimate];
}

- (void)clickMinusItem:(DMVoteItemView*)item {
    [self.subItemViews removeObject:item];
    [self layoutItemsViewAnimate];
}

- (void)layoutItemsViewAnimate {
    [UIView animateWithDuration:0.1 animations:^{
        [self layoutItemsView];
    }];
}

@end
