//
//  DMVoteListCell.m
//  DisciplineManager
//
//  Created by fujl-mac on 2017/10/9.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMVoteListCell.h"
#import "DMVoteHeadView.h"

@interface DMVoteListCell ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) DMVoteHeadView *headView;

@property (nonatomic, strong) UILabel *totalLabel;
@property (nonatomic, strong) UILabel *endLabel;

@property (nonatomic, strong) UIView *bottomLine;

@end

@implementation DMVoteListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.bgView];
        [self.bgView addSubview:self.headView];
        
        [self.bgView addSubview:self.totalLabel];
        [self.bgView addSubview:self.endLabel];
        
        [self.contentView addSubview:self.bottomLine];
        
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView);
            make.left.equalTo(self.contentView);
            make.right.equalTo(self.contentView.mas_right);
        }];
        [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgView);
            make.top.equalTo(self.bgView);
            make.right.equalTo(self.bgView.mas_right);
        }];
        
        [self.totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.bgView.mas_right).offset(-10);
            make.top.equalTo(self.headView.mas_bottom).offset(5);
        }];
        [self.endLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.bgView);
            make.top.equalTo(self.headView.mas_bottom).offset(5);
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

- (DMVoteHeadView *)headView {
    if (!_headView) {
        _headView = [[DMVoteHeadView alloc] init];
    }
    return _headView;
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
    [self.headView.faceView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"icon_error"]];
    self.headView.nameLabel.text = info.name;
    self.headView.timeTxtLabel.text = info.timeTxt;
    self.headView.contentLabel.text = info.title;
    self.totalLabel.text = [NSString stringWithFormat:NSLocalizedString(@"total_ticket", @"共%zd票"), info.total];
    if (info.isEnd) {
        self.headView.stateLabel.text = NSLocalizedString(@"has_ended", @"已结束");
        self.headView.stateLabel.backgroundColor = [UIColor colorWithRGB:0x71b668];
        if (info.myTicket > 0) {
            self.endLabel.text = NSLocalizedString(@"voted_view_results", @"已投票，查看结果");
        } else {
            self.endLabel.text = NSLocalizedString(@"not_voting_view_results", @"未投票，查看结果");
        }
    } else {
        self.headView.stateLabel.text = NSLocalizedString(@"under_way", @"进行中");
        self.headView.stateLabel.backgroundColor = [UIColor colorWithRGB:0xf2a279];
        if (info.myTicket > 0) {
            self.endLabel.text = NSLocalizedString(@"voted_view_results", @"已投票，查看结果");
        } else {
            self.endLabel.text = NSLocalizedString(@"immediate_voting", @"立即投票");
        }
    }
}

@end
