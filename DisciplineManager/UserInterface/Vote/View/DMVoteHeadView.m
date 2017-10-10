//
//  DMVoteHeadView.m
//  DisciplineManager
//
//  Created by apple on 2017/10/9.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMVoteHeadView.h"

@implementation DMVoteHeadView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.faceView];
        [self addSubview:self.nameLabel];
        [self addSubview:self.timeTxtLabel];
        [self addSubview:self.stateLabel];
        [self addSubview:self.contentLabel];
        
        [self.faceView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.top.equalTo(self).offset(10);
            make.width.height.equalTo(@(kUserAvatarSize));
        }];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.faceView.mas_right).offset(5);
            make.top.equalTo(self.faceView);
        }];
        [self.timeTxtLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.faceView.mas_right).offset(5);
            make.bottom.equalTo(self.faceView.mas_bottom);
        }];
        [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-10);
            make.top.equalTo(self.faceView);
            make.width.equalTo(@(60));
            make.height.equalTo(@(20));
        }];
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.right.equalTo(self.mas_right).offset(-10);
            make.top.equalTo(self.faceView.mas_bottom).offset(5);
            make.bottom.equalTo(self.mas_bottom);
        }];
    }
    return self;
}

#pragma mark - getters and setters
- (UIImageView *)faceView {
    if (!_faceView) {
        _faceView = [[UIImageView alloc] init];
        _faceView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _faceView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:14];
        _nameLabel.textColor = [UIColor colorWithRGB:0x010101];
    }
    return _nameLabel;
}

- (UILabel *)stateLabel {
    if (!_stateLabel) {
        _stateLabel = [[UILabel alloc] init];
        _stateLabel.font = [UIFont systemFontOfSize:11];
        _stateLabel.textColor = [UIColor whiteColor];
        _stateLabel.backgroundColor = [UIColor colorWithRGB:0x123456];
        _stateLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _stateLabel;
}

- (UILabel *)timeTxtLabel {
    if (!_timeTxtLabel) {
        _timeTxtLabel = [[UILabel alloc] init];
        _timeTxtLabel.font = [UIFont systemFontOfSize:11];
        _timeTxtLabel.textColor = [UIColor colorWithRGB:0x5f5f5f];
    }
    return _timeTxtLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.numberOfLines = 0;
        _contentLabel.font = [UIFont systemFontOfSize:12];
        _contentLabel.textColor = [UIColor blackColor];
    }
    return _contentLabel;
}

@end
