//
//  DMVoteOptionView.m
//  DisciplineManager
//
//  Created by apple on 2017/10/9.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMVoteOptionView.h"

@interface DMVoteOptionView ()

@property (nonatomic, readwrite) UIButton *optionBtn;
@property (nonatomic, strong) UIButton *bgView;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UILabel *numberLabel;

@property (nonatomic, strong) DMVoteOptionInfo *info;
@property (nonatomic, assign) BOOL isEnd;
@end

@implementation DMVoteOptionView

- (instancetype)initWithOptionInfo:(DMVoteOptionInfo *)info isEnd:(BOOL)isEnd {
    self = [super init];
    if (self) {
        _info = info;
        _isEnd = isEnd;
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.bgView];
        if (!isEnd) {
            [self.bgView addSubview:self.optionBtn];
            UIImage *choosed = [UIImage imageNamed:@"album_imagepick_choosed"];
            [self.optionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.bgView).offset(10);
                make.centerY.equalTo(self.bgView);
                make.width.equalTo(@(choosed.size.width));
                make.height.equalTo(@(choosed.size.height));
            }];
        }
        [self addSubview:self.textLabel];
        [self addSubview:self.numberLabel];
        
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.right.equalTo(self.mas_right);
            make.top.equalTo(self).offset(1);
            make.bottom.equalTo(self).offset(-1);
        }];
        
        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            if (isEnd) {
                make.left.equalTo(self.bgView).offset(10);
            } else {
                make.left.equalTo(self.optionBtn.mas_right).offset(10);
            }
            make.centerY.equalTo(self.bgView);
        }];
        
        [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.bgView.mas_right).offset(-10);
            make.centerY.equalTo(self.bgView);
        }];
        
        self.optionBtn.selected = NO;
        self.textLabel.text = _info.text;
        self.numberLabel.text = [NSString stringWithFormat:NSLocalizedString(@"number_ticket", @"%zd票"), _info.total];
    }
    return self;
}

#pragma mark - getters and setters
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIButton alloc] init];
        _bgView.backgroundColor = [UIColor appBackground];
        [_bgView addTarget:self action:@selector(clickOption) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bgView;
}

- (UIButton *)optionBtn {
    if (!_optionBtn) {
        _optionBtn = [[UIButton alloc] init];
        [_optionBtn addTarget:self action:@selector(clickOption) forControlEvents:UIControlEventTouchUpInside];
        [_optionBtn setImage:[UIImage imageNamed:@"album_imagepick_unchoose"] forState:UIControlStateNormal];
        [_optionBtn setImage:[UIImage imageNamed:@"album_imagepick_choosed"] forState:UIControlStateSelected];
    }
    return _optionBtn;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.font = [UIFont systemFontOfSize:13];
        _textLabel.textColor = [UIColor colorWithRGB:0x5f5f5f];
    }
    return _textLabel;
}

- (UILabel *)numberLabel {
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc] init];
        _numberLabel.font = [UIFont systemFontOfSize:12];
        _numberLabel.textColor = [UIColor colorWithRGB:0x7f7f7f];
    }
    return _numberLabel;
}

- (void)clickOption {
    if (!self.isEnd) {
        if (self.clickOptionBlock) {
            self.clickOptionBlock(self);
        }
    }
}

@end
