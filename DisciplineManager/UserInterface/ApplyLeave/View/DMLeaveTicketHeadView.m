//
//  DMLeaveTicketHeadView.m
//  DisciplineManager
//
//  Created by fujl-mac on 2017/10/24.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMLeaveTicketHeadView.h"
#import "UICountingLabel.h"
#import "DMTicketStatModel.h"

@interface DMLeaveTicketHeadView ()

@property (nonatomic, strong) UILabel *gongxiuLabel;
@property (nonatomic, strong) UILabel *buxiuLabel;

@property (nonatomic, strong) UICountingLabel *gongxiuCountLabel;
@property (nonatomic, strong) UICountingLabel *buxiuCountLabel;

@end

@implementation DMLeaveTicketHeadView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:self.gongxiuLabel];
        [self addSubview:self.gongxiuCountLabel];
        [self addSubview:self.buxiuLabel];
        [self addSubview:self.buxiuCountLabel];
        
        [self.gongxiuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.width.equalTo(@(SCREEN_WIDTH/2.0f));
            make.top.equalTo(self).offset(10);
        }];
        [self.gongxiuCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.gongxiuLabel);
            make.top.equalTo(self.gongxiuLabel.mas_bottom).offset(10);
        }];
        
        [self.buxiuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right);
            make.width.equalTo(@(SCREEN_WIDTH/2.0f));
            make.top.equalTo(self).offset(10);
        }];
        [self.buxiuCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.buxiuLabel);
            make.top.equalTo(self.buxiuLabel.mas_bottom).offset(10);
        }];
    }
    return self;
}

#pragma mark - getters and setters
- (UILabel *)gongxiuLabel {
    if (!_gongxiuLabel) {
        _gongxiuLabel = [[UILabel alloc] init];
        _gongxiuLabel.font = [UIFont systemFontOfSize:14];
        _gongxiuLabel.textColor = [UIColor colorWithRGB:0x596B93];
        _gongxiuLabel.textAlignment = NSTextAlignmentCenter;
        _gongxiuLabel.text = NSLocalizedString(@"gongxiu_ticket", @"公休假票");
    }
    return _gongxiuLabel;
}

- (UILabel *)buxiuLabel {
    if (!_buxiuLabel) {
        _buxiuLabel = [[UILabel alloc] init];
        _buxiuLabel.font = [UIFont systemFontOfSize:14];
        _buxiuLabel.textColor = [UIColor colorWithRGB:0x596B93];
        _buxiuLabel.textAlignment = NSTextAlignmentCenter;
        _buxiuLabel.text = NSLocalizedString(@"buxiu_ticket", @"补休假票");
    }
    return _buxiuLabel;
}

- (UICountingLabel *)gongxiuCountLabel {
    if (!_gongxiuCountLabel) {
        _gongxiuCountLabel = [[UICountingLabel alloc] init];
        _gongxiuCountLabel.font = [UIFont systemFontOfSize:40];
        _gongxiuCountLabel.textColor = [UIColor blackColor];
        //设置格式
        _gongxiuCountLabel.format = @"%d";
    }
    return _gongxiuCountLabel;
}

- (UICountingLabel *)buxiuCountLabel {
    if (!_buxiuCountLabel) {
        _buxiuCountLabel = [[UICountingLabel alloc] init];
        _buxiuCountLabel.font = [UIFont systemFontOfSize:40];
        _buxiuCountLabel.textColor = [UIColor blackColor];
        //设置格式
        _buxiuCountLabel.format = @"%d";
        
    }
    return _buxiuCountLabel;
}

/*
 {
 "total": 3,
 "ticketType": 0  // 公休
 }, {
 "total": 13,
 "ticketType": 1 // 补休
 }
 
 */
- (void)setStatTicketModel:(DMListBaseModel *)statTicketModel {
    _statTicketModel = statTicketModel;
    for (DMTicketStatModel *ts in statTicketModel.rows) {
        if (ts.ticketType == 0) {
            //设置变化范围及动画时间
            [self.gongxiuCountLabel countFrom:0 to:ts.total withDuration:1];
        } else if (ts.ticketType == 1) {
            //设置变化范围及动画时间
            [self.buxiuCountLabel countFrom:0 to:ts.total withDuration:1];
        }
    }
}

@end
