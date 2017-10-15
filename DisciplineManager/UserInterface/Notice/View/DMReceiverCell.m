//
//  DMReceiverCell.m
//  DisciplineManager
//
//  Created by apple on 2017/10/15.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMReceiverCell.h"


@interface DMReceiverCell ()

@property (nonatomic, strong) UIButton *bgButton;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *selectedView;

@end

@implementation DMReceiverCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor colorWithRGB:0xffffff];
        [self setupView];
    }
    return self;
}

- (void)setupView {
    [self.contentView addSubview:self.bgButton];
    [self.bgButton addSubview:self.nameLabel];
    [self.bgButton addSubview:self.selectedView];
    [self.bgButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(5);
        make.centerY.equalTo(self);
        make.right.equalTo(self.selectedView.mas_left).offset(-5);
    }];
    UIImage *check = [UIImage imageNamed:@"ic_action_check"];
    [self.selectedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self.mas_right).offset(-5);
        make.width.equalTo(@(check.size.width));
        make.height.equalTo(@(check.size.height));
    }];
    self.selectedView.hidden = !self.selected;
}

#pragma mark - getters and setters
- (UIButton *)bgButton {
    if (!_bgButton) {
        _bgButton = [[UIButton alloc] init];
        [_bgButton addTarget:self action:@selector(clickReceiverInfo) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bgButton;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:14];
        _nameLabel.numberOfLines = 0;
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.userInteractionEnabled = NO;
    }
    return _nameLabel;
}

- (UIImageView *)selectedView {
    if (!_selectedView) {
        _selectedView = [[UIImageView alloc] init];
        _selectedView.image = [UIImage imageNamed:@"ic_action_check"];
        _selectedView.userInteractionEnabled = YES;
    }
    return _selectedView;
}

- (void)setUserInfo:(DMUserBookModel *)userInfo {
    _userInfo = userInfo;
    self.nameLabel.text = userInfo.name;
}

- (void)setSelectedUser:(BOOL)selectedUser {
    _selectedUser = selectedUser;
    self.selectedView.hidden = !_selectedUser;
}

- (void)clickReceiverInfo {
    self.selectedUser = !self.selectedUser;
    if (self.onSelectUserBlock) {
        self.onSelectUserBlock(self.userInfo, self.selectedUser);
    }
}

@end
