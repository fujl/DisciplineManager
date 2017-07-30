//
//  DMOrganizationStructureCell.m
//  DisciplineManager
//
//  Created by fujl-mac on 2017/7/28.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMOrganizationStructureCell.h"

@interface DMOrganizationStructureCell ()

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *nameView;
@property (nonatomic, strong) UIView *line;

@end

@implementation DMOrganizationStructureCell

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
    [self.contentView addSubview:self.line];
    
    [self.nameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView.mas_right).offset(10);
        make.centerY.equalTo(self.contentView);
    }];
    UIImage *icon = [UIImage imageNamed:@"OrganizationStructure"];
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.top.equalTo(self.contentView).offset(10);
        make.width.equalTo(@(icon.size.width));
        make.height.equalTo(@(icon.size.height));
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
        _nameView.font = [UIFont systemFontOfSize:14];
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

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = [UIColor colorWithRGB:0xebebeb];
    }
    return _line;
}

- (void)setOrgInfo:(DMOrgModel *)orgInfo {
    _orgInfo = orgInfo;
    self.nameView.text = orgInfo.name;
}

@end
