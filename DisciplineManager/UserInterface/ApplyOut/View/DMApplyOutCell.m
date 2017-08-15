//
//  DMApplyOutCell.m
//  DisciplineManager
//
//  Created by fujl-mac on 2017/6/29.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMApplyOutCell.h"

@interface DMApplyOutCell ()
@property (nonatomic, strong) UILabel *reasonView;
@property (nonatomic, strong) UILabel *createDateView;
@property (nonatomic, strong) UILabel *stateView;
@property (nonatomic, strong) UIView *line;
@end

@implementation DMApplyOutCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self setupView];
    }
    return self;
}

- (void)setupView {
    [self.contentView addSubview:self.reasonView];
    [self.contentView addSubview:self.createDateView];
    [self.contentView addSubview:self.stateView];
    [self.contentView addSubview:self.line];
    
    [self.reasonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(5);
        make.top.equalTo(self.contentView).offset(5);
        make.width.equalTo(@(SCREEN_WIDTH-10));
    }];
    [self.stateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-5);
        make.height.equalTo(@(25));
        make.width.equalTo(@(60));
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-5);
    }];
    [self.createDateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.stateView);
        make.left.equalTo(self.reasonView);
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-0.5);
        make.height.equalTo(@(0.5));
    }];
}
#pragma mark - getters and setters
- (UILabel *)reasonView {
    if (!_reasonView) {
        _reasonView = [[UILabel alloc] init];
        _reasonView.textColor = [UIColor colorWithRGB:0x000000];
        _reasonView.font = [UIFont systemFontOfSize:14];
        _reasonView.numberOfLines = 2;
        _reasonView.textAlignment = NSTextAlignmentLeft;
    }
    return _reasonView;
}

- (UILabel *)createDateView {
    if (!_createDateView) {
        _createDateView = [[UILabel alloc] init];
        _createDateView.textColor = [UIColor colorWithRGB:0xb2b2b2];
        _createDateView.font = [UIFont systemFontOfSize:11];
        _createDateView.textAlignment = NSTextAlignmentLeft;
    }
    return _createDateView;
}

- (UILabel *)stateView {
    if (!_stateView) {
        _stateView = [[UILabel alloc] init];
        _stateView.textColor = [UIColor whiteColor];
        _stateView.font = [UIFont systemFontOfSize:11];
        _stateView.textAlignment = NSTextAlignmentCenter;
        _stateView.layer.masksToBounds = YES;
        _stateView.layer.cornerRadius = 3;
    }
    return _stateView;
}

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = [UIColor colorWithRGB:0xebebeb];
    }
    return _line;
}

- (void)setInfo:(DMFormBaseInfo *)info {
    _info = info;
    self.reasonView.text = info.reason;
    self.createDateView.text = info.createDate;
    switch (info.state) {
        case ACTIVITI_STATE_SAVE:
            self.stateView.text = NSLocalizedString(@"Save", @"保存");
            self.stateView.backgroundColor = [UIColor colorWithRGB:0x5bc0de];
            break;
        case ACTIVITI_STATE_PENDING:
            self.stateView.text = NSLocalizedString(@"Pending", @"待审核");
            self.stateView.backgroundColor = [UIColor colorWithRGB:0x337ab7];
            break;
        case ACTIVITI_STATE_COMPLETE:
            self.stateView.text = NSLocalizedString(@"Complete", @"已完成");
            self.stateView.backgroundColor = [UIColor colorWithRGB:0x5cb85c];
            break;
        case ACTIVITI_STATE_RATIFIED:
            self.stateView.text = @"已批准";
            self.stateView.backgroundColor = [UIColor colorWithRGB:0x5cb85c];
            break;
        case ACTIVITI_STATE_REJECTED:
            self.stateView.text = NSLocalizedString(@"Rejected", @"驳回");
            self.stateView.backgroundColor = [UIColor colorWithRGB:0xd9534f];
            break;
        default:
            self.stateView.text = NSLocalizedString(@"DataError", @"错误数据");
            self.stateView.backgroundColor = [UIColor colorWithRGB:0x777777];
            break;
    }
}

@end
