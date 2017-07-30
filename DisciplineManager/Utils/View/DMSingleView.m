//
//  DMSingleView.m
//  DisciplineManager
//
//  Created by fujl-mac on 2017/7/24.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMSingleView.h"

@interface DMSingleView ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *bottomLine;
@end

@implementation DMSingleView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.titleLabel];
        [self addSubview:self.detailLabel];
        [self addSubview:self.bottomLine];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.centerY.equalTo(self);
        }];
        [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-10);
            make.centerY.equalTo(self);
        }];
        [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right);
            make.left.equalTo(self);
            make.bottom.equalTo(self.mas_bottom).offset(-0.5f);
            make.height.equalTo(@(0.5f));
        }];
    }
    return self;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = kMainFont;
        _titleLabel.textColor = [UIColor colorWithRGB:0x5f5f5f];
    }
    return _titleLabel;
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.backgroundColor = [UIColor clearColor];
        _detailLabel.textAlignment = NSTextAlignmentRight;
        _detailLabel.font = kMainFont;
        _detailLabel.textColor = [UIColor blackColor];
    }
    return _detailLabel;
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = [UIColor colorWithRGB:0xebebeb];
    }
    return _bottomLine;
}

- (void)hiddenBottomLine:(BOOL)hidden {
    self.bottomLine.hidden = hidden;
}

- (void)setTitle:(NSString *)title detail:(NSString *)detail {
    self.titleLabel.text = title;
    self.detailLabel.text = detail;
}

- (void)refreshSize:(CGSize)size {
    [self.detailLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(size.width));
        make.height.equalTo(@(size.height));
    }];
}
@end
