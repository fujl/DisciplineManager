//
//  DMNumberDinersContentView.m
//  DisciplineManager
//
//  Created by apple on 2017/10/10.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMNumberDinersContentView.h"
#import "DMNumberDinersItemView.h"

@interface DMNumberDinersContentView ()

@property (nonatomic, strong) DMNumberDinersItemView *breakfastView;
@property (nonatomic, strong) DMNumberDinersItemView *lunchView;

@end

@implementation DMNumberDinersContentView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.breakfastView];
        [self addSubview:self.lunchView];
        
        [self.breakfastView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.top.equalTo(self);
            make.bottom.equalTo(self.mas_bottom);
            make.width.equalTo(@(SCREEN_WIDTH/2.0f));
        }];
        [self.lunchView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right);
            make.top.equalTo(self);
            make.bottom.equalTo(self.mas_bottom);
            make.width.equalTo(@(SCREEN_WIDTH/2.0f));
        }];
    }
    return self;
}

#pragma mark - getters and setters
- (DMNumberDinersItemView *)breakfastView {
    if (!_breakfastView) {
        _breakfastView = [[DMNumberDinersItemView alloc] init];
    }
    return _breakfastView;
}

- (DMNumberDinersItemView *)lunchView {
    if (!_lunchView) {
        _lunchView = [[DMNumberDinersItemView alloc] init];
    }
    return _lunchView;
}

- (void)setStatTotalModel:(DMStatTotalModel *)statTotalModel {
    _statTotalModel = statTotalModel;
    
    [self.breakfastView setTitle:NSLocalizedString(@"breakfast", @"早餐") number:[NSString stringWithFormat:@"%zd", _statTotalModel.needBreakfast]];
    [self.lunchView setTitle:NSLocalizedString(@"lunch", @"午餐") number:[NSString stringWithFormat:@"%zd", _statTotalModel.needLunch]];
}

@end
