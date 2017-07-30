//
//  DMDetailView.m
//  DisciplineManager
//
//  Created by fujl-mac on 2017/6/30.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMDetailView.h"

@interface DMDetailView ()
@property (nonatomic, strong) UILabel *detailLabel;
@end

@implementation DMDetailView
- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.detailLabel];
        
        [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.top.equalTo(self).offset(5);
            make.right.equalTo(self.mas_right).offset(-10);
            make.bottom.equalTo(self.mas_bottom).offset(-5);
        }];
    }
    return self;
}

#pragma mark - getters and setters
- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.backgroundColor = [UIColor clearColor];
        _detailLabel.textAlignment = NSTextAlignmentLeft;
        _detailLabel.numberOfLines = 0;
        _detailLabel.font = kMainFont;
        _detailLabel.textColor = [UIColor blackColor];
    }
    return _detailLabel;
}

- (CGFloat)getHeightFromDetail:(NSString *)detail {
    _detail = detail;
    _detailLabel.text = detail;
    _detailLabel.textColor = [UIColor blackColor];
    return [self layoutDetail:detail];
}

- (CGFloat)getHeightFromPlaceholder:(NSString *)placeholder {
    _detail = @"";
    _detailLabel.textColor = [UIColor colorWithRGB:0xc4c7cc];
    _detailLabel.text = placeholder;
    return [self layoutDetail:placeholder];
}

- (CGFloat)layoutDetail:(NSString *)text {
    CGFloat height = 44;
    CGFloat h = [text heightForFont:kMainFont width:SCREEN_WIDTH-20];
    if ((h+10)>height) {
        height = h+10;
        [self.detailLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.top.equalTo(self).offset(5);
            make.right.equalTo(self.mas_right).offset(-10);
        }];
    } else {
        [self.detailLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.centerY.equalTo(self);
            make.right.equalTo(self.mas_right).offset(-10);
        }];
    }
    return height;
}
@end
