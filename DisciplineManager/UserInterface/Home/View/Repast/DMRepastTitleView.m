//
//  DMRepastTimeView.m
//  DisciplineManager
//
//  Created by apple on 2017/10/10.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMRepastTitleView.h"

@interface DMRepastTitleView ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation DMRepastTitleView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
    }
    return self;
}

#pragma mark - getters and setters
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = [UIColor colorWithRGB:0xd9534f];
    }
    return _titleLabel;
}

- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
}

@end
