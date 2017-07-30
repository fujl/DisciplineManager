//
//  DMMultiLineTextView.m
//  DisciplineManager
//
//  Created by fujl-mac on 2017/6/17.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMMultiLineTextView.h"

#define kMaxMultiLineTextLength  800

@interface DMMultiLineTextView () <UITextViewDelegate>
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *placeholderLabel;
@end

@implementation DMMultiLineTextView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addSubview:self.textView];
        [self addSubview:self.placeholderLabel];
        
        [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self).offset(5);
            make.right.equalTo(self.mas_right).offset(-5);
            make.bottom.equalTo(self.mas_bottom).offset(-5);
        }];
        [self.placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.textView.mas_top).offset(4);
            make.left.equalTo(self.textView).offset(5);
            make.height.equalTo(@(20));
        }];
    }
    return self;
}


#pragma mark - getters and setters
- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.textColor = [UIColor blackColor];
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.font = kMainFont;
        _textView.delegate = self;
    }
    return _textView;
}

- (UILabel *)placeholderLabel {
    if (!_placeholderLabel) {
        _placeholderLabel = [[UILabel alloc] init];
        _placeholderLabel.font = [UIFont systemFontOfSize:14];;
        _placeholderLabel.textAlignment = NSTextAlignmentLeft;
        _placeholderLabel.textColor = [UIColor colorWithRGB:0xc4c7cc];
    }
    return _placeholderLabel;
}

- (void)setPlaceholder:(NSString *)placeholder {
    self.placeholderLabel.text = placeholder;
}

- (NSString *)getMultiLineText {
    return self.textView.text;
}

#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"";
        self.placeholderLabel.hidden = NO;
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    BOOL isCommit = textView.text.length > 0;
    self.placeholderLabel.hidden = isCommit;
    [self setMaxString];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"] ) {
        return NO;
    }
    return YES;
}

- (void)setMaxString{
    if (self.textView.text.length > kMaxMultiLineTextLength) {
        self.textView.text = [self.textView.text substringToIndex:kMaxMultiLineTextLength];
    }
}

@end
