//
//  DMOrgCell.m
//  DisciplineManager
//
//  Created by apple on 2017/10/15.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMOrgCell.h"

@interface DMOrgCell ()

@property (nonatomic, strong) UILabel *nameView;

@end

@implementation DMOrgCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor colorWithRGB:0xf0f0f0];
        [self setupView];
    }
    return self;
}

- (void)setupView {
    [self.contentView addSubview:self.nameView];
    
    [self.nameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.centerY.equalTo(self.contentView);
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

- (void)setOrgInfo:(DMOrgModel *)orgInfo {
    _orgInfo = orgInfo;
    self.nameView.text = orgInfo.name;
}

@end
