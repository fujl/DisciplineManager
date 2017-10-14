//
//  DMDiningPunchController.m
//  DisciplineManager
//
//  Created by fujl-mac on 2017/10/11.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMDiningPunchController.h"
#import "DMSearchDishesRequester.h"
#import "DMDishModel.h"
#import "DMMarqueeView.h"
#import "DMSelectDinnersView.h"
#import "DMSubmitSignRequester.h"

@interface DMDiningPunchController ()

@property (nonatomic, strong) NSMutableArray *subviewList;
@property (nonatomic, strong) DMMarqueeView *marqueeView;
@property (nonatomic, strong) DMSelectDinnersView *breakfastView;
@property (nonatomic, strong) DMSelectDinnersView *lunchView;

@property (nonatomic, strong) DMEntryCommitView *commitView;

@property (nonatomic, strong) NSMutableArray<DMDishModel *> *dishes;

@end

@implementation DMDiningPunchController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"dish_vote", @"菜品投票");
    [self addNavBackItem:@selector(goBack)];
    [self loadDishes];
}

- (void)goBack {
    [self.marqueeView stop];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadSubviews {
    [self.subviewList removeAllObjects];
    [self.subviewList addObject:self.marqueeView];
    [self.subviewList addObject:self.breakfastView];
    [self.subviewList addObject:self.lunchView];
    [self.subviewList addObject:self.commitView];
    [self setChildViews:self.subviewList];
    
    [self.marqueeView start];
}

#pragma mark - load data
- (void)loadDishes {
    showLoadingDialog();
    DMSearchDishesRequester *requester = [[DMSearchDishesRequester alloc] init];
    [requester postRequest:^(DMResultCode code, id data) {
        dismissLoadingDialog();
        if (code == ResultCodeOK) {
            DMListBaseModel *listModel = data;
            self.dishes = listModel.rows;
            [self.breakfastView.dishes removeAllObjects];
            [self.lunchView.dishes removeAllObjects];
            for (DMDishModel *mdl in self.dishes) {
                if (mdl.type == RepastTypeBreakfast) {
                    [self.breakfastView.dishes addObject:mdl];
                } else {
                    [self.lunchView.dishes addObject:mdl];
                }
            }
            self.breakfastView.type = RepastTypeBreakfast;
            self.lunchView.type = RepastTypeLunch;
            [self loadSubviews];
        } else {
            NSString *errMsg = data;
            showToast(errMsg);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

#pragma mark - getters and setters
- (NSMutableArray *)subviewList {
    if (!_subviewList) {
        _subviewList = [[NSMutableArray alloc] init];
    }
    return _subviewList;
}

- (DMMarqueeView *)marqueeView {
    if (!_marqueeView) {
        _marqueeView = [[DMMarqueeView alloc] initWithTitle:NSLocalizedString(@"dishes_paoma", @"请认真选择明天需要的菜品, 有助于我们购买食材, 杜绝浪费")];
        _marqueeView.lcHeight = 44;
    }
    return _marqueeView;
}

- (DMSelectDinnersView *)breakfastView {
    if (!_breakfastView) {
        _breakfastView = [[DMSelectDinnersView alloc] init];
    }
    return _breakfastView;
}

- (DMSelectDinnersView *)lunchView {
    if (!_lunchView) {
        _lunchView = [[DMSelectDinnersView alloc] init];
    }
    return _lunchView;
}

- (DMEntryCommitView *)commitView {
    if (!_commitView) {
        _commitView = [[DMEntryCommitView alloc] init];
        _commitView.lcHeight = 64;
        __weak typeof(self) weakSelf = self;
        _commitView.clickCommitBlock = ^{
            [weakSelf commit];
        };
    }
    return _commitView;
}

- (void)commit {
    NSMutableArray *breakfasts = [[NSMutableArray alloc] init];
    NSMutableArray *lunchs = [[NSMutableArray alloc] init];
    for (DMSelectDinnerItemView *itemView in self.breakfastView.contentView.disheViewList) {
        if (itemView.selected) {
            [breakfasts addObject:@{@"id":itemView.dishModel.dishesId}];
        }
    }
    for (DMSelectDinnerItemView *itemView in self.lunchView.contentView.disheViewList) {
        if (itemView.selected) {
            [lunchs addObject:@{@"id":itemView.dishModel.dishesId}];
        }
    }
    if (breakfasts.count == 0) {
        showToast(NSLocalizedString(@"breakfast_dish_empty", @"请选择早餐菜"));
        return;
    }
    if (lunchs.count == 0) {
        showToast(NSLocalizedString(@"lunch_dish_empty", @"请选择午餐菜"));
        return;
    }
    DMSubmitSignRequester *requester = [[DMSubmitSignRequester alloc] init];
    requester.isNeedBreakfast = 1;
    requester.isNeedLunch = 1;
    requester.breakfasts = breakfasts;
    requester.lunchs = lunchs;
    showLoadingDialog();
    [requester postRequest:^(DMResultCode code, id data) {
        dismissLoadingDialog();
        if (code == ResultCodeOK) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            NSString *errMsg = data;
            showToast(errMsg);
        }
    }];
}

@end
