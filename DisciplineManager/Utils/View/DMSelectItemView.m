//
//  DMSelectItemView.m
//  DisciplineManager
//
//  Created by apple on 2017/10/6.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMSelectItemView.h"

@interface DMSelectItemView ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *valueLabel;
@property (nonatomic, strong) UIImageView *arrowView;
@end

@implementation DMSelectItemView
- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.titleLabel];
        [self addSubview:self.valueLabel];
        [self addSubview:self.arrowView];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.centerY.equalTo(self);
        }];
        
        [self.valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.arrowView.mas_left).offset(-10);
            make.centerY.equalTo(self);
        }];
        
        UIImage *arrow = [UIImage imageNamed:@"ic_action_right"];
        [self.arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-10);
            make.centerY.equalTo(self);
            make.width.equalTo(@(arrow.size.width));
            make.height.equalTo(@(arrow.size.height));
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedGestureRecognizer)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)hiddenArrow {
    self.arrowView.hidden = YES;
    [self.valueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-10);
        make.centerY.equalTo(self);
    }];
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

- (UILabel *)valueLabel {
    if (!_valueLabel) {
        _valueLabel = [[UILabel alloc] init];
        _valueLabel.backgroundColor = [UIColor clearColor];
        _valueLabel.textAlignment = NSTextAlignmentLeft;
        _valueLabel.font = kMainFont;
    }
    return _valueLabel;
}

- (UIImageView *)arrowView {
    if (!_arrowView) {
        _arrowView = [[UIImageView alloc] init];
        [_arrowView setImage:[UIImage imageNamed:@"ic_action_right"]];
        _arrowView.userInteractionEnabled = YES;
    }
    return _arrowView;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

- (void)setValue:(NSString *)value {
    _value = value;
    self.valueLabel.text = value;
}

#pragma mark - event

- (void)clickedGestureRecognizer {
    if (self.clickEntryBlock) {
        self.clickEntryBlock(self.value);
    }
}
@end
