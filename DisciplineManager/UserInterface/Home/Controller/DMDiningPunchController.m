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

@interface DMDiningPunchController ()

@property (nonatomic, strong) NSMutableArray *subviewList;
@property (nonatomic, strong) DMMarqueeView *marqueeView;

@property (nonatomic, strong) NSMutableArray<DMDishModel *> *dishes;

@end

@implementation DMDiningPunchController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"dining_punch", @"就餐打卡");
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

@end
