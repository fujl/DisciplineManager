//
//  DMLeaveTicketCell.m
//  DisciplineManager
//
//  Created by fujl-mac on 2017/7/29.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMLeaveTicketCell.h"

@interface DMLeaveTicketCell ()

@property (nonatomic, strong) UIImageView *selectedBtn;

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *titleView;
@property (nonatomic, strong) UILabel *leaveCountView;
@property (nonatomic, strong) UILabel *expiryDateView;

@end

@implementation DMLeaveTicketCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self setupView];
    }
    return self;
}

- (void)setupView {
    [self.contentView addSubview:self.selectedBtn];
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.titleView];
    [self.bgView addSubview:self.leaveCountView];
    [self.bgView addSubview:self.expiryDateView];
    
    UIImage *selected = [UIImage imageNamed:@"album_imagepick_unchoose"];
    [self.selectedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.centerY.equalTo(self.contentView);
        make.width.equalTo(@(selected.size.width));
        make.height.equalTo(@(selected.size.width));
    }];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.selectedBtn.mas_right).offset(10);
        make.top.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.height.equalTo(@(70));
    }];
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(10);
        make.top.equalTo(self.bgView).offset(8);
    }];
    [self.leaveCountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(10);
        make.centerY.equalTo(self.bgView);
    }];
    [self.expiryDateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(10);
        make.bottom.equalTo(self.bgView.mas_bottom).offset(-8);
    }];
}

- (UIImageView *)selectedBtn {
    if (!_selectedBtn) {
        _selectedBtn = [[UIImageView alloc] init];
        _selectedBtn.userInteractionEnabled = YES;
    }
    return _selectedBtn;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor colorWithRGB:0xe6af5e];
    }
    return _bgView;
}

- (UILabel *)titleView {
    if (!_titleView) {
        _titleView = [[UILabel alloc] init];
        _titleView.textColor = [UIColor colorWithRGB:0xffffff];
        if (IPHONE5) {
            _titleView.font = [UIFont systemFontOfSize:14];
        } else {
            _titleView.font = [UIFont systemFontOfSize:15];
        }
        _titleView.textAlignment = NSTextAlignmentLeft;
    }
    return _titleView;
}

- (UILabel *)leaveCountView {
    if (!_leaveCountView) {
        _leaveCountView = [[UILabel alloc] init];
        _leaveCountView.textColor = [UIColor colorWithRGB:0xffffff];
        _leaveCountView.font = [UIFont systemFontOfSize:12];
        _leaveCountView.textAlignment = NSTextAlignmentLeft;
    }
    return _leaveCountView;
}

- (UILabel *)expiryDateView {
    if (!_expiryDateView) {
        _expiryDateView = [[UILabel alloc] init];
        _expiryDateView.textColor = [UIColor colorWithRGB:0xffffff];
        _expiryDateView.font = [UIFont systemFontOfSize:12];
        _expiryDateView.textAlignment = NSTextAlignmentLeft;
    }
    return _expiryDateView;
}

- (void)setLeaveTicketModel:(DMLeaveTicketModel *)leaveTicketModel {
    _leaveTicketModel = leaveTicketModel;
    
    self.titleView.text = _leaveTicketModel.title;
    self.leaveCountView.text = [NSString stringWithFormat:@"休假天数：%0.1f天", _leaveTicketModel.days];
    self.expiryDateView.text = [NSString stringWithFormat:@"有效期至：%@", _leaveTicketModel.expiryDate];
    if (_leaveTicketModel.type == 0) {
        _bgView.backgroundColor = kCommitBtnColor;
    } else {
        _bgView.backgroundColor = [UIColor colorWithRGB:0xe6af5e];
    }
    [self selectedTicket];
}

- (void)selectedTicket {
    if (_leaveTicketModel.selected) {
        self.selectedBtn.image = [UIImage imageNamed:@"album_imagepick_choosed"];
    } else {
        self.selectedBtn.image = [UIImage imageNamed:@"album_imagepick_unchoose"];
    }
}

@end
