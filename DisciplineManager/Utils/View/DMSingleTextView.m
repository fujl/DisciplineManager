//
//  DMSingleTextView.m
//  DisciplineManager
//
//  Created by fujl-mac on 2017/6/17.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMSingleTextView.h"
#define kMaxSingleTextLength  24

@interface DMSingleTextView () <UITextFieldDelegate>
@property (nonatomic, strong) UITextField *textView;
@end

@implementation DMSingleTextView
- (instancetype)init {
    self = [super init];
    if (self) {
        [self addSubview:self.textView];
        
        [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self).offset(10);
            make.right.equalTo(self.mas_right).offset(-10);
            make.bottom.equalTo(self.mas_bottom).offset(-10);
        }];
    }
    return self;
}

#pragma mark - getters and setters
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

- (void)setPlaceholder:(NSString *)placeholder {
    self.textView.placeholder = placeholder;
}

- (NSString *)getSingleText {
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
        if ([rltString length] > kMaxSingleTextLength) {
            return NO;
        } else {
            return YES;
        }
    }
}
@end
