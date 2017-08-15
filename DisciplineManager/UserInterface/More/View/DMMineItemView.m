//
//  DMMineItemView.m
//  DisciplineManager
//
//  Created by fujl-mac on 2017/7/26.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMMineItemView.h"

@interface DMMineItemView ()
@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) UILabel *nameView;
@property (nonatomic, strong) UILabel *orgNameView;
@property (nonatomic, strong) UIImageView *arrowView;
@end


@implementation DMMineItemView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.avatarView];
        [self addSubview:self.nameView];
        [self addSubview:self.orgNameView];
        [self addSubview:self.arrowView];
        
        UIImage *avatar = [UIImage imageNamed:@"face"];
        UIImage *arrow = [UIImage imageNamed:@"ic_action_right"];
        self.avatarView.image = avatar;
        self.arrowView.image = arrow;
        [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.top.equalTo(self).offset(10);
            make.width.equalTo(@(50));
            make.height.equalTo(@(50));
        }];
        [self.nameView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.avatarView.mas_right).offset(10);
            make.top.equalTo(self.avatarView).offset(5);
        }];
        [self.orgNameView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.avatarView.mas_right).offset(10);
            make.bottom.equalTo(self.avatarView.mas_bottom).offset(-5);
        }];
        [self.arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-10);
            make.centerY.equalTo(self);
            make.width.equalTo(@(arrow.size.width));
            make.height.equalTo(@(arrow.size.height));
        }];
    }
    return self;
}

- (UIImageView *)avatarView {
    if (!_avatarView) {
        _avatarView = [[UIImageView alloc] init];
        _avatarView.userInteractionEnabled = YES;
    }
    return _avatarView;
}

- (UILabel *)nameView {
    if (!_nameView) {
        _nameView = [[UILabel alloc] init];
        _nameView.backgroundColor = [UIColor clearColor];
        _nameView.textAlignment = NSTextAlignmentCenter;
        _nameView.font = [UIFont systemFontOfSize:16];
        _nameView.textColor = [UIColor blackColor];
    }
    return _nameView;
}

- (UILabel *)orgNameView {
    if (!_orgNameView) {
        _orgNameView = [[UILabel alloc] init];
        _orgNameView.backgroundColor = [UIColor clearColor];
        _orgNameView.textAlignment = NSTextAlignmentCenter;
        _orgNameView.font = [UIFont systemFontOfSize:14];
        _orgNameView.textColor = [UIColor colorWithRGB:0x7f7f7f];
    }
    return _orgNameView;
}

- (UIImageView *)arrowView {
    if (!_arrowView) {
        _arrowView = [[UIImageView alloc] init];
        _arrowView.userInteractionEnabled = YES;
    }
    return _arrowView;
}

- (void)setUser:(DMUserModel *)user {
    _user = user;
    self.nameView.text = user.operatorName;
    self.orgNameView.text = user.orgInfo.name;
    UIImage *avatar = [UIImage imageNamed:user.userInfo.gender == Male ? @"male" : @"female"];
    self.avatarView.image = avatar;
}

@end
