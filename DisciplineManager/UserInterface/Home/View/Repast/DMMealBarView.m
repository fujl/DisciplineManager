//
//  DMMealBarView.m
//  DisciplineManager
//
//  Created by apple on 2017/10/11.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMMealBarView.h"
#import "DMRepastTitleView.h"
#import "PNChart.h"

@interface DMMealBarView ()

@property (nonatomic, strong) DMRepastTitleView *titleView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) PNBarChart * barChartView;

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

- (PNBarChart *)barChartView {
    if (!_barChartView) {
        _barChartView = [[PNBarChart alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
        //Y坐标label宽度(微调)
        _barChartView.yChartLabelWidth = 20.0;
        _barChartView.chartMarginLeft = 30.0;
        _barChartView.chartMarginRight = 10.0;
        _barChartView.chartMarginTop = 5.0;
        _barChartView.chartMarginBottom = 10.0;
        //X坐标刻度的上边距
        _barChartView.labelMarginTop = 2.0;
        _barChartView.showLabel = YES;
        _barChartView.showChartBorder = YES; // 坐标轴
        
        _barChartView.isGradientShow = NO; // 立体效果
        _barChartView.isShowNumbers = YES; // 显示各条状图的数值
    }
    return _barChartView;
}

- (void)setType:(RepastType)type {
    _type = type;
    if (self.type == RepastTypeBreakfast) {
        [self.titleView setTitle:[NSString stringWithFormat:@"%@%@", NSLocalizedString(@"breakfast", @"早餐"), NSLocalizedString(@"dish_chart", @"分布图")]];
    } else {
        [self.titleView setTitle:[NSString stringWithFormat:@"%@%@", NSLocalizedString(@"lunch", @"午餐"), NSLocalizedString(@"dish_chart", @"分布图")]];
    }
    [self setChartData];
}

- (void)setChartData {
    if (self.dishs.count > 0) {
        NSMutableArray *xLabels = [[NSMutableArray alloc] init];
        NSMutableArray *yValue = [[NSMutableArray alloc] init];
        for (DMStatVoteModel *mdl in self.dishs) {
            [xLabels addObject:mdl.dishesName];
            [yValue addObject:@(mdl.total)];
        }
        [self.barChartView setXLabels:xLabels];
        [self.barChartView setYValues:yValue];
    }
}

- (void)strokeChart {
    [self.barChartView strokeChart];
}

@end
