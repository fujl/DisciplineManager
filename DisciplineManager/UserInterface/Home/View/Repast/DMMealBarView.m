//
//  DMMealBarView.m
//  DisciplineManager
//
//  Created by apple on 2017/10/11.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMMealBarView.h"
#import "DMRepastTitleView.h"
#import "ZFChart.h"
#import "DisciplineManager-Bridging-Header.h"
#import "DisciplineManager-Swift.h"

@interface DMMealBarView () <ChartViewDelegate>

@property (nonatomic, strong) DMRepastTitleView *titleView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) BarChartView * barChartView;

@end

@implementation DMMealBarView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addSubview:self.titleView];
        [self addSubview:self.contentView];
        [self.contentView addSubview:self.barChartView];
        
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
            make.height.equalTo(@(200));
        }];
        [self.barChartView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        
        _dishs = [[NSMutableArray alloc] init];
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

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
    }
    return _contentView;
}

- (BarChartView *)barChartView {
    if (!_barChartView) {
        _barChartView = [[BarChartView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
//        _barChart.dataSource = self;
        _barChartView.delegate = self;
        //_barChart.topicLabel.text = @"xx小学各年级人数";
//        _barChart.unit = @"票";
    }
    return _barChartView;
}

- (void)setType:(RepastType)type {
    _type = type;
    if (self.type == RepastTypeBreakfast) {
        [self.titleView setTitle:[NSString stringWithFormat:@"%@%@", NSLocalizedString(@"breakfast", @"早餐"), NSLocalizedString(@"dish_chart", @"菜品分布")]];
    } else {
        [self.titleView setTitle:[NSString stringWithFormat:@"%@%@", NSLocalizedString(@"lunch", @"午餐"), NSLocalizedString(@"dish_chart", @"菜品分布")]];
    }
}

- (void)strokePath {
//    [self.barChart strokePath];
}

#pragma mark - ChartViewDelegate
- (void)chartValueSelected:(ChartViewBase * __nonnull)chartView entry:(ChartDataEntry * __nonnull)entry highlight:(ChartHighlight * __nonnull)highlight {
    NSLog(@"chartValueSelected");
}

- (void)chartValueNothingSelected:(ChartViewBase * __nonnull)chartView {
    NSLog(@"chartValueNothingSelected");
}

@end
