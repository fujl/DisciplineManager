//
//  DMVoteListCell.m
//  DisciplineManager
//
//  Created by fujl-mac on 2017/10/9.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMVoteListCell.h"

@interface DMVoteListCell ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIImageView *faceView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *timeTxtLabel;

@property (nonatomic, strong) UILabel *stateLabel;

@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *totalLabel;
@property (nonatomic, strong) UILabel *endLabel;

@property (nonatomic, strong) UIView *bottomLine;

@end

@implementation DMVoteListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.bgView];
        [self.bgView addSubview:self.faceView];
        [self.bgView addSubview:self.nameLabel];
        [self.bgView addSubview:self.timeTxtLabel];
        [self.bgView addSubview:self.stateLabel];
        [self.bgView addSubview:self.contentLabel];
        [self.bgView addSubview:self.totalLabel];
        [self.bgView addSubview:self.endLabel];
        
        [self.contentView addSubview:self.bottomLine];
        
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView);
            make.left.equalTo(self.contentView);
            make.right.equalTo(self.contentView.mas_right);
        }];
        [self.faceView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgView).offset(10);
            make.top.equalTo(self.bgView).offset(10);
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
            make.right.equalTo(self.bgView.mas_right).offset(-10);
            make.top.equalTo(self.faceView);
            make.width.equalTo(@(60));
            make.height.equalTo(@(20));
        }];
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgView).offset(10);
            make.right.equalTo(self.bgView.mas_right).offset(-10);
            make.top.equalTo(self.faceView.mas_bottom).offset(5);
        }];
        [self.totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.bgView.mas_right).offset(-10);
            make.top.equalTo(self.contentLabel.mas_bottom).offset(5);
        }];
        [self.endLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.bgView);
            make.top.equalTo(self.contentLabel.mas_bottom).offset(5);
            make.bottom.equalTo(self.bgView.mas_bottom).offset(-5);
        }];
        [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView);
            make.right.equalTo(self.contentView.mas_right);
            make.height.equalTo(@5);
            make.top.equalTo(self.bgView.mas_bottom);
            make.bottom.equalTo(self.contentView.mas_bottom);
        }];
    }
    return self;
}

#pragma mark - getters and setters
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

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

- (UILabel *)totalLabel {
    if (!_totalLabel) {
        _totalLabel = [[UILabel alloc] init];
        _totalLabel.font = [UIFont systemFontOfSize:11];
        _totalLabel.textColor = [UIColor colorWithRGB:0x7f7f7f];
    }
    return _totalLabel;
}

- (UILabel *)endLabel {
    if (!_endLabel) {
        _endLabel = [[UILabel alloc] init];
        _endLabel.font = [UIFont systemFontOfSize:13];
        _endLabel.textColor = [UIColor colorWithRGB:0x54b5ef];
    }
    return _endLabel;
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = [UIColor appBackground];
    }
    return _bottomLine;
}

- (void)setInfo:(DMVoteListInfo *)info {
    _info = info;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [DMConfig mainConfig].getServerUrl, info.face]];
    [self.faceView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"icon_error"]];
    self.nameLabel.text = info.name;
    self.timeTxtLabel.text = info.timeTxt;
    self.contentLabel.text = info.title;
    self.totalLabel.text = [NSString stringWithFormat:NSLocalizedString(@"total_ticket", @"共%zd票"), info.total];
    if (info.isEnd) {
        self.stateLabel.text = NSLocalizedString(@"has_ended", @"已结束");
        self.stateLabel.backgroundColor = [UIColor colorWithRGB:0x71b668];
        if (info.myTicket > 0) {
            self.endLabel.text = NSLocalizedString(@"voted_view_results", @"已投票，查看结果");
        } else {
            self.endLabel.text = NSLocalizedString(@"not_voting_view_results", @"未投票，查看结果");
        }
    } else {
        self.stateLabel.text = NSLocalizedString(@"under_way", @"进行中");
        self.stateLabel.backgroundColor = [UIColor colorWithRGB:0xf2a279];
        if (info.myTicket > 0) {
            self.endLabel.text = NSLocalizedString(@"voted_view_results", @"已投票，查看结果");
        } else {
            self.endLabel.text = NSLocalizedString(@"immediate_voting", @"立即投票");
        }
    }
}

@end
