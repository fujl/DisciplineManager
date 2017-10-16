//
//  DMSwitchView.m
//  DisciplineManager
//
//  Created by fujl-mac on 2017/10/16.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMSwitchView.h"

@interface DMSwitchView ()

@property (nonatomic, strong) UISwitch *switchView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *bottomLine;

@end

@implementation DMSwitchView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.titleLabel];
        [self addSubview:self.switchView];
        [self addSubview:self.bottomLine];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.centerY.equalTo(self);
        }];
        [self.switchView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-10);
            make.centerY.equalTo(self);
        }];
        [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right);
            make.left.equalTo(self);
            make.bottom.equalTo(self.mas_bottom).offset(-0.5f);
            make.height.equalTo(@(0.5f));
        }];
        
        [self setIsOn:NO];
    }
    return self;
}

#pragma mark - getters and setters
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

- (UISwitch *)switchView {
    if (!_switchView) {
        _switchView = [[UISwitch alloc] init];
        [_switchView addTarget:self action:@selector(swtichAction) forControlEvents:UIControlEventValueChanged];
    }
    return _switchView;
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

- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
}

- (void)setIsOn:(BOOL)isOn {
    _switchView.on = isOn;
}

- (void)swtichAction {
    self.switchView.on = !self.switchView.on;
    if (self.onSwitchChangeBlock) {
        self.onSwitchChangeBlock(self.switchView.on);
    }
}

@end
