//
//  DMUserDetailHeadView.m
//  DisciplineManager
//
//  Created by fujl-mac on 2017/7/27.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMUserDetailHeadView.h"

@interface DMUserDetailHeadView ()
@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) UILabel *nameView;
@property (nonatomic, strong) UIImageView *arrowView;
@property (nonatomic, strong) UIView *line;
@end

@implementation DMUserDetailHeadView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.avatarView];
        [self addSubview:self.nameView];
        [self addSubview:self.arrowView];
        [self addSubview:self.line];
        
        UIImage *avatar = [UIImage imageNamed:@"male"];
        UIImage *arrow = [UIImage imageNamed:@"ic_action_right"];
        self.avatarView.image = avatar;
        self.arrowView.image = arrow;
        [self.nameView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.centerY.equalTo(self);
        }];
        [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.arrowView.mas_left).offset(-10);
            make.top.equalTo(self).offset(10);
            make.width.equalTo(@(50));
            make.height.equalTo(@(50));
        }];
        [self.arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-10);
            make.centerY.equalTo(self);
            make.width.equalTo(@(arrow.size.width));
            make.height.equalTo(@(arrow.size.height));
        }];
        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.bottom.equalTo(self.mas_bottom).offset(-0.5);
            make.width.equalTo(self);
            make.height.equalTo(@(0.5));
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
        _nameView.font = [UIFont systemFontOfSize:14];
        _nameView.textColor = [UIColor colorWithRGB:0x7f7f7f];
        _nameView.text = NSLocalizedString(@"Avatar", @"头像");
    }
    return _nameView;
}

- (UIImageView *)arrowView {
    if (!_arrowView) {
        _arrowView = [[UIImageView alloc] init];
        _arrowView.userInteractionEnabled = NO;
    }
    return _arrowView;
}

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = [UIColor colorWithRGB:0xebebeb];
    }
    return _line;
}

- (void)setGender:(DMGender)gender {
    UIImage *avatar = [UIImage imageNamed:gender == Male ? @"male" : @"female"];
    self.avatarView.image = avatar;
}
@end
