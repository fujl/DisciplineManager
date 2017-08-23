//
//  DMUserBookCell.m
//  DisciplineManager
//
//  Created by fujl-mac on 2017/7/28.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMUserBookCell.h"

@interface DMUserBookCell ()

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *nameView;
@property (nonatomic, strong) UILabel *orgView;
@property (nonatomic, strong) UILabel *phoneView;

@property (nonatomic, strong) UILabel *stateView;

@property (nonatomic, strong) UIView *line;

@end

@implementation DMUserBookCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self setupView];
    }
    return self;
}

- (void)setupView {
    [self.contentView addSubview:self.nameView];
    [self.contentView addSubview:self.iconView];
    [self.contentView addSubview:self.orgView];
    [self.contentView addSubview:self.phoneView];
    [self.contentView addSubview:self.stateView];
    [self.contentView addSubview:self.line];
    
    [self.nameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView.mas_right).offset(10);
        make.top.equalTo(self.iconView);
    }];
    UIImage *icon = [UIImage imageNamed:@"male"];
    self.iconView.image = icon;
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.top.equalTo(self.contentView).offset(10);
        make.width.equalTo(@(icon.size.width/2.0f));
        make.height.equalTo(@(icon.size.height/2.0f));
    }];
    [self.orgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView.mas_right).offset(10);
        make.centerY.equalTo(self.contentView);
    }];
    [self.phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView.mas_right).offset(10);
        make.bottom.equalTo(self.iconView.mas_bottom);
    }];
    [self.stateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.top.equalTo(self.nameView);
        make.width.equalTo(@(45));
        make.height.equalTo(@(30));
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-0.5);
        make.height.equalTo(@(0.5));
    }];
}

- (UILabel *)nameView {
    if (!_nameView) {
        _nameView = [[UILabel alloc] init];
        _nameView.textColor = [UIColor colorWithRGB:0x000000];
        _nameView.font = [UIFont systemFontOfSize:16];
        _nameView.textAlignment = NSTextAlignmentLeft;
    }
    return _nameView;
}

- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [[UIImageView alloc] init];
        _iconView.image = [UIImage imageNamed:@"OrganizationStructure"];
    }
    return _iconView;
}

- (UILabel *)orgView {
    if (!_orgView) {
        _orgView = [[UILabel alloc] init];
        _orgView.textColor = [UIColor colorWithRGB:0x5f5f5f];
        _orgView.font = [UIFont systemFontOfSize:14];
        _orgView.textAlignment = NSTextAlignmentLeft;
    }
    return _orgView;
}

- (UILabel *)phoneView {
    if (!_phoneView) {
        _phoneView = [[UILabel alloc] init];
        _phoneView.textColor = [UIColor colorWithRGB:0x337ab7];
        _phoneView.font = [UIFont systemFontOfSize:14];
        _phoneView.textAlignment = NSTextAlignmentLeft;
    }
    return _phoneView;
}

- (UILabel *)stateView {
    if (!_stateView) {
        _stateView = [[UILabel alloc] init];
        _stateView.textColor = [UIColor whiteColor];
        _stateView.font = [UIFont systemFontOfSize:14];
        _stateView.textAlignment = NSTextAlignmentCenter;
        _stateView.layer.masksToBounds = YES;
        _stateView.layer.cornerRadius = 3;
    }
    return _stateView;
}


- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = [UIColor colorWithRGB:0xebebeb];
    }
    return _line;
}

- (void)setUserInfo:(DMUserBookModel *)userInfo {
    _userInfo = userInfo;
    
    self.nameView.text = userInfo.name;
    self.orgView.text = userInfo.jobName;
    self.phoneView.text = userInfo.mobile;
    
    UIImage *avatar = [UIImage imageNamed:userInfo.gender == Male ? @"male" : @"female"];
    self.iconView.image = avatar;
    
    BOOL isOut = userInfo.goOutState > 0 || userInfo.ocarState > 0;
    if (isOut) {
        self.stateView.text = NSLocalizedString(@"Out", @"外出");
        self.stateView.backgroundColor = [UIColor colorWithRGB:0x5cb85c];
    } else if (userInfo.leaveState > 0) {
        self.stateView.text = NSLocalizedString(@"Vacation", @"休假");
        self.stateView.backgroundColor = [UIColor colorWithRGB:0xd9534f];
    } else {
        self.stateView.text = NSLocalizedString(@"OnGuard", @"在岗");
        self.stateView.backgroundColor = [UIColor colorWithRGB:0x5cb85c];
    }
}

@end
