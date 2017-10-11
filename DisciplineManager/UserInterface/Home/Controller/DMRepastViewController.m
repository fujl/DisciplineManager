//
//  DMRepastViewController.m
//  DisciplineManager
//
//  Created by apple on 2017/10/4.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMRepastViewController.h"
#import "DMRepastTimeModel.h"
#import "DMStatTotalModel.h"
#import "DMStatVoteModel.h"

#import "DMRepastTimeRequester.h"
#import "DMStatTotalRequester.h"
#import "DMStatVoteRequester.h"

#import "DMNumberDinersView.h"
#import "DMSignTimeView.h"

#import "DMMealBarView.h"
#import "DMDiningPunchController.h"

@interface DMRepastViewController ()

@property (nonatomic, strong) DMRepastTimeModel *repastTimeModel;
@property (nonatomic, strong) DMStatTotalModel *statTotalModel;
@property (nonatomic, strong) NSMutableArray<DMStatVoteModel *> *dishesArray;

@property (nonatomic, strong) NSMutableArray *subviewList;
@property (nonatomic, strong) DMNumberDinersView *numberDinersView;
@property (nonatomic, strong) DMSignTimeView *signTimeView;
@property (nonatomic, strong) DMMealBarView *breakfastBarView;
@property (nonatomic, strong) DMMealBarView *lunchBarView;

@property (nonatomic, strong) DMEntryCommitView *commitView;

@end

@implementation DMRepastViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"repast", @"");
    [self addNavBackItem:@selector(goBack)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadRepastTime];
}

- (void)goBack {
    [self.signTimeView closeTimer];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.breakfastBarView strokePath];
    [self.lunchBarView strokePath];
}

- (void)dealloc {
    NSLog(@"DMRepastViewController dealloc");
}

- (void)loadSubviews {
    [self.subviewList removeAllObjects];
    [self.subviewList addObject:self.numberDinersView];
    [self.subviewList addObject:self.signTimeView];
    [self.subviewList addObject:self.breakfastBarView];
    [self.subviewList addObject:self.lunchBarView];
    if (!self.statTotalModel.isSign) {
        if (self.signTimeView.canSign) {
            [self.subviewList addObject:self.commitView];
        }
    }
    [self setChildViews:self.subviewList];
}

- (void)loadSubviewsData {
    [self.numberDinersView setNumberDinersInfo:self.repastTimeModel statTotal:self.statTotalModel];
    if (self.statTotalModel.isSign) {
        // 已经打卡
    } else {
        // 没有打卡
        self.signTimeView.repastTimeModel = self.repastTimeModel;
    }
    [self.breakfastBarView.dishs removeAllObjects];
    [self.lunchBarView.dishs removeAllObjects];
    self.breakfastBarView.type = RepastTypeBreakfast;
    self.lunchBarView.type = RepastTypeLunch;
    for (DMStatVoteModel *statVoteModel in self.dishesArray) {
        if (statVoteModel.type == RepastTypeBreakfast) {
            [self.breakfastBarView.dishs addObject:statVoteModel];
        } else {
            [self.lunchBarView.dishs addObject:statVoteModel];
        }
    }
}

#pragma mark - load data
- (void)loadRepastTime {
    DMRepastTimeRequester *requester = [[DMRepastTimeRequester alloc] init];
    showLoadingDialog();
    [requester postRequest:^(DMResultCode code, id data) {
        if (code == ResultCodeOK) {
            self.repastTimeModel = data;
            [self loadStatTotal];
        } else {
            dismissLoadingDialog();
            NSString *errMsg = data;
            showToast(errMsg);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (void)loadStatTotal {
    DMStatTotalRequester *requester = [[DMStatTotalRequester alloc] init];
    [requester postRequest:^(DMResultCode code, id data) {
        if (code == ResultCodeOK) {
            self.statTotalModel = data;
            [self loadDishesArray];
        } else {
            dismissLoadingDialog();
            NSString *errMsg = data;
            showToast(errMsg);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (void)loadDishesArray {
    DMStatVoteRequester *requester = [[DMStatVoteRequester alloc] init];
    [requester postRequest:^(DMResultCode code, id data) {
        dismissLoadingDialog();
        if (code == ResultCodeOK) {
            self.dishesArray = data;
            [self loadSubviewsData];
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

- (DMNumberDinersView *)numberDinersView {
    if (!_numberDinersView) {
        _numberDinersView = [[DMNumberDinersView alloc] init];
        _numberDinersView.lcHeight = 144;
    }
    return _numberDinersView;
}

- (DMSignTimeView *)signTimeView {
    if (!_signTimeView) {
        _signTimeView = [[DMSignTimeView alloc] init];
        _signTimeView.lcHeight = 144;
        __weak typeof(self) weakSelf = self;
        _signTimeView.signObsoleteEvent = ^{
            [weakSelf loadSubviews];
        };
    }
    return _signTimeView;
}

- (DMMealBarView *)breakfastBarView {
    if (!_breakfastBarView) {
        _breakfastBarView = [[DMMealBarView alloc] init];
        _breakfastBarView.lcHeight = 244;
    }
    return _breakfastBarView;
}

- (DMMealBarView *)lunchBarView {
    if (!_lunchBarView) {
        _lunchBarView = [[DMMealBarView alloc] init];
        _lunchBarView.lcHeight = 244;
    }
    return _lunchBarView;
}

- (DMEntryCommitView *)commitView {
    if (!_commitView) {
        _commitView = [[DMEntryCommitView alloc] init];
        _commitView.lcHeight = 64;
        [_commitView setCommitTitle:NSLocalizedString(@"dining_punch", @"就餐打卡")];
        __weak typeof(self) weakSelf = self;
        _commitView.clickCommitBlock = ^{
            NSLog(@"commit");
            [AppWindow endEditing:YES];
            [weakSelf commit];
        };
    }
    return _commitView;
}

#pragma mark - event method
- (void)commit {
    DMDiningPunchController *controller = [[DMDiningPunchController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
