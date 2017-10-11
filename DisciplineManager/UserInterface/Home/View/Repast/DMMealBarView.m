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

@interface DMMealBarView () <ZFGenericChartDataSource, ZFBarChartDelegate>

@property (nonatomic, strong) DMRepastTitleView *titleView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) ZFBarChart * barChart;

@end

@implementation DMMealBarView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addSubview:self.titleView];
        [self addSubview:self.contentView];
        [self.contentView addSubview:self.barChart];
        
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
        [self.barChart mas_makeConstraints:^(MASConstraintMaker *make) {
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

- (ZFBarChart *)barChart {
    if (!_barChart) {
        _barChart = [[ZFBarChart alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
        _barChart.dataSource = self;
        _barChart.delegate = self;
        //_barChart.topicLabel.text = @"xx小学各年级人数";
        _barChart.unit = @"票";
    }
    return _barChart;
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
    [self.barChart strokePath];
}

#pragma mark - ZFGenericChartDataSource

- (NSArray *)valueArrayInGenericChart:(ZFGenericChart *)chart{
    NSMutableArray *values = [[NSMutableArray alloc] init];
    for (DMStatVoteModel *svModel in self.dishs) {
        [values addObject:[NSString stringWithFormat:@"%zd", svModel.total]];
    }
    return values;
//    return @[@"123", @"256", @"300", @"283", @"490", @"236"];
}

- (NSArray *)nameArrayInGenericChart:(ZFGenericChart *)chart{
    NSMutableArray *names = [[NSMutableArray alloc] init];
    for (DMStatVoteModel *svModel in self.dishs) {
        [names addObject:svModel.dishesName];
    }
    return names;
//    return @[@"一年级", @"二年级", @"三年级", @"四年级", @"五年级", @"六年级"];
}

- (NSArray *)colorArrayInGenericChart:(ZFGenericChart *)chart {
    return @[ZFMagenta];
}

- (CGFloat)axisLineMaxValueInGenericChart:(ZFGenericChart *)chart {
    CGFloat max = 0;
    for (DMStatVoteModel *svModel in self.dishs) {
        if (svModel.total > max) {
            max = svModel.total;
        }
    }
    return max;
}

//- (CGFloat)axisLineMinValueInGenericChart:(ZFGenericChart *)chart{
//    return 50;
//}

- (NSUInteger)axisLineSectionCountInGenericChart:(ZFGenericChart *)chart{
    return 10;
}

//- (NSInteger)axisLineStartToDisplayValueAtIndex:(ZFGenericChart *)chart{
//    return -7;
//}

- (void)genericChartDidScroll:(UIScrollView *)scrollView{
    NSLog(@"当前偏移量 ------ %f", scrollView.contentOffset.x);
}

#pragma mark - ZFBarChartDelegate

//- (CGFloat)barWidthInBarChart:(ZFBarChart *)barChart{
//    return 40.f;
//}

//- (CGFloat)paddingForGroupsInBarChart:(ZFBarChart *)barChart{
//    return 40.f;
//}

//- (id)valueTextColorArrayInBarChart:(ZFGenericChart *)barChart{
//    return ZFBlue;
//}

- (NSArray *)gradientColorArrayInBarChart:(ZFBarChart *)barChart{
    ZFGradientAttribute * gradientAttribute = [[ZFGradientAttribute alloc] init];
    gradientAttribute.colors = @[(id)ZFRed.CGColor, (id)ZFWhite.CGColor];
    gradientAttribute.locations = @[@(0.5), @(0.99)];
    
    return [NSArray arrayWithObjects:gradientAttribute, nil];
}

- (void)barChart:(ZFBarChart *)barChart didSelectBarAtGroupIndex:(NSInteger)groupIndex barIndex:(NSInteger)barIndex bar:(ZFBar *)bar popoverLabel:(ZFPopoverLabel *)popoverLabel{
    NSLog(@"第%ld组========第%ld个",(long)groupIndex,(long)barIndex);
    
    //可在此处进行bar被点击后的自身部分属性设置,可修改的属性查看ZFBar.h
    bar.barColor = ZFGold;
    bar.isAnimated = YES;
    //    bar.opacity = 0.5;
    [bar strokePath];
    
    //可将isShowAxisLineValue设置为NO，然后执行下句代码进行点击才显示数值
    //    popoverLabel.hidden = NO;
}

- (void)barChart:(ZFBarChart *)barChart didSelectPopoverLabelAtGroupIndex:(NSInteger)groupIndex labelIndex:(NSInteger)labelIndex popoverLabel:(ZFPopoverLabel *)popoverLabel{
    NSLog(@"第%ld组========第%ld个",(long)groupIndex,(long)labelIndex);
    
    //可在此处进行popoverLabel被点击后的自身部分属性设置
    //    popoverLabel.textColor = ZFSkyBlue;
    //    [popoverLabel strokePath];
}

@end
