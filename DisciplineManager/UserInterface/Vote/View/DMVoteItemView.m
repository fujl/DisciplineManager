//
//  DMVoteItemView.m
//  DisciplineManager
//
//  Created by apple on 2017/10/4.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMVoteItemView.h"

@interface DMVoteItemView () <UITextFieldDelegate>
@property (nonatomic, strong) UIButton *minusButton;
@property (nonatomic, strong) UITextField *textView;
@property (nonatomic, strong) UIView *lineView;
@end

@implementation DMVoteItemView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.minusButton];
        [self addSubview:self.textView];
        [self addSubview:self.lineView];
        UIImage *minus = [UIImage imageNamed:@"ic_action_minus"];
        [self.minusButton setImageEdgeInsets:UIEdgeInsetsMake((40 - minus.size.height)/2.0f, 0, (40 - minus.size.height)/2.0f, 40 - minus.size.width)];
        [self.minusButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.centerY.equalTo(self);
            make.height.equalTo(@(40));
            make.width.equalTo(@(40));
        }];
        [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self.minusButton.mas_right);
            make.height.equalTo(@(40));
            make.width.equalTo(@(SCREEN_WIDTH - 40 - 20));
        }];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.right.equalTo(self.mas_right);
            make.bottom.equalTo(self.mas_bottom).offset(-0.5);
            make.height.equalTo(@(0.5));
        }];
    }
    return self;
}

#pragma mark - getters and setters
- (UIButton *)minusButton {
    if (!_minusButton) {
        _minusButton = [[UIButton alloc] init];
        [_minusButton setImage:[UIImage imageNamed:@"ic_action_minus"] forState:UIControlStateNormal];
        [_minusButton addTarget:self action:@selector(clickMinusEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _minusButton;
}

- (UITextField *)textView {
    if (!_textView) {
        _textView = [[UITextField alloc] init];
        _textView.textColor = [UIColor blackColor];
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.font = kMainFont;
        _textView.delegate = self;
    }
    return _textView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithRGB:0xebebeb];
    }
    return _lineView;
}

- (void)hiddenMinusItem {
    self.minusButton.hidden = YES;
}

- (void)setPlaceholder:(NSString *)placeholder {
    [self.textView setPlaceholder:placeholder];
}

- (NSString *)itemText {
    return self.textView.text;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *valueString = textField.text;
    
    if ([string isEqualToString:@""]) {
        // 删除
        return YES;
    } else {
        NSString *rltString = [NSString stringWithFormat:@"%@%@", valueString, string];
        if ([rltString length] > kMaxItemTextCount) {
            return NO;
        } else {
            return YES;
        }
    }
}

#pragma mark - event
- (void)clickMinusEvent {
    if (self.clickMinusItem) {
        self.clickMinusItem();
    }
}

@end
