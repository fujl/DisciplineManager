//
//  DMEntryView.m
//  DisciplineManager
//
//  Created by fujl-mac on 2017/6/16.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMEntryView.h"

@interface DMEntryView ()
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation DMEntryView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addSubview:self.titleLabel];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.centerY.equalTo(self);
        }];
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

- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
}
@end
