//
//  DMNoticeHeadView.m
//  DisciplineManager
//
//  Created by fujl-mac on 2017/10/15.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMNoticeHeadView.h"

#define kNormalColor [UIColor colorWithRGB:0xf0f0f0]
#define kSelectedColor [UIColor colorWithRGB:0xffffff]

@interface DMNoticeHeadView ()

@property (nonatomic, strong) UIButton *unreadButton;
@property (nonatomic, strong) UIButton *readButton;
@property (nonatomic, strong) UIButton *mineButton;

@end

@implementation DMNoticeHeadView

- (instancetype)init {
    self = [super init];
    if (self) {
        CGFloat width = SCREEN_WIDTH / 3.0f;
        [self addSubview:self.unreadButton];
        [self addSubview:self.readButton];
        [self addSubview:self.mineButton];
        
        [self.unreadButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self);
            make.height.equalTo(@(44));
            make.width.equalTo(@(width));
        }];
        [self.readButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.left.equalTo(self.unreadButton.mas_right);
            make.height.equalTo(@(44));
            make.width.equalTo(@(width));
        }];
        [self.mineButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.left.equalTo(self.readButton.mas_right);
            make.height.equalTo(@(44));
            make.width.equalTo(@(width));
        }];
    }
    return self;
}

- (UIButton *)unreadButton {
    if (!_unreadButton) {
        _unreadButton = [[UIButton alloc] init];
        [_unreadButton setBackgroundImage:[UIImage imageWithColor:kNormalColor] forState:UIControlStateNormal];
        [_unreadButton setBackgroundImage:[UIImage imageWithColor:kSelectedColor] forState:UIControlStateSelected];
        [_unreadButton setBackgroundImage:[UIImage imageWithColor:kSelectedColor] forState:UIControlStateHighlighted];
        
        [_unreadButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        _unreadButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_unreadButton addTarget:self action:@selector(clickUnreadEvent) forControlEvents:UIControlEventTouchUpInside];
        [_unreadButton setTitle:NSLocalizedString(@"unread", @"未读") forState:UIControlStateNormal];
    }
    return _unreadButton;
}

- (UIButton *)readButton {
    if (!_readButton) {
        _readButton = [[UIButton alloc] init];
        [_readButton setBackgroundImage:[UIImage imageWithColor:kNormalColor] forState:UIControlStateNormal];
        [_readButton setBackgroundImage:[UIImage imageWithColor:kSelectedColor] forState:UIControlStateSelected];
        [_readButton setBackgroundImage:[UIImage imageWithColor:kSelectedColor] forState:UIControlStateHighlighted];
        
        [_readButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        _readButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_readButton addTarget:self action:@selector(clickReadEvent) forControlEvents:UIControlEventTouchUpInside];
        [_readButton setTitle:NSLocalizedString(@"read", @"已读") forState:UIControlStateNormal];
    }
    return _readButton;
}

- (UIButton *)mineButton {
    if (!_mineButton) {
        _mineButton = [[UIButton alloc] init];
        [_mineButton setBackgroundImage:[UIImage imageWithColor:kNormalColor] forState:UIControlStateNormal];
        [_mineButton setBackgroundImage:[UIImage imageWithColor:kSelectedColor] forState:UIControlStateSelected];
        [_mineButton setBackgroundImage:[UIImage imageWithColor:kSelectedColor] forState:UIControlStateHighlighted];
        
        [_mineButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        _mineButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_mineButton addTarget:self action:@selector(clickMineEvent) forControlEvents:UIControlEventTouchUpInside];
        [_mineButton setTitle:NSLocalizedString(@"mine", @"我的") forState:UIControlStateNormal];
    }
    return _mineButton;
}

- (void)clickUnreadEvent {
    if (self.type != NoticeTypeUnread) {
        self.type = NoticeTypeUnread;
    }
}

- (void)clickReadEvent {
    if (self.type != NoticeTypeRead) {
        self.type = NoticeTypeRead;
    }
}

- (void)clickMineEvent {
    if (self.type != NoticeTypeMine) {
        self.type = NoticeTypeMine;
    }
}

- (void)setType:(NoticeType)type {
    _type = type;
    if (_type == NoticeTypeUnread) {
        self.unreadButton.selected = YES;
        self.readButton.selected = NO;
        self.mineButton.selected = NO;
    } else if (_type == NoticeTypeRead) {
        self.unreadButton.selected = NO;
        self.readButton.selected = YES;
        self.mineButton.selected = NO;
    } else {
        self.unreadButton.selected = NO;
        self.readButton.selected = NO;
        self.mineButton.selected = YES;
    }
    if (self.onSelectNoticeType) {
        self.onSelectNoticeType();
    }
}

@end
