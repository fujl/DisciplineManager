//
//  DMMoreViewController.m
//  DisciplineManager
//
//  Created by fujl-mac on 2017/6/15.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMMoreViewController.h"
#import "DMUserDetailRequester.h"
#import "DMMineItemView.h"
#import "DMUserModel.h"
#import "DMUserDetailViewController.h"
#import "DMModifyPasswordViewController.h"
@interface DMMoreViewController ()

@property (nonatomic, strong) NSMutableArray *subviewList;
@property (nonatomic, strong) DMMineItemView *mineView;
@property (nonatomic, strong) UIButton *updatePwdView;
@property (nonatomic, strong) UIButton *logoutView;

@property (nonatomic, strong) DMUserModel *user;
@end

@implementation DMMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"More",@"更多");
    
    [self.subviewList addObject:self.mineView];
    [self.subviewList addObject:self.updatePwdView];
    [self.subviewList addObject:self.logoutView];
    [self setChildViews:self.subviewList];
    
    [self getUserDetailInfo:^(DMResultCode code, id data) {
        if (code == ResultCodeOK) {
            self.user = data;
            self.mineView.user = self.user;
        }
    }];
}

- (NSMutableArray *)subviewList {
    if (!_subviewList) {
        _subviewList = [[NSMutableArray alloc] init];
    }
    return _subviewList;
}

- (DMMineItemView *)mineView {
    if (!_mineView) {
        _mineView = [[DMMineItemView alloc] init];
        [_mineView setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        _mineView.lcHeight = 70;
        [_mineView addTarget:self action:@selector(clickUserInfo) forControlEvents:UIControlEventTouchUpInside];
    }
    return _mineView;
}

- (UIButton *)updatePwdView {
    if (!_updatePwdView) {
        _updatePwdView = [[UIButton alloc] init];
        [_updatePwdView setTitle:@"修改密码" forState:UIControlStateNormal];
        [_updatePwdView setTitleColor:[UIColor colorWithRGB:0xd9534f] forState:UIControlStateNormal];
        [_updatePwdView setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        _updatePwdView.titleLabel.font = [UIFont systemFontOfSize:16];
        _updatePwdView.lcHeight = 44;
        _updatePwdView.lcTopMargin = 10;
        [_updatePwdView addTarget:self action:@selector(clickUpdatePwd) forControlEvents:UIControlEventTouchUpInside];
    }
    return _updatePwdView;
}

- (UIButton *)logoutView {
    if (!_logoutView) {
        _logoutView = [[UIButton alloc] init];
        [_logoutView setTitle:@"注销" forState:UIControlStateNormal];
        [_logoutView setTitleColor:[UIColor colorWithRGB:0xd9534f] forState:UIControlStateNormal];
        [_logoutView setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        _logoutView.titleLabel.font = [UIFont systemFontOfSize:16];
        _logoutView.lcHeight = 44;
        _logoutView.lcTopMargin = 10;
        [_logoutView addTarget:self action:@selector(clickLogout) forControlEvents:UIControlEventTouchUpInside];
    }
    return _logoutView;
}

#pragma mark - get data
- (void)getUserDetailInfo:(void (^)(DMResultCode code, id data))callback {
    DMUserDetailRequester *requester = [[DMUserDetailRequester alloc] init];
    [requester postRequest:^(DMResultCode code, id data) {
        callback(code, data);
    }];
}

- (void)clickUserInfo {
    if (self.user) {
        DMUserDetailViewController *detail = [[DMUserDetailViewController alloc] init];
        detail.user = self.user;
        detail.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detail animated:YES];
    }
}

- (void)clickLogout {
    DMUserManager *userManager = getManager([DMUserManager class]);
    [userManager logout:^(DMResultCode code, NSString *errMsg) {
        if (code == ResultCodeOK) {
            [userManager startLoginController];
        } else {
            showToast(errMsg);
        }
    }];
}

- (void)clickUpdatePwd {
    DMModifyPasswordViewController *controller = [[DMModifyPasswordViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
