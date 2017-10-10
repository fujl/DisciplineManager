//
//  DMNumberDinersView.m
//  DisciplineManager
//
//  Created by apple on 2017/10/10.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMNumberDinersView.h"
#import "DMRepastTitleView.h"
#import "DMNumberDinersContentView.h"

@interface DMNumberDinersView ()

@property (nonatomic, strong) DMRepastTitleView *titleView;
@property (nonatomic, strong) DMNumberDinersContentView *contentView;

@end

@implementation DMNumberDinersView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addSubview:self.titleView];
        [self addSubview:self.contentView];
        
        [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.right.equalTo(self.mas_right);
            make.top.equalTo(self);
            make.height.equalTo(@(44));
        }];
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.right.equalTo(self.mas_right);
            make.top.equalTo(self.titleView.mas_bottom);
            make.height.equalTo(@(100));
        }];
    }
    return self;
}

#pragma mark - getters and setters
- (DMRepastTitleView *)titleView {
    if (!_titleView) {
        _titleView = [[DMRepastTitleView alloc] init];
    }
    return _titleView;
}

- (DMNumberDinersContentView *)contentView {
    if (!_contentView) {
        _contentView = [[DMNumberDinersContentView alloc] init];
    }
    return _contentView;
}

- (void)setNumberDinersInfo:(DMRepastTimeModel *)timeModel statTotal:(DMStatTotalModel *)statTotal {
    NSString *week = [self getWeekString:timeModel.week];
    [self.titleView setTitle:[NSString stringWithFormat:NSLocalizedString(@"number_diners_format", @"%@ %@ 就餐人数"), timeModel.date, week]];
    self.contentView.statTotalModel = statTotal;
}

#pragma mark - private method
- (NSString *)getWeekString:(NSInteger)week {
    switch (week) {
        case 1:
            return NSLocalizedString(@"Sunday", @"星期日");
        case 2:
            return NSLocalizedString(@"Monday", @"星期一");
        case 3:
            return NSLocalizedString(@"Tuesday", @"星期二");
        case 4:
            return NSLocalizedString(@"Wednesday", @"星期三");
        case 5:
            return NSLocalizedString(@"Thursday", @"星期四");
        case 6:
            return NSLocalizedString(@"Friday", @"星期五");
        default:
            return NSLocalizedString(@"Saturday", @"星期六");
    }
}

@end
