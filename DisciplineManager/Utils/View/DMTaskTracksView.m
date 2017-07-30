//
//  DMTaskTracksView.m
//  DisciplineManager
//
//  Created by fujl-mac on 2017/7/24.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMTaskTracksView.h"
#import "DMTaskTracksItemView.h"

@interface DMTaskTracksView ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *contentView;
@end

@implementation DMTaskTracksView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.titleLabel];
        [self addSubview:self.contentView];
        
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.top.equalTo(self);
            make.height.equalTo(@44);
        }];
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.right.equalTo(self.mas_right);
            make.top.equalTo(self.titleLabel.mas_bottom);
            make.height.equalTo(@30);
        }];
    }
    return self;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = kMainFont;
        _titleLabel.textColor = [UIColor colorWithRGB:0xff9135];
        _titleLabel.text = @"任务跟踪";
    }
    return _titleLabel;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
    }
    return _contentView;
}

- (void)setTaskTracks:(NSMutableArray<DMTaskTracksModel *> *)taskTracks {
    _taskTracks = taskTracks;
    for (UIView *view in [self.contentView subviews]) {
        [view removeFromSuperview];
    }
    CGFloat y = 0;
    for (DMTaskTracksModel *mdl in taskTracks) {
        DMTaskTracksItemView *item = [[DMTaskTracksItemView alloc] init];
        item.frame = CGRectMake(0, y, SCREEN_WIDTH, 104);
        item.taskTracksModel = mdl;
        [self.contentView addSubview:item];
        y += 104;
    }
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(y));
    }];
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(y+44));
    }];
}
@end
