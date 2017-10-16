//
//  DMNoticeCell.m
//  DisciplineManager
//
//  Created by fujl-mac on 2017/10/15.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMNoticeCell.h"

@interface DMNoticeCell ()


@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *createDateLabel;
@property (nonatomic, strong) UIView *line;

@end

@implementation DMNoticeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor colorWithRGB:0xffffff];
        [self setupView];
    }
    return self;
}

- (void)setupView {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.createDateLabel];
    [self.contentView addSubview:self.line];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
        make.top.equalTo(self).offset(10);
    }];
    
    [self.createDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-10);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView.mas_right);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-0.5);
        make.height.equalTo(@(0.5));
    }];
}

#pragma mark - getters and setters

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = [UIColor blackColor];
    }
    return _titleLabel;
}

- (UILabel *)createDateLabel {
    if (!_createDateLabel) {
        _createDateLabel = [[UILabel alloc] init];
        _createDateLabel.font = [UIFont systemFontOfSize:12];
        _createDateLabel.textAlignment = NSTextAlignmentLeft;
        _createDateLabel.textColor = [UIColor colorWithRGB:0x5f5f5f];
    }
    return _createDateLabel;
}

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = [UIColor colorWithRGB:0xebebeb];
    }
    return _line;
}

- (void)setNoticeInfo:(DMNoticeInfo *)noticeInfo {
    _noticeInfo = noticeInfo;
    self.titleLabel.text = noticeInfo.title;
    self.createDateLabel.text = noticeInfo.createDate;
}

@end
