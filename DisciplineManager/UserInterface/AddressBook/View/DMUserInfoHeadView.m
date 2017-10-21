//
//  DMUserInfoHeadView.m
//  DisciplineManager
//
//  Created by apple on 2017/10/20.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMUserInfoHeadView.h"
#define kUserInfoAvatarSize  80
@interface DMUserInfoHeadView()

@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) UILabel *nameView;
@property (nonatomic, strong) UILabel *firstView;

@end
@implementation DMUserInfoHeadView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addSubview:self.avatarView];
        [self.avatarView addSubview:self.firstView];
        [self addSubview:self.nameView];
        
        [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self).offset(10);
            make.width.equalTo(@(kUserInfoAvatarSize));
            make.height.equalTo(@(kUserInfoAvatarSize));
        }];
        [self.firstView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.avatarView);
        }];
        [self.nameView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.avatarView.mas_bottom).offset(10);
            make.centerX.equalTo(self);
            make.bottom.equalTo(self.mas_bottom).offset(-10);
        }];
        self.firstView.hidden = YES;
    }
    return self;
}

- (UIImageView *)avatarView {
    if (!_avatarView) {
        _avatarView = [[UIImageView alloc] init];
        _avatarView.userInteractionEnabled = YES;
        _avatarView.layer.masksToBounds = YES;
        _avatarView.layer.cornerRadius = kUserInfoAvatarSize/2.0f;
    }
    return _avatarView;
}

- (UILabel *)firstView {
    if (!_firstView) {
        _firstView = [[UILabel alloc] init];
        _firstView.backgroundColor = [UIColor clearColor];
        _firstView.textAlignment = NSTextAlignmentCenter;
        _firstView.font = [UIFont systemFontOfSize:38];
        _firstView.textColor = [UIColor whiteColor];
    }
    return _firstView;
}

- (UILabel *)nameView {
    if (!_nameView) {
        _nameView = [[UILabel alloc] init];
        _nameView.backgroundColor = [UIColor clearColor];
        _nameView.textAlignment = NSTextAlignmentCenter;
        _nameView.font = [UIFont systemFontOfSize:17];
        _nameView.textColor = [UIColor colorWithRGB:0x7f7f7f];
    }
    return _nameView;
}

- (void)setUserInfo:(DMUserBookModel *)userInfo {
    _userInfo = userInfo;
    BOOL isExistAvatar = NO;
    if (self.userInfo.face) {
        if (![self.userInfo.face isEqualToString:@""]) {
            isExistAvatar = YES;
        }
    }
    if (isExistAvatar) {
        self.firstView.hidden = YES;
        UIImage *avatar = [UIImage imageNamed:self.userInfo.gender == Male ? @"male" : @"female"];
        [self.avatarView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [DMConfig mainConfig].getServerUrl, self.userInfo.face]] placeholderImage:avatar];
    } else {
        self.firstView.hidden = NO;
        self.avatarView.image = [UIImage imageWithColor:[UIColor colorWithRGB:0x5fc0db]];
        self.firstView.text = [self.userInfo.name substringWithRange:NSMakeRange(0, 1)];
    }
    self.nameView.text = self.userInfo.name;
}

@end
