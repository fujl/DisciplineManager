//
//  DMUserDetailViewController.m
//  DisciplineManager
//
//  Created by fujl-mac on 2017/7/27.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMUserDetailViewController.h"
#import "DMUserDetailHeadView.h"
#import "DMAvatarViewController.h"

@interface DMUserDetailViewController ()
@property (nonatomic, strong) NSMutableArray *subviewList;
@property (nonatomic, strong) DMUserDetailHeadView *headView;
@property (nonatomic, strong) DMSingleView *nameView;
@property (nonatomic, strong) DMSingleView *phoneView;
@property (nonatomic, strong) DMSingleView *deptView;
@property (nonatomic, strong) DMSingleView *leaderView;
@property (nonatomic, strong) DMSingleView *emailView;
@property (nonatomic, strong) DMSingleView *addressView;
@property (nonatomic, strong) DMSingleView *detailView;
@end

@implementation DMUserDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadData];
    [self loadSubview];
}

- (void)loadData {
    
    [self.nameView setTitle:@"名字" detail:self.user.userInfo.name];
    [self.phoneView setTitle:@"手机号" detail:self.user.userInfo.mobile];
    [self.deptView setTitle:@"所属部门" detail:self.user.orgInfo.name];
    [self.leaderView setTitle:@"部门领导" detail:self.user.orgInfo.operatorName];
    [self.emailView setTitle:@"电子邮箱" detail:self.user.userInfo.email];
    [self.addressView setTitle:@"地区" detail:[NSString stringWithFormat:@"%@%@%@", self.user.userInfo.province, self.user.userInfo.city, self.user.userInfo.county]];
    [self.detailView setTitle:@"详细地址" detail:self.user.userInfo.address];
}

- (void)loadSubview {
    [self.subviewList removeAllObjects];
    
    [self.subviewList addObject:self.headView];
    [self.subviewList addObject:self.nameView];
    [self.subviewList addObject:self.phoneView];
    [self.subviewList addObject:self.deptView];
    [self.subviewList addObject:self.leaderView];
    [self.subviewList addObject:self.emailView];
    [self.subviewList addObject:self.addressView];
    [self.subviewList addObject:self.detailView];
    [self setChildViews:self.subviewList];
}


- (NSMutableArray *)subviewList {
    if (!_subviewList) {
        _subviewList = [[NSMutableArray alloc] init];
    }
    return _subviewList;
}

- (DMUserDetailHeadView *)headView {
    if (!_headView) {
        _headView = [[DMUserDetailHeadView alloc] init];
        [_headView setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        _headView.lcHeight = 70;
        [_headView addTarget:self action:@selector(clickHead) forControlEvents:UIControlEventTouchUpInside];
    }
    return _headView;
}

- (DMSingleView *)nameView {
    if (!_nameView) {
        _nameView = [[DMSingleView alloc] init];
        _nameView.lcHeight = 44;
    }
    return _nameView;
}

- (DMSingleView *)phoneView {
    if (!_phoneView) {
        _phoneView = [[DMSingleView alloc] init];
        _phoneView.lcHeight = 44;
    }
    return _phoneView;
}

- (DMSingleView *)deptView {
    if (!_deptView) {
        _deptView = [[DMSingleView alloc] init];
        _deptView.lcHeight = 44;
    }
    return _deptView;
}

- (DMSingleView *)leaderView {
    if (!_leaderView) {
        _leaderView = [[DMSingleView alloc] init];
        _leaderView.lcHeight = 44;
    }
    return _leaderView;
}

- (DMSingleView *)emailView {
    if (!_emailView) {
        _emailView = [[DMSingleView alloc] init];
        _emailView.lcHeight = 44;
    }
    return _emailView;
}

- (DMSingleView *)addressView {
    if (!_addressView) {
        _addressView = [[DMSingleView alloc] init];
        _addressView.lcHeight = 44;
    }
    return _addressView;
}

- (DMSingleView *)detailView {
    if (!_detailView) {
        _detailView = [[DMSingleView alloc] init];
        _detailView.lcHeight = 44;
    }
    return _detailView;
}

- (void)clickHead {
    DMAvatarViewController *controller = [[DMAvatarViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}
@end
