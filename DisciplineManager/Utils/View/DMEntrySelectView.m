//
//  DMEntrySelectView.m
//  DisciplineManager
//
//  Created by fujl-mac on 2017/6/16.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMEntrySelectView.h"

@interface DMEntrySelectView ()
@property (nonatomic, strong) UILabel *valueLabel;
@end

@implementation DMEntrySelectView
- (instancetype)init {
    self = [super init];
    if (self) {
        [self addSubview:self.valueLabel];
        
        [self.valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.centerY.equalTo(self);
        }];
        
        _value = @"";
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedGestureRecognizer)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

#pragma mark - getters and setters
- (UILabel *)valueLabel {
    if (!_valueLabel) {
        _valueLabel = [[UILabel alloc] init];
        _valueLabel.backgroundColor = [UIColor clearColor];
        _valueLabel.textAlignment = NSTextAlignmentLeft;
        _valueLabel.font = kMainFont;
    }
    return _valueLabel;
}

- (void)setValue:(NSString *)value {
    _value = value;
    self.valueLabel.text = value;
    self.valueLabel.textColor = [UIColor blackColor];
}

- (void)setPlaceholder:(NSString *)placeholder {
    self.valueLabel.text = placeholder;
    self.valueLabel.textColor = [UIColor colorWithRGB:0xc4c7cc];
}

- (void)clickedGestureRecognizer {
    if (self.clickEntryBlock) {
        self.clickEntryBlock(self.value);
    }
}

- (NSString *)getValue {
    return self.valueLabel.text;
}

@end
