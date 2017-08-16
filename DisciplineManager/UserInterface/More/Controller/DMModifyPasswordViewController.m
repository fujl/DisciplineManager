//
//  DMModifyPasswordViewController.m
//  DisciplineManager
//
//  Created by apple on 2017/8/16.
//  Copyright © 2017年 fujl-mac. All rights reserved.
//

#import "DMModifyPasswordViewController.h"
#import "DMModifyPasswordRequester.h"

@interface DMModifyPasswordViewController ()
@property (nonatomic, strong) NSMutableArray *subviewList;

@property (nonatomic, strong) DMEntryView *passwordTitleView;
@property (nonatomic, strong) DMSingleTextView *passwordTextView;
@property (nonatomic, strong) DMEntryView *nowPasswordTitleView;
@property (nonatomic, strong) DMSingleTextView *nowPasswordTextView;
@property (nonatomic, strong) DMEntryView *againPasswordTitleView;
@property (nonatomic, strong) DMSingleTextView *againPasswordTextView;
@property (nonatomic, strong) DMEntryCommitView *commitView;
@end

@implementation DMModifyPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"修改密码";
    [self refreshView];
}

- (void)refreshView {
    [self.subviewList removeAllObjects];
    [self.subviewList addObject:self.passwordTitleView];
    [self.subviewList addObject:self.passwordTextView];
    [self.subviewList addObject:self.nowPasswordTitleView];
    [self.subviewList addObject:self.nowPasswordTextView];
    [self.subviewList addObject:self.againPasswordTitleView];
    [self.subviewList addObject:self.againPasswordTextView];
    [self.subviewList addObject:self.commitView];
    [self setChildViews:self.subviewList];
}

#pragma mark - getters and setters
- (NSMutableArray *)subviewList {
    if (!_subviewList) {
        _subviewList = [[NSMutableArray alloc] init];
    }
    return _subviewList;
}

- (DMEntryView *)passwordTitleView {
    if (!_passwordTitleView) {
        _passwordTitleView = [[DMEntryView alloc] init];
        [_passwordTitleView setTitle:@"原密码"];
        _passwordTitleView.lcHeight = 44;
    }
    return _passwordTitleView;
}

- (DMSingleTextView *)passwordTextView {
    if (!_passwordTextView) {
        _passwordTextView = [[DMSingleTextView alloc] init];
        _passwordTextView.lcHeight = 44;
        _passwordTextView.backgroundColor = [UIColor whiteColor];
        [_passwordTextView setPlaceholder:@"请输入原密码"];
        [_passwordTextView setSecureTextEntry:YES];
    }
    return _passwordTextView;
}

- (DMEntryView *)nowPasswordTitleView {
    if (!_nowPasswordTitleView) {
        _nowPasswordTitleView = [[DMEntryView alloc] init];
        [_nowPasswordTitleView setTitle:@"新密码"];
        _nowPasswordTitleView.lcHeight = 44;
    }
    return _nowPasswordTitleView;
}

- (DMSingleTextView *)nowPasswordTextView {
    if (!_nowPasswordTextView) {
        _nowPasswordTextView = [[DMSingleTextView alloc] init];
        _nowPasswordTextView.lcHeight = 44;
        _nowPasswordTextView.backgroundColor = [UIColor whiteColor];
        [_nowPasswordTextView setSecureTextEntry:YES];
        [_nowPasswordTextView setPlaceholder:@"请输入新密码"];
    }
    return _nowPasswordTextView;
}

- (DMEntryView *)againPasswordTitleView {
    if (!_againPasswordTitleView) {
        _againPasswordTitleView = [[DMEntryView alloc] init];
        [_againPasswordTitleView setTitle:@"确认密码"];
        _againPasswordTitleView.lcHeight = 44;
    }
    return _againPasswordTitleView;
}

- (DMSingleTextView *)againPasswordTextView {
    if (!_againPasswordTextView) {
        _againPasswordTextView = [[DMSingleTextView alloc] init];
        _againPasswordTextView.lcHeight = 44;
        _againPasswordTextView.backgroundColor = [UIColor whiteColor];
        [_againPasswordTextView setSecureTextEntry:YES];
        [_againPasswordTextView setPlaceholder:@"请再次输入新密码"];
    }
    return _againPasswordTextView;
}

- (DMEntryCommitView *)commitView {
    if (!_commitView) {
        _commitView = [[DMEntryCommitView alloc] init];
        _commitView.lcHeight = 64;
        __weak typeof(self) weakSelf = self;
        _commitView.clickCommitBlock = ^{
            NSLog(@"commit");
            [AppWindow endEditing:YES];
            [weakSelf commitData];
        };
    }
    return _commitView;
}

- (void)commitData {
    if ([[self.passwordTextView getSingleText] isEqualToString:@""]) {
        showToast(@"请输入原密码");
        return;
    }
    if ([[self.nowPasswordTextView getSingleText] isEqualToString:@""]) {
        showToast(@"请输入新密码");
        return;
    }
    if ([[self.againPasswordTextView getSingleText] isEqualToString:@""]) {
        showToast(@"请再次输入新密码");
        return;
    }
    if (![[self.nowPasswordTextView getSingleText] isEqualToString:[self.againPasswordTextView getSingleText]]) {
        showToast(@"两次新密码不一致，请重新输入");
        return;
    }
    DMModifyPasswordRequester *requester = [[DMModifyPasswordRequester alloc] init];
    requester.password = [[self.passwordTextView getSingleText] md5];
    requester.nowPassword = [[self.nowPasswordTextView getSingleText] md5];
    showLoadingDialog();
    [requester postRequest:^(DMResultCode code, id data) {
        dismissLoadingDialog();
        if (code == ResultCodeOK) {
            // 修改成功
            DMUserManager *userManager = getManager([DMUserManager class]);
            [userManager logout:^(DMResultCode code, NSString *errMsg) {
                if (code == ResultCodeOK) {
                    [userManager startLoginController];
                } else {
                    showToast(errMsg);
                }
            }];
        } else {
            showToast(@"修改密码失败，请重试");
        }
    }];
}

@end
