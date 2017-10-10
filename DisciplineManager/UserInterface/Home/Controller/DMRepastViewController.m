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

@interface DMRepastViewController ()

@property (nonatomic, strong) DMRepastTimeModel *repastTimeModel;
@property (nonatomic, strong) DMStatTotalModel *statTotalModel;
@property (nonatomic, strong) NSMutableArray<DMStatVoteModel *> *dishesArray;

@property (nonatomic, strong) NSMutableArray *subviewList;
@property (nonatomic, strong) DMNumberDinersView *numberDinersView;
@property (nonatomic, strong) DMSignTimeView *signTimeView;

@end

@implementation DMRepastViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"repast", @"");
    [self addNavBackItem:@selector(goBack)];
    [self loadRepastTime];
}

- (void)goBack {
    [self.signTimeView closeTimer];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc {
    NSLog(@"DMRepastViewController dealloc");
}

- (void)loadSubviews {
    [self.subviewList addObject:self.numberDinersView];
    [self.subviewList addObject:self.signTimeView];
    [self setChildViews:self.subviewList];
}

- (void)loadSubviewsData {
    [self.numberDinersView setNumberDinersInfo:self.repastTimeModel statTotal:self.statTotalModel];
    self.signTimeView.repastTimeModel = self.repastTimeModel;
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
    }
    return _signTimeView;
}

@end
