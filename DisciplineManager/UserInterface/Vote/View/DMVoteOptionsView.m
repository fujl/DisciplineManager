//
//  DMVoteOptionsView.m
//  DisciplineManager
//
//  Created by apple on 2017/10/9.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMVoteOptionsView.h"
#import "DMVoteOptionsHeadView.h"

@interface DMVoteOptionsView ()

@property (nonatomic, strong) DMVoteOptionsHeadView *headView;
@property (nonatomic, strong) DMSingleView *endView;

@end

@implementation DMVoteOptionsView

- (instancetype)initWithInfo:(DMVoteDetailInfo *)info {
    self = [super init];
    if (self) {
        _info = info;
        [self addSubview:self.headView];
        CGFloat i = 0;
        self.optionsView = [[NSMutableArray alloc] init];
        for (DMVoteOptionInfo *optionInfo in info.options) {
            DMVoteOptionView *optionView = [self getOptionView:optionInfo];
            __weak typeof(self) weakSelf = self;
            optionView.clickOptionBlock = ^(DMVoteOptionView *optionView) {
                [weakSelf clickOption:optionView];
            };
            [self addSubview:optionView];
            [self.optionsView addObject:optionView];
            optionView.frame = CGRectMake(0, (++i)*44, SCREEN_WIDTH, 44);
        }
        [self addSubview:self.endView];
        
        [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.left.equalTo(self);
            make.right.equalTo(self.mas_right);
            make.height.equalTo(@(44));
        }];
        [self.endView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.right.equalTo(self.mas_right);
            make.top.equalTo(self).offset((self.info.options.count+1)*44);;
            make.height.equalTo(@(44));
            make.bottom.equalTo(self.mas_bottom);
        }];
    }
    return self;
}

#pragma mark - getters and setters
- (DMVoteOptionsHeadView *)headView {
    if (!_headView) {
        _headView = [[DMVoteOptionsHeadView alloc] init];
    }
    return _headView;
}

- (DMSingleView *)endView {
    if (!_endView) {
        _endView = [[DMSingleView alloc] init];
    }
    return _endView;
}

- (DMVoteOptionView *)getOptionView:(DMVoteOptionInfo *)optionInfo {
    return [[DMVoteOptionView alloc] initWithOptionInfo:optionInfo isEnd:self.info.isEnd];
}

- (void)setInfo:(DMVoteDetailInfo *)info {
    _info = info;
    if (_info.type == 0) {
        self.headView.typeLabel.text = NSLocalizedString(@"radio", @"单选");
    } else {
        self.headView.typeLabel.text = NSLocalizedString(@"checkbox", @"多选");
    }
    self.headView.totalLabel.text = [NSString stringWithFormat:NSLocalizedString(@"total_ticket", @"共%zd票"), _info.total];
    [self.endView setTitle:NSLocalizedString(@"CutoffTime", @"截止时间") detail:_info.endTime];
}

- (void)clickOption:(DMVoteOptionView *)optionView {
    if (self.info.type == 0) {
        // 单选
        for (DMVoteOptionView *oView in self.optionsView) {
            if (oView == optionView) {
                oView.optionBtn.selected = YES;
            } else {
                oView.optionBtn.selected = NO;
            }
        }
    } else {
        optionView.optionBtn.selected = !optionView.optionBtn.selected;
    }
}

@end
